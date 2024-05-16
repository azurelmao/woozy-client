struct Woozy::Client
  def packet_loop(packet_channel : Channel(Packet)) : Nil
    bytes = Bytes.new(Packet::MaxSize)

    until @tcp_socket.closed?
      select
      when @stop_channel.receive then break
      else
      end

      bytes_read, _ = @tcp_socket.receive(bytes)
      break if bytes_read.zero? # Socket was closed
      packet = Packet.from_bytes(bytes[0...bytes_read].dup)

      packet_channel.send packet
    end
  end

  def handle_packet(packet : Packet) : Nil
    case
    when server_handshake_packet = packet.server_handshake_packet
      Log.info &.emit "Handshake succeeded"
    when server_disconnect_packet = packet.server_disconnect_packet
      Log.info &.emit "Disconnected", cause: server_disconnect_packet.cause
      stop
    end
  end
end
