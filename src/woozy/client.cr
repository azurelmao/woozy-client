require "woozy"

class Woozy::Connection
  getter socket : TCPSocket
  getter username : String

  def initialize(@socket, @username)
  end
end

class Woozy::Client
  @connection : Connection?

  def initialize
    @connection = nil
    @connection_mutex = Mutex.new
    @packet_channel = Channel(Packet).new

    @config = Hash(String, Bool | Float64 | Int32).new
    @config["verify-ca"] = false

    unless File.exists?("client.cfg")
      config = String.build do |string|
        @config.each do |(key, value)|
          string << key
          string << '='
          string << value
          string << '\n'
        end
      end
      File.write("client.cfg", config)
    end

    File.read("client.cfg").each_line do |line|
      data = line.strip.split('=')

      if data.size != 2
        Log.error { "Incorrect format of config entry in client.cfg, ignoring entry `#{line}`" }
        next
      end

      key, value = data

      key = key.strip
      value = value.strip

      if @config.has_key?(key)
        parsed_value = Woozy.parse_config_value(value)
        if !parsed_value.nil? && parsed_value.class == @config[key].class
          @config[key] = parsed_value
        else
          Log.error { "Invalid value `#{value}` for config key `#{key}` in client.cfg" }
        end
      else
        Log.error { "Unknown config key `#{key}` in client.cfg" }
      end
    end

    @char_channel = Channel(Slice(Char)).new
    @console_history = Array(String).new
    @console_history_index = 0
    @console_input = Array(Char).new
    @console_cursor = 0

    @tick = 0
  end

  def connection(& : Connection ->) : Nil
    @connection_mutex.synchronize do
      if (connection = @connection) && !connection.socket.closed?
        yield connection
      end
    end
  end

  def connection? : Connection?
    if (connection = @connection) && !connection.socket.closed?
      connection
    else
      nil
    end
  end

  def connection=(connection : Connection?)
    @connection_mutex.synchronize do
      @connection = connection
    end
  end

  def server_fiber : Nil
    bytes = Bytes.new(Packet::MaxSize)

    while connection = self.connection?
      begin
        bytes_read, _ = connection.socket.receive(bytes)
        break if bytes_read.zero?
        packet = Packet.from_bytes(bytes[0...bytes_read].dup)
        spawn @packet_channel.send(packet)
      rescue
        break
      end
    end
  end

  def handle_handshake : Nil
    if connection = self.connection?
      begin
        bytes = Bytes.new(Packet::MaxSize)
        bytes_read, _ = connection.socket.receive(bytes)
        return if bytes_read.zero?
        packet = Packet.from_bytes(bytes[0...bytes_read].dup)
        @packet_channel.send(packet)
      rescue
      end
    end
  end

  def handle_packet(packet : Packet) : Nil
    case
    when server_handshake_packet = packet.server_handshake_packet
      self.connection do |connection|
        Log.info &.emit "Connected to server", address: connection.socket.remote_address.to_s
        spawn self.server_fiber
      end
    when server_disconnect_packet = packet.server_disconnect_packet
      Log.info &.emit "Disconnected from server", cause: server_disconnect_packet.cause
    when server_private_message_packet = packet.server_private_message_packet
      if sender = server_private_message_packet.sender
        self.connection do |connection|
          Log.for("#{sender} > #{connection.username}").info { server_private_message_packet.message }
        end
      end
    when server_broadcast_message_packet = packet.server_broadcast_message_packet
      if sender = server_broadcast_message_packet.sender
        Log.for(sender).info { server_broadcast_message_packet.message }
      end
    end
  end

  enum KeyboardAction
    Stop
    Enter
    Backspace
    Delete
    Up
    Down
    Right
    Left
    CtrlRight
    CtrlLeft
  end

  def char_fiber : Nil
    bytes = Bytes.new(6)
    loop do
      bytes_read = STDIN.read(bytes)

      chars = Slice(Char).new(bytes_read, '\0')
      bytes_read.times do |i|
        chars[i] = bytes[i].chr
      end

      spawn @char_channel.send(chars)
    end
  end

  def handle_chars(chars : Slice(Char)) : KeyboardAction | Slice(Char)
    case char1 = chars[0]
    when '\u{3}', '\u{4}'
      return KeyboardAction::Stop
    when '\n' # Enter
      return KeyboardAction::Enter
    when '\u{7f}' # Backspace
      return KeyboardAction::Backspace
    when '\e'
      case char2 = chars[1]
      when '['
        case char3 = chars[2]
        when 'A' # Up
          return KeyboardAction::Up
        when 'B' # Down
          return KeyboardAction::Down
        when 'C' # Right
          return KeyboardAction::Right
        when 'D' # Left
          return KeyboardAction::Left
        when '3'
          case char4 = chars[3]
          when '~' # Delete
            return KeyboardAction::Delete
          end
        when '1'
          case char4 = chars[3]
          when ';'
            case char5 = chars[4]
            when '5'
              case char6 = chars[5]
              when 'C' # Ctrl + Right
                return KeyboardAction::CtrlRight
              when 'D' # Ctrl + Left
                return KeyboardAction::CtrlLeft
              end
            end
          end
        end
      end

      return Slice(Char).empty
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

  def handle_keyboard_action(keyboard_action : KeyboardAction | Slice(Char), & : Array(String) ->) : Nil
    case keyboard_action
    when KeyboardAction::Stop
      self.stop
    when KeyboardAction::Enter
      command = @console_input.join
      @console_input.clear
      @console_cursor = 0

      if !command.blank? && !command.empty?
        @console_history << command
        @console_history_index = @console_history.size
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
      unless @console_history.empty?
        @console_history_index = Math.max(0, @console_history_index - 1)
        @console_input = @console_history[@console_history_index].chars
        @console_cursor = Math.min(@console_cursor, @console_input.size)
      end
    when KeyboardAction::Down
      unless @console_history.empty?
        if @console_history_index + 1 < @console_history.size
          @console_history_index = Math.min(@console_history.size - 1, @console_history_index + 1)
          @console_input = @console_history[@console_history_index].chars
          @console_cursor = Math.min(@console_cursor, @console_input.size)
        else
          @console_history_index = @console_history.size
          @console_input.clear
          @console_cursor = 0
        end
      end
    when KeyboardAction::Right
      @console_cursor = Math.min(@console_input.size, @console_cursor + 1)
    when KeyboardAction::Left
      @console_cursor = Math.max(0, @console_cursor - 1)
    when KeyboardAction::CtrlRight
      iter = @console_input[@console_cursor..].each

      first_char = iter.next
      if first_char.is_a? Iterator::Stop
        return
      end

      index = @console_cursor + 1

      case first_char
      when .whitespace?
        while (char = iter.next) && !char.is_a? Iterator::Stop
          unless char.whitespace?
            break
          end
          index += 1
        end
      else
        while (char = iter.next) && !char.is_a? Iterator::Stop
          if char.whitespace?
            break
          end
          index += 1
        end
      end

      @console_cursor = index
    when KeyboardAction::CtrlLeft
      iter = @console_input[0...@console_cursor].reverse_each

      first_char = iter.next
      if first_char.is_a? Iterator::Stop
        return
      end

      index = @console_cursor - 1

      case first_char
      when .whitespace?
        while (char = iter.next) && !char.is_a? Iterator::Stop
          unless char.whitespace?
            break
          end
          index -= 1
        end
      else
        while (char = iter.next) && !char.is_a? Iterator::Stop
          if char.whitespace?
            break
          end
          index -= 1
        end
      end

      @console_cursor = index
    else
      chars = keyboard_action.as Slice(Char)
      chars.each do |char|
        @console_input.insert(@console_cursor, char)
        @console_cursor = Math.min(@console_input.size, @console_cursor + 1)
      end
    end
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
        Log.error &.emit "Command syntax:", u1: "join <host>:<port> <username> <password>"
        return
      end

      unless (username = command[2]?) && Woozy.valid_username?(username)
        Log.error &.emit "Command syntax:", u1: "join <host>:<port> <username> <password>"
        return
      end

      unless password = command[3]?
        Log.error &.emit "Command syntax:", u1: "join <host>:<port> <username> <password>"
        return
      end

      self.join_server(address, username, password)
    when "msg"
      unless (username = command[1]?) && Woozy.valid_username?(username)
        Log.error &.emit "Command syntax:", u1: "msg <username> <message>"
        return
      end

      unless command[2]?
        Log.error &.emit "Command syntax:", u1: "msg <username> <message>"
        return
      end

      message = command[2..].join(' ')

      unless message.blank?
        self.private_message(username, message)
      end
    when "say"
      unless command[1]?
        Log.error &.emit "Command syntax:", u1: "say <message>"
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
    {% begin %}
    commands = String.build do |string|
    {% for method in Client.methods %}
    {% if method.name.symbolize == :handle_command %}
    {% commands = method.body.whens.map(&.conds.first) %}
    {% for command, index in commands %}
      string << {{command}}

      {% if index != commands.size - 1 %}
        string << ','
        string << ' '
      {% end %}
    {% end %}
    {% end %}
    {% end %}
    end
    {% end %}

    Log.info { "Available commands: #{commands}" }
  end

  def private_message(recipient : String, message : String) : Nil
    self.connection do |connection|
      Log.for("#{connection.username} > #{recipient}").info { message } # in the future should appear only when the action succeeded
      connection.socket.send(ClientPrivateMessagePacket.new(recipient, message))
    end
  end

  def broadcast_message(message : String) : Nil
    self.connection do |connection|
      Log.for(connection.username).info { message }
      connection.socket.send(ClientBroadcastMessagePacket.new(message))
    end
  end

  def leave_server : Nil
    self.connection do |connection|
      connection.socket.send(ClientDisconnectPacket.new)
      connection.socket.close
    end
    self.connection = nil
  end

  def join_server(address : String, username : String, password : String) : Nil
    self.leave_server

    uri = URI.parse("tcp://#{address}")

    unless host = uri.host
      Log.error &.emit "Invalid IP address", address: address
      return
    end

    begin
      self.connection = Connection.new(TCPSocket.new(URI.unwrap_ipv6(host), uri.port), username)

      self.connection do |connection|
        context = OpenSSL::SSL::Context::Client.new
        context.verify_mode = :none unless @config["verify-ca"]
        OpenSSL::SSL::Socket::Client.open(connection.socket, context) do |ssl_socket|
          ssl_socket.write(ClientHandshakePacket.new(username, password))
        end
      end

      spawn self.handle_handshake
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
      connection.socket.send(ClientDisconnectPacket.new)
      connection.socket.close
    end

    config = String.build do |string|
      @config.each do |(key, value)|
        string << key
        string << '='
        string << value
        string << '\n'
      end
    end
    File.write("client.cfg", config)

    exit
  end
end
