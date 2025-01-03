class Woozy::IncomingPacketActor
  def initialize(@socket : TCPSocket, @incoming_packet_channel : Channel(Packet))
  end

  def start
    bytes = Bytes.new(Packet::DefaultSize)

    until @socket.closed?
      begin
        header = uninitialized StaticArray(UInt8, Packet::HeaderSize)
        break unless @socket.read_fully?(header.to_slice)

        id, size = Packet.header_from_bytes(header.to_slice)
        if bytes.size < size
          bytes = Bytes.new(GC.realloc(bytes.to_unsafe, size), size)
        end

        break unless @socket.read_fully?(bytes[0...size])
        break unless packet = Packet.from_id(id, bytes[0...size])

        spawn @incoming_packet_channel.send(packet)
      rescue ex
        Log.fatal(exception: ex) { "" }
        break
      end
    end
  end
end
