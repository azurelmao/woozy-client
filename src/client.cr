require "woozy"

struct Woozy::Client
  def initialize
    @connection = TCPSocket.new
    @packet_channel = Channel(Packet).new
    @username = "jeb"

    @char_channel = Channel(Chars).new
    @console_input = Array(Char).new
    @console_cursor = 0

    @tick = 0
  end

  def set_terminal_mode : Nil
    before = Crystal::System::FileDescriptor.tcgetattr STDIN.fd
    mode = before
    mode.c_lflag &= ~LibC::ICANON
    mode.c_lflag &= ~LibC::ECHO
    mode.c_lflag &= ~LibC::ISIG

    at_exit do
      Crystal::System::FileDescriptor.tcsetattr(STDIN.fd, LibC::TCSANOW, pointerof(before))
    end

    if Crystal::System::FileDescriptor.tcsetattr(STDIN.fd, LibC::TCSANOW, pointerof(mode)) != 0
      raise IO::Error.from_errno "tcsetattr"
    end
  end

  def server_fiber : Nil
    bytes = Bytes.new(Packet::MaxSize)

    until @connection.closed?
      begin
        bytes_read, _ = @connection.receive(bytes)
        Log.trace{"packet"}
        break if bytes_read.zero? # Connection was closed
        packet = Packet.from_bytes(bytes[0...bytes_read].dup)
        spawn @packet_channel.send(packet)
      rescue ex
        Log.trace(exception: ex){""}
        break
      end
    end
  end

  def handle_packet(packet : Packet) : Nil
    Log.trace{packet}
    case
    when server_disconnect_packet = packet.server_disconnect_packet
      Log.info &.emit "Disconnected from server", cause: server_disconnect_packet.cause
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

  def handle_keyboard_action(keyboard_action : KeyboardAction | Chars) : String?
    case keyboard_action
    when KeyboardAction::Stop
      self.stop
    when KeyboardAction::Enter
      command = @console_input.join
      @console_input.clear
      @console_cursor = 0
      return command
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
      Log.info { "Available commands: help, hello, stop, join" }
    when "hello"
      Log.info { "world!" }
    when "stop"
      self.stop
    when "join"
      if (arg = command[1]?)
        self.join_server(arg)
      else
        Log.error { "Invalid IP address!" }
      end
    else
      Log.error { "Unknown command `#{command.join(' ')}` !" }
    end
  end

  def join_server(address : String) : Nil
    uri = URI.parse("tcp://#{address}")

    unless host = uri.host
      Log.error &.emit "Invalid IP address!", address: address
      return
    end

    begin
      @connection = TCPSocket.new(host, uri.port)
      @connection.send(ClientHandshakePacket.new(@username))
      spawn self.server_fiber
      Log.info &.emit "Connected to server", address: @connection.local_address.address
    rescue
      Log.error &.emit "Could not connect to IP address!", address: address
    end
  end

  def start : Nil
    self.set_terminal_mode
    Log.info { "Client started!" }

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
        command = self.handle_keyboard_action(keyboard_action)
        self.handle_command(command.split(' ')) if command && !command.blank? && !command.empty?
      end
    else
    end

    @tick += 1
  end

  def stop #: NoReturn
    Log.info { "Client stopped!" }

    @connection.send(ClientDisconnectPacket.new)

    exit
  end
end

begin
  client = Woozy::Client.new
  client.start
rescue ex
  Log.fatal(exception: ex) { "" }
  if client
    client.stop
  end
end
