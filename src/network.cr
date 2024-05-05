struct Woozy::Client
  def packet_loop(channel : Channel(Packet))
    loop do
      if packet = Packet.from_socket(@tcp_socket)
        channel.send packet
      else
        channel.close
        break
      end
    end
  end

  def handle_packet(packet : Packet)
    case
    when server_handshake_packet = packet.server_handshake_packet
      Log.info &.emit "Handshake succeeded"
    when server_disconnect_packet = packet.server_disconnect_packet
      Log.info &.emit "Disconnected", cause: server_disconnect_packet.cause
      stop
    end
  end
end
