module Woozy
  class RenderActor
    class ShaderProgram
      Log = ::Log.for("opengl")

      getter handle : LibGL::UInt

      def initialize(vertex_shader_path : String, fragment_shader_path : String)
        @handle = LibGL.create_program
        @uniforms = Hash(String, LibGL::Int).new

        if vertex_shader = self.read_and_compile_shader(vertex_shader_path, LibGL::ShaderType::VertexShader)
          LibGL.attach_shader(@handle, vertex_shader)
        end

        if fragment_shader = self.read_and_compile_shader(fragment_shader_path, LibGL::ShaderType::FragmentShader)
          LibGL.attach_shader(@handle, fragment_shader)
        end

        LibGL.link_program(@handle)

        # Check for compile errors
        LibGL.get_program_iv(@handle, LibGL::ProgramPropertyARB::LinkStatus, out compiled)
        if compiled == 0
          LibGL.get_program_iv(@handle, LibGL::ProgramPropertyARB::InfoLogLength, out log_length)
          log = Pointer(UInt8).malloc(log_length)
          LibGL.get_program_info_log(@handle, log_length, nil, log)
          Log.error &.emit "Shader program linking failed!", error_message: String.new(log)
        else
          Log.debug { "Shader program linking succeeded!" }
        end

        LibGL.get_program_iv(@handle, LibGL::ProgramPropertyARB::ActiveUniforms, out nr_uniforms)
        LibGL.get_program_iv(@handle, LibGL::ProgramPropertyARB::ActiveUniformMaxLength, out uniform_max_length)

        uniform_name = Pointer(LibGL::Char).malloc(uniform_max_length)
        nr_uniforms.times do |i|
          LibGL.get_active_uniform(@handle, i, uniform_max_length, out length, out size, out type, uniform_name)
          @uniforms[String.new(uniform_name)] = LibGL.get_uniform_location(@handle, uniform_name)
          uniform_name.clear(uniform_max_length)
        end
      end

      def read_and_compile_shader(path : String, type : LibGL::ShaderType) : UInt32?
        unless File.exists?(path)
          return
        end

        source = File.read(path)
        source_unsafe = source.to_unsafe

        handle = LibGL.create_shader(type)
        LibGL.shader_source(handle, 1, pointerof(source_unsafe), nil)
        LibGL.compile_shader(handle)

        # Checks for compile errors
        LibGL.get_shader_iv(handle, LibGL::ShaderParameterName::CompileStatus, out compiled)

        if compiled == 0
          LibGL.get_shader_iv(handle, LibGL::ShaderParameterName::InfoLogLength, out log_length)
          log = Pointer(UInt8).malloc(log_length)
          LibGL.get_shader_info_log(handle, log_length, nil, log)
          Log.error &.emit "Shader compilation failed!", path: path, error_message: String.new(log)
          return
        end

        Log.debug &.emit "Shader compilation succeeded!", path: path
        handle
      end

      def bind(&) : Nil
        LibGL.use_program(@handle)
        yield
      ensure
        LibGL.use_program(0)
      end

      def set_uniform(location : String, v0 : LibGL::Int)
        LibGL.uniform_1i(@uniforms[location], v0)
      end

      def set_uniform(location : String, v0 : LibGL::Int, v1 : LibGL::Int)
        LibGL.uniform_2i(@uniforms[location], v0, v1)
      end

      def set_uniform(location : String, v0 : LibGL::Int, v1 : LibGL::Int, v2 : LibGL::Int)
        LibGL.uniform_3i(@uniforms[location], v0, v1, v2)
      end

      def set_uniform(location : String, v0 : LibGL::Int, v1 : LibGL::Int, v2 : LibGL::Int, v3 : LibGL::Int)
        LibGL.uniform_4i(@uniforms[location], v0, v1, v2, v3)
      end

      def set_uniform(location : String, v0 : LibGL::UInt)
        LibGL.uniform_1ui(@uniforms[location], v0)
      end

      def set_uniform(location : String, v0 : LibGL::UInt, v1 : LibGL::UInt)
        LibGL.uniform_2ui(@uniforms[location], v0, v1)
      end

      def set_uniform(location : String, v0 : LibGL::UInt, v1 : LibGL::UInt, v2 : LibGL::UInt)
        LibGL.uniform_3ui(@uniforms[location], v0, v1, v2)
      end

      def set_uniform(location : String, v0 : LibGL::UInt, v1 : LibGL::UInt, v2 : LibGL::UInt, v3 : LibGL::UInt)
        LibGL.uniform_4ui(@uniforms[location], v0, v1, v2, v3)
      end

      def set_uniform(location : String, v0 : LibGL::Float)
        LibGL.uniform_1f(@uniforms[location], v0)
      end

      def set_uniform(location : String, v0 : LibGL::Float, v1 : LibGL::Float)
        LibGL.uniform_2f(@uniforms[location], v0, v1)
      end

      def set_uniform(location : String, v0 : LibGL::Float, v1 : LibGL::Float, v2 : LibGL::Float)
        LibGL.uniform_3f(@uniforms[location], v0, v1, v2)
      end

      def set_uniform(location : String, v0 : LibGL::Float, v1 : LibGL::Float, v2 : LibGL::Float, v3 : LibGL::Float)
        LibGL.uniform_4f(@uniforms[location], v0, v1, v2, v3)
      end

      def set_uniform(location : String, matrix : Graphene::Matrix)
        LibGL.uniform_matrix4_fv(@uniforms[location], 1, LibGL::Boolean::False, matrix.to_float)
      end
    end
  end
end
