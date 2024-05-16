require "woozy"
require "./command"
require "./network"

struct Woozy::Client
  def initialize(host : String, port : Int32)
    @tcp_socket = TCPSocket.new host, port
    @stop_channel = Channel(Bool).new
    @username = "jeb"

    @command_history = Chronicle.new

    @tick = 0
  end

  def start : Nil
    command_channel = Channel(Command).new
    spawn self.key_loop(command_channel)
    Fiber.yield

    packet_channel = Channel(Packet).new
    spawn self.packet_loop(packet_channel)
    Fiber.yield

    # render_channel = Channel().new
    # spawn render_loop
    # Fiber.yield

    self.clear_line
    loop do
      select
      when timeout(1.second)
        self.clear_line

        loop do
          select
          when packet = packet_channel.receive
            self.handle_packet(packet)
          else
            break
          end
        end

        loop do
          select
          when command = command_channel.receive
            self.handle_command(command)
          else
            break
          end
        end

        update

        self.print_current_line
      end
    end
  end

  def update : Nil
    case @tick
    when 0
      @tcp_socket.send ClientHandshakePacket.new @username
    when 5
      @tcp_socket.send ClientMessagePacket.new "hello"
    end

    @tick += 1
  end

  def stop : Nil
    @tcp_socket.send ClientDisconnectPacket.new

    select
    when @stop_channel.send true
    else
    end

    exit
  end
end

raise "Mismatched number of arguments!" if ARGV.size.odd?

host = "127.0.0.1"
port = 1234

index = 0
while index < ARGV.size
  case ARGV[index]
  when "-h", "--host"
    host = ARGV[index + 1]
  when "-p", "--port"
    port = ARGV[index + 1].to_i
  end
  index += 2
end

begin
  client = Woozy::Client.new host, port

  Process.on_terminate do
    client.stop
  end

  client.start
rescue ex : Socket::ConnectError
  Log.fatal { "Could not connect to '#{host}:#{port}'" }
end


