module Woozy
  class RenderActor
    class VertexBuffer(T)
      getter handle : LibGL::UInt

      def initialize(vertices : Enumerable(T), flags : LibGL::BufferStorageMask)
        LibGL.create_buffers(1, out @handle)
        LibGL.named_buffer_storage(@handle, sizeof(T) * vertices.size, vertices.to_unsafe, flags)
      end
    end
  end
end
