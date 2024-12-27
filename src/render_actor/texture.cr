module Woozy
  class RenderActor
    class TextureArray
      Log = ::Log.for("opengl")

      getter handle : LibGL::UInt
      getter unit : LibGL::UInt

      def initialize(@unit : LibGL::UInt, size : LibGL::SizeI, sprites : Enumerable(Sprite))
        texture_data = Array(UInt16).new
        Slice.join(sprites.map(&.load.pixels)).each do |rgba|
          texture_data << rgba.r
          texture_data << rgba.g
          texture_data << rgba.b
          texture_data << rgba.a
        end

        LibGL.create_textures(LibGL::TextureTarget::Texture2DArray, 1, out @handle)

        LibGL.texture_parameter_i(@handle, LibGL::TextureParameterName::TextureWrapS, LibGL::TextureWrapMode::ClampToEdge)
        LibGL.texture_parameter_i(@handle, LibGL::TextureParameterName::TextureWrapT, LibGL::TextureWrapMode::ClampToEdge)
        LibGL.texture_parameter_i(@handle, LibGL::TextureParameterName::TextureMinFilter, LibGL::TextureMinFilter::Nearest)
        LibGL.texture_parameter_i(@handle, LibGL::TextureParameterName::TextureMagFilter, LibGL::TextureMagFilter::Nearest)

        LibGL.texture_storage_3d(@handle, sprites.size, LibGL::SizedInternalFormat::RGBA16, size, size, sprites.size)
        LibGL.texture_sub_image_3d(@handle, 0, 0, 0, 0, size, size, sprites.size, LibGL::PixelFormat::RGBA, LibGL::PixelType::UnsignedShort, texture_data.to_unsafe)

        LibGL.bind_texture_unit(@unit, @handle)
      end
    end
  end
end
