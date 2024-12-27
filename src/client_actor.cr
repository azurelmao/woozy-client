require "woozy"
require "stumpy_png"
require "./render_actor"
require "./server_actor"
require "./content"

struct Woozy::Command
  def initialize(@args : Array(String))
  end

  forward_missing_to @args
end

class Woozy::ClientActor
  @server_actor : ServerActor?

  def initialize
    @log_channel = Channel(Log::Entry).new

    Woozy.setup_terminal_mode
    Woozy.setup_logs(@log_channel)

    @client_config = SimpleConfig(Bool | Float64 | Int32).new("client.cfg", {"verify-ca" => false}) do |value|
      case value
      when "true"  then true
      when "false" then false
      when .to_i?  then value.to_i
      when .to_f?  then value.to_f
      else
        nil
      end
    end

    @stop_channel = Channel(Nil).new
    @command_channel = Channel(Command).new
    @change_channel = Channel(ConsoleInputActor::Change).new
    @key_channel = Channel({CrystGLFW::Key, CrystGLFW::Action}).new
    @server_actor_channel = Channel(ServerActor).new
    @server_disconnect_channel = Channel(Nil).new
    @chunk_channel = Channel(Chunk).new
    @content = Content.new

    @console_input_actor = ConsoleInputActor.new(@stop_channel, @command_channel, @change_channel)
    @console_output_actor = ConsoleOutputActor.new(@change_channel, @log_channel)
    @render_actor = RenderActor.new(@stop_channel, @chunk_channel, @key_channel, @content)
    @server_actor = nil
  end

  def join_server(address : String, username : String, password : String)
    uri = URI.parse("tcp://#{address}")

    unless host = uri.host
      Log.error &.emit "Invalid IP address", address: address
      return
    end

    begin
      socket = TCPSocket.new(URI.unwrap_ipv6(host), uri.port)
      remote_address = if socket.closed?
                       else
                         socket.remote_address.to_s
                       end

      context = OpenSSL::SSL::Context::Client.new
      context.verify_mode = :none unless @client_config["verify-ca"]
      OpenSSL::SSL::Socket::Client.open(socket, context) do |ssl_socket|
        ssl_socket.write(ClientHandshakePacket.new(username, password))
      end

      spawn do
        header = uninitialized StaticArray(UInt8, Packet::HeaderSize)
        bytes_read, _ = socket.receive(header.to_slice)

        if bytes_read.zero?
          cause = "Invalid handshake"
          Log.info &.emit "Disconnected client", address: remote_address, cause: cause
          next
        end

        id, size = Packet.header_from_bytes(header.to_slice)
        bytes = Bytes.new(size)

        unless socket.read_fully?(bytes)
          cause = "Invalid handshake"
          Log.info &.emit "Disconnected client", address: remote_address, cause: cause
          next
        end

        packet = Packet.from_id(id, bytes)

        case packet
        when ServerDisconnectPacket
          Log.info &.emit "Disconnected from server", cause: packet.cause
        when ServerHandshakePacket
          server_actor = ServerActor.new(@stop_channel, @server_disconnect_channel, @chunk_channel, @content, socket, username)
          @server_actor_channel.send(server_actor)
        else
          cause = "Invalid handshake"
          Log.info &.emit "Disconnected client", address: remote_address, cause: cause
        end
      end
    rescue
      Log.error &.emit "Could not connect to IP address", address: address
    end
  end

  def handle_command(command : Command) : Nil
    case command[0]?
    when "help"
      self.list_commands
    when "hello"
      Log.info { "world!" }
    when "stop"
      self.stop
    when "join"
      unless address = command[1]?
        Log.error &.emit "Command syntax:", u1: "join #{Woozy.highlight_error("<host>:<port>")} <username> <password>"
        return
      end

      unless (username = command[2]?) && Woozy.valid_username?(username)
        Log.error &.emit "Command syntax:", u1: "join <host>:<port> #{Woozy.highlight_error("<username>")} <password>"
        return
      end

      unless password = command[3]?
        Log.error &.emit "Command syntax:", u1: "join <host>:<port> <username> #{Woozy.highlight_error("<password>")}"
        return
      end

      self.join_server(address, username, password)
    when "msg", "say"
      if server_actor = @server_actor
        spawn server_actor.command_channel.send(command)
      else
        Log.error { "You have to be connected to a server to use this command" }
      end
    else
      Log.error { "Unknown command `#{command.join(' ')}`" }
    end
  end

  def list_commands : Nil
    {% begin %}
    commands = String.build do |string|
      {% for method in ClientActor.methods %}
      {% if method.name.symbolize == :handle_command %}
        {% conds = [] of StringLiteral %}
        {% for when in method.body.whens %}
          {% for cond in when.conds %}
            {% conds << cond %}
          {% end %}
        {% end %}

        {% for cond, cond_index in conds.sort %}
        string << {{cond}}

        {% if cond_index != conds.size - 1 %}
          string << ','
          string << ' '
        {% end %}
        {% end %}
        end
      {% end %}
      {% end %}
    Log.info { "Available commands: #{commands}" }
    {% end %}
  end

  def handle_key(key : CrystGLFW::Key, action : CrystGLFW::Action) : Nil
    if action.press?
      case key
      when CrystGLFW::Key::Escape
        self.stop
      when CrystGLFW::Key::W, CrystGLFW::Key::S, CrystGLFW::Key::A, CrystGLFW::Key::D
        @server_actor.try do |server_actor|
          server_actor.key_channel.send({key, action})
        end
      end
    end
  end

  def start : Nil
    Log.info { "Client started" }

    spawn @console_input_actor.start
    spawn @console_output_actor.start
    spawn @render_actor.start

    loop do
      select
      when @stop_channel.receive
        self.stop
      when @server_disconnect_channel.receive
        @server_actor.try do |server_actor|
          server_actor.stop
        end

        @server_actor = nil
      when server_actor = @server_actor_channel.receive
        Log.info &.emit "Connected to server", address: server_actor.socket.remote_address.to_s
        @server_actor = server_actor
        spawn server_actor.start
      when command = @command_channel.receive
        self.handle_command(command)
      when key_action = @key_channel.receive
        key, action = key_action
        self.handle_key(key, action)
      end
    end
  end

  def stop : NoReturn
    @server_actor.try do |server_actor|
      server_actor.stop_and_close
    end

    @render_actor.stop
    @console_output_actor.stop

    @client_config.write

    exit
  end
end
