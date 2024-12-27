require "woozy/chunk"

module Woozy
  class RenderActor
    struct Vertex
      @pos : {Float32, Float32, Float32}
      @uv : {Float32, Float32}
      @tex : UInt32
      @nrm : UInt32

      def initialize(@pos, @uv, @tex, nrm : Side)
        @nrm = nrm.value
      end
    end

    class ChunkMesh
      getter position : Vec3
      @vertices : Array(Vertex)
      @vbo : VertexBuffer(Vertex)
      getter vao : VertexArray

      def initialize(blocks : Blocks, chunk : Chunk)
        x, y, z = chunk.position.to_global_pos.splat_f32
        @position = Vec3.new(x, y, z)
        @vertices = ChunkMesh.build(blocks, chunk)

        @vbo = VertexBuffer(Vertex).new(@vertices, LibGL::BufferStorageMask::DynamicStorage)
        @vao = VertexArray.new
        vbo_binding = @vao.add_vertex_buffer(@vbo, 0)

        @vao.enable_attr(on: 0) do |attr|
          attr.format(3, LibGL::VertexAttribType::Float, offsetof(Vertex, @pos)).bind(on: vbo_binding)
        end

        @vao.enable_attr(on: 1) do |attr|
          attr.format(2, LibGL::VertexAttribType::Float, offsetof(Vertex, @uv)).bind(on: vbo_binding)
        end

        @vao.enable_attr(on: 2) do |attr|
          attr.format(1, LibGL::VertexAttribIType::UnsignedInt, offsetof(Vertex, @tex)).bind(on: vbo_binding)
        end

        @vao.enable_attr(on: 3) do |attr|
          attr.format(1, LibGL::VertexAttribIType::UnsignedInt, offsetof(Vertex, @nrm)).bind(on: vbo_binding)
        end
      end

      def vertices_size : Int32
        @vertices.size
      end

      def self.build(blocks : Blocks, chunk : Chunk) : Array(Vertex)
        vertices = Array(Vertex).new

        LocalPos.new(0, 0, 0).to LocalPos.new(Chunk::BitMask, Chunk::BitMask, Chunk::BitMask) do |local_pos|
          if (impl = blocks.impl_of(chunk.get_block(local_pos).index)).is_a? SolidBlockImpl
            min = Vec3.new(local_pos.x.to_f32, local_pos.y.to_f32, local_pos.z.to_f32)
            max = min + 1.0_f32

            if (offset_pos = local_pos + LocalPos.new(0, 0, -1)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::NegZ
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # -z
                Vertex.new({min.x, min.y, min.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({min.x, max.y, min.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, min.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, min.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, min.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, min.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
              ]
            end

            if (offset_pos = local_pos + LocalPos.new(0, 0, 1)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::PosZ
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # +z
                Vertex.new({min.x, max.y, max.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, max.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, max.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, max.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
              ]
            end

            if (offset_pos = local_pos + LocalPos.new(-1, 0, 0)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::NegX
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # -x
                Vertex.new({min.x, max.y, min.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, min.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({min.x, max.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, max.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, min.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, max.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
              ]
            end

            if (offset_pos = local_pos + LocalPos.new(1, 0, 0)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::PosX
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # +x
                Vertex.new({max.x, min.y, min.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, min.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, min.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, max.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
              ]
            end

            if (offset_pos = local_pos + LocalPos.new(0, -1, 0)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::NegY
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # -y
                Vertex.new({min.x, min.y, max.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, min.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, max.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, min.y, min.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, min.y, min.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
              ]
            end

            if (offset_pos = local_pos + LocalPos.new(0, 1, 0)).valid? &&
               blocks.impl_of(chunk.get_block(offset_pos).index).is_a? NonSolidBlockImpl
              side = Side::PosY
              tex_idx = impl.get_texture(side)
              vertices.concat [
                # +y
                Vertex.new({min.x, max.y, min.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({min.x, max.y, max.z}, {0.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({min.x, max.y, min.z}, {0.0_f32, 0.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, max.z}, {1.0_f32, 1.0_f32}, tex_idx, side),
                Vertex.new({max.x, max.y, min.z}, {1.0_f32, 0.0_f32}, tex_idx, side),
              ]
            end
          end
        end

        vertices
      end
    end
  end
end
