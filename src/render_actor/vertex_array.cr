module Woozy
  class RenderActor
    class VertexArray
      getter handle : LibGL::UInt

      def initialize
        LibGL.create_vertex_arrays(1, out @handle)
      end

      def add_vertex_buffer(vbo : VertexBuffer(T), binding : Int32) : LibGL::UInt forall T
        LibGL.vertex_array_vertex_buffer(@handle, LibGL::UInt.new(binding), vbo.handle, 0, sizeof(T))
        LibGL::UInt.new(binding)
      end

      record Attribute, index : LibGL::UInt do
        def format(size : Int32, type : LibGL::VertexAttribIType, offset : Int32)
          FormattedAttribute.new(@index, IntegerFormat.new(LibGL::Int.new(size), type, LibGL::UInt.new(offset)))
        end

        def format(size : Int32, type : LibGL::VertexAttribType, offset : Int32, normalized = false)
          FormattedAttribute.new(@index, FloatFormat.new(LibGL::Int.new(size), type, LibGL::UInt.new(offset), normalized ? LibGL::Boolean::True : LibGL::Boolean::False))
        end
      end

      record IntegerFormat, size : LibGL::Int, type : LibGL::VertexAttribIType, offset : LibGL::UInt
      record FloatFormat, size : LibGL::Int, type : LibGL::VertexAttribType, offset : LibGL::UInt, normalized : LibGL::Boolean

      record FormattedAttribute, index : LibGL::UInt, format : IntegerFormat | FloatFormat do
        def bind(*, on binding)
          BoundAttribute.new(@index, @format, binding)
        end
      end

      record BoundAttribute, index : LibGL::UInt, format : IntegerFormat | FloatFormat, binding : LibGL::UInt

      def enable_attr(*, on index : Int32, & : Attribute -> BoundAttribute) : Nil
        bound_attr = yield Attribute.new(LibGL::UInt.new(index))
        self.enable_attr(bound_attr.index)

        case format = bound_attr.format
        when IntegerFormat
          self.attr_format(bound_attr.index, format.size, format.type, format.offset)
        when FloatFormat
          self.attr_format(bound_attr.index, format.size, format.type, format.offset, format.normalized)
        end

        self.attr_binding(bound_attr.index, bound_attr.binding)
      end

      private def enable_attr(index : LibGL::UInt) : Nil
        LibGL.enable_vertex_array_attrib(@handle, index)
      end

      private def attr_format(index : LibGL::UInt, size : LibGL::Int, type : LibGL::VertexAttribIType, offset : LibGL::UInt) : Nil
        LibGL.vertex_array_attrib_i_format(@handle, index, size, type, offset)
      end

      private def attr_format(index : LibGL::UInt, size : LibGL::Int, type : LibGL::VertexAttribType, offset : LibGL::UInt, normalized : LibGL::Boolean) : Nil
        LibGL.vertex_array_attrib_format(@handle, index, size, type, normalized, offset)
      end

      private def attr_binding(index : LibGL::UInt, binding : LibGL::UInt) : Nil
        LibGL.vertex_array_attrib_binding(@handle, index, binding)
      end

      def bind(&) : Nil
        LibGL.bind_vertex_array(@handle)
        yield
      end
    end
  end
end
