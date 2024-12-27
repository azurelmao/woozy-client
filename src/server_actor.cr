require "./incoming_packet_actor"

class Woozy::ServerActor
  @stop_channel : Channel(Nil)
  @server_disconnect_channel : Channel(Nil)
  @chunk_channel : Channel(Chunk)
  @content : Content
  getter socket : TCPSocket
  @username : String
  getter key_channel : Channel({CrystGLFW::Key, CrystGLFW::Action})
  getter command_channel : Channel(Command)

  def initialize(@stop_channel, @server_disconnect_channel, @chunk_channel, @content, @socket, @username)
    @key_channel = Channel({CrystGLFW::Key, CrystGLFW::Action}).new
    @command_channel = Channel(Command).new
    @incoming_packet_channel = Channel(Packet).new
    @incoming_packet_actor = IncomingPacketActor.new(@socket, @incoming_packet_channel)
    @self_stop_channel = Channel(Nil).new
    @tick = 0
  end

  def private_message(recipient : String, message : String) : Nil
    @socket.send(ClientPrivateMessagePacket.new(recipient, message))
  end

  def broadcast_message(message : String) : Nil
    Log.for(@username).info { message }
    @socket.send(ClientBroadcastMessagePacket.new(message))
  end

  def handle_packet(packet : Packet) : Nil
    case packet
    when ServerDisconnectPacket
      Log.info &.emit "Disconnected from server", cause: packet.cause
      @server_disconnect_channel.send(nil)
    when ServerPrivateMessagePacket
      sender = packet.sender
      message = packet.message

      Log.for("#{sender} > #{@username}").info { message }
    when ServerPrivateMessageSuccessPacket
      recipient = packet.recipient
      message = packet.message
      success = packet.success

      if success
        Log.for("#{@username} > #{recipient}").info { message }
      else
        Log.error { "Could not send private message to client `#{recipient}`" }
      end
    when ServerBroadcastMessagePacket
      sender = packet.sender

      Log.for(sender).info { packet.message }
    when ServerChunkPacket
      x = packet.x
      y = packet.y
      z = packet.z
      position = ChunkPos.new(x, y, z)

      block_palette = Hash(UInt16, Block).new
      packet.block_palette.each do |(key, value)|
        block_idx = @content.blocks.index_of(value)
        block_palette[key] = Block.new(block_idx)
      end

      block_ids = packet.block_ids

      chunk = Chunk.new(position, block_palette, block_ids)
      @chunk_channel.send(chunk)
    end
  end

  def handle_command(command : Command)
    case command[0]
    when "msg"
      unless (username = command[1]?) && Woozy.valid_username?(username)
        Log.error &.emit "Command syntax:", u1: "msg #{Woozy.highlight_error("<username>")} <message>"
        return
      end

      unless command[2]?
        Log.error &.emit "Command syntax:", u1: "msg <username> #{Woozy.highlight_error("<message>")}"
        return
      end

      message = command[2..].join(' ')

      unless message.blank?
        self.private_message(username, message)
      end
    when "say"
      unless command[1]?
        Log.error &.emit "Command syntax:", u1: "say #{Woozy.highlight_error("<message>")}"
        return
      end

      message = command[1..].join(' ')

      unless message.blank?
        self.broadcast_message(message)
      end
    else
      Log.error { "Unknown command `#{command.join(' ')}`" }
    end
  end

  def handle_key(key : CrystGLFW::Key, action : CrystGLFW::Action) : Nil
    if action.press?
      case key
      when CrystGLFW::Key::W
      when CrystGLFW::Key::S
      when CrystGLFW::Key::A
      when CrystGLFW::Key::D
      end
    end
  end

  def start
    spawn @incoming_packet_actor.start

    loop do
      select
      when @self_stop_channel.receive
        break
      when timeout(50.milliseconds)
        self.update
      end
    end
  end

  def update : Nil
    # Check for new packets
    loop do
      select # Non-blocking, raising receive
      when packet = @incoming_packet_channel.receive
        self.handle_packet(packet)
      else
        break # All packets received
      end
    end

    # Check for new commands
    loop do
      select # Non-blocking, raising receive
      when command = @command_channel.receive
        self.handle_command(command)
      else
        break # All commands received
      end
    end

    loop do
      select
      when key_action = @key_channel.receive
        key, action = key_action
        self.handle_key(key, action)
      else
        break
      end
    end

    @tick += 1
  end

  def stop_and_close : Nil
    self.stop
    @socket.send(ClientDisconnectPacket.new)
    @socket.close
  end

  def stop : Nil
    @self_stop_channel.send(nil)
  end
end
