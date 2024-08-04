require "woozy"

class Woozy::Client
  @connection : TCPSocket?

  def initialize(@username : String)
    @connection = nil
    @connection_mutex = Mutex.new
    @packet_channel = Channel(Packet).new

    @char_channel = Channel(Chars).new
    @console_history = Array(String).new
    @console_input = Array(Char).new
    @console_cursor = 0

    @tick = 0
  end

  def connection(& : TCPSocket ->) : Nil
    @connection_mutex.synchronize do
      if (connection = @connection) && !connection.closed?
        yield connection
      end
    end
  end

  def connection=(connection : TCPSocket?)
    @connection_mutex.synchronize do
      @connection = connection
    end
  end

  def server_fiber : Nil
    bytes = Bytes.new(Packet::MaxSize)

    while (connection = @connection) && !connection.closed?
      begin
        bytes_read, _ = connection.receive(bytes)
        break if bytes_read.zero?
        packet = Packet.from_bytes(bytes[0...bytes_read].dup)
        spawn @packet_channel.send(packet)
      rescue
        break
      end
    end
  end

  def handle_packet(packet : Packet) : Nil
    case
    when server_disconnect_packet = packet.server_disconnect_packet
      Log.info &.emit "Disconnected from server", cause: server_disconnect_packet.cause
    when server_private_message_packet = packet.server_private_message_packet
      if sender = server_private_message_packet.sender
        Log.for("#{sender} > #{@username}").info { server_private_message_packet.message }
      end
    when server_broadcast_message_packet = packet.server_broadcast_message_packet
      if sender = server_broadcast_message_packet.sender
        Log.for(sender).info { server_broadcast_message_packet.message }
      end
    end
  end

  alias Chars = StaticArray(Char, 4)

  enum KeyboardAction
    Stop
    Enter
    Backspace
    Delete
    Up
    Down
    Right
    Left
  end

  def char_fiber : Nil
    bytes = Bytes.new(4)
    loop do
      bytes_read = STDIN.read(bytes)

      chars = Chars.new('\0')
      bytes_read.times do |i|
        chars[i] = bytes[i].chr
        bytes[i] = 0u8
      end

      spawn @char_channel.send(chars)
    end
  end

  def handle_chars(chars : Chars) : KeyboardAction | Chars?
    case char0 = chars[0]
    when '\u{3}', '\u{4}'
      return KeyboardAction::Stop
    when '\n' # Enter
      return KeyboardAction::Enter
    when '\u{7f}' # Backspace
      return KeyboardAction::Backspace
    when '\e'
      case char1 = chars[1]
      when '['
        case char2 = chars[2]
        when 'A' # Up
          return KeyboardAction::Up
        when 'B' # Down
          return KeyboardAction::Down
        when 'C' # Right
          return KeyboardAction::Right
        when 'D' # Left
          return KeyboardAction::Left
        when '3'
          case char3 = chars[3]
          when '~' # Delete
            return KeyboardAction::Delete
          end
        end
      end

      return nil
    else
      return chars
    end
  end

  def clear_console_input : Nil
    print "\e[2K\r" # Clears current line, then returns text cursor to origin
  end

  def update_console_input : Nil
    print "> #{@console_input.join}\r\e[#{2 + @console_cursor}C"
  end

  def handle_keyboard_action(keyboard_action : KeyboardAction | Chars, & : Array(String) ->)
    case keyboard_action
    when KeyboardAction::Stop
      self.stop
    when KeyboardAction::Enter
      command = @console_input.join
      @console_input.clear
      @console_cursor = 0
      # @console_history << command

      if !command.blank? && !command.empty?
        yield command.split(' ')
      end
    when KeyboardAction::Backspace
      if (index = @console_cursor - 1) >= 0
        @console_input.delete_at(index)
        @console_cursor = Math.max(0, @console_cursor - 1)
      end
    when KeyboardAction::Delete
      if (index = @console_cursor) >= 0 && index < @console_input.size
        @console_input.delete_at(index)
      end
    when KeyboardAction::Up
    when KeyboardAction::Down
    when KeyboardAction::Right
      @console_cursor = Math.min(@console_input.size, @console_cursor + 1)
    when KeyboardAction::Left
      @console_cursor = Math.max(0, @console_cursor - 1)
    else
      chars = keyboard_action.as Chars
      chars.each do |char|
        if char != '\0'
          @console_input.insert(@console_cursor, char)
          @console_cursor = Math.min(@console_input.size, @console_cursor + 1)
        end
      end
    end

    nil
  end

  def handle_command(command : Array(String)) : Nil
    case command[0]?
    when "help"
      self.list_commands
    when "hello"
      Log.info { "world!" }
    when "stop"
      self.stop
    when "join"
      unless address = command[1]?
        Log.error { "join <host>:<port>" }
        return
      end

      self.join_server(address)
    when "msg"
      unless username = command[1]?
        Log.error { "msg <username> <message>" }
        return
      end

      unless command[2]?
        Log.error { "msg <username> <message>" }
        return
      end

      message = command[2..].join(' ')

      unless message.blank?
        self.private_message(username, message)
      end
    when "say"
      unless command[1]?
        Log.error { "say <message>" }
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

  def list_commands : Nil
    Log.info { "Available commands: hello, help, stop, join, msg, say" }
  end

  def private_message(recipient : String, message : String) : Nil
    self.connection do |connection|
      Log.for("#{@username} > #{recipient}").info { message } # in the future should appear only when the action succeeded
      connection.send(ClientPrivateMessagePacket.new(recipient, message))
    end
  end

  def broadcast_message(message : String) : Nil
    self.connection do |connection|
      Log.for(@username).info { message }
      connection.send(ClientBroadcastMessagePacket.new(message))
    end
  end

  def leave_server : Nil
    self.connection do |connection|
      connection.send(ClientDisconnectPacket.new)
      connection.close
    end
    self.connection = nil
  end

  def join_server(address : String) : Nil
    self.leave_server

    uri = URI.parse("tcp://#{address}")

    unless host = uri.host
      Log.error &.emit "Invalid IP address", address: address
      return
    end

    begin
      connection = TCPSocket.new(URI.unwrap_ipv6(host), uri.port)
      connection.send(ClientHandshakePacket.new(@username))
      self.connection = connection

      spawn self.server_fiber
      Log.info &.emit "Connected to server", address: connection.remote_address.to_s
    rescue
      Log.error &.emit "Could not connect to IP address", address: address
    end
  end

  def start : Nil
    Woozy.set_terminal_mode
    Log.info { "Client started" }
    self.update_console_input

    spawn self.char_fiber

    loop do
      select
      when timeout(50.milliseconds)
        self.clear_console_input
        self.update
        self.update_console_input
      end
    end
  end

  def update : Nil
    # Check for new packets
    loop do
      select # Non-blocking, raising receive
      when packet = @packet_channel.receive
        self.handle_packet(packet)
      else
        break # All packets received
      end
    end

    # Check for new chars
    select
    when chars = @char_channel.receive
      if keyboard_action = self.handle_chars(chars)
        self.handle_keyboard_action(keyboard_action) do |command|
          self.handle_command(command)
        end
      end
    else
    end

    @tick += 1
  end

  def stop : NoReturn
    Log.info { "Client stopped" }

    self.connection do |connection|
      connection.send(ClientDisconnectPacket.new)
      connection.close
    end

    exit
  end
end

username = "jeb"

index = 0
while index < ARGV.size
  case ARGV[index]
  when "-u", "--username"
    username = ARGV[index + 1]
  end
  index += 2
end

begin
  client = Woozy::Client.new(username)
  client.start
rescue ex
  Log.fatal(exception: ex) { "" }
  if client
    client.stop
  end
end
