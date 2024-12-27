require "opengl"
require "crystglfw"
require "./graphene/**"
require "./render_actor/**"

class Woozy::RenderActor
  include Graphene
  include CrystGLFW

  @stop_channel : Channel(Nil)
  @chunk_channel : Channel(Chunk)
  @content : Content
  @key_channel : Channel({Key, Action})

  def initialize(@stop_channel, @chunk_channel, @key_channel, @content)
    @self_stop_channel = Channel(Nil).new
    @chunk_meshes = Array(ChunkMesh).new
  end

  def self.opengl_debug_callback(
    _source : LibGL::Enum, _type : LibGL::Enum, id : LibGL::UInt,
    severity : LibGL::Enum, length : LibGL::SizeI,
    _message : Pointer(LibGL::Char), user_param : Pointer(Void)
  ) : Void
    message = String.new(_message)

    source = case _source
             when LibGL::DebugSource::DebugSourceAPI            then "api"
             when LibGL::DebugSource::DebugSourceWindowSystem   then "window system"
             when LibGL::DebugSource::DebugSourceShaderCompiler then "shader compiler"
             when LibGL::DebugSource::DebugSourceThirdParty     then "third party"
             when LibGL::DebugSource::DebugSourceApplication    then "application"
             else                                                    "other"
             end

    type = case _type
           when LibGL::DebugType::DebugTypeError              then "error"
           when LibGL::DebugType::DebugTypeDeprecatedBehavior then "deprecated behavior"
           when LibGL::DebugType::DebugTypeUndefinedBehavior  then "undefined behavior"
           when LibGL::DebugType::DebugTypePortability        then "portability"
           when LibGL::DebugType::DebugTypePerformance        then "performance"
           when LibGL::DebugType::DebugTypeMarker             then "marker"
           when LibGL::DebugType::DebugTypePushGroup          then "push group"
           when LibGL::DebugType::DebugTypePopGroup           then "pop group"
           else                                                    "other"
           end

    log = Log.for("opengl")

    case severity
    when LibGL::DebugSeverity::DebugSeverityHigh
      log.error &.emit message, type: type, source: source
    when LibGL::DebugSeverity::DebugSeverityMedium
      log.warn &.emit message, type: type, source: source
    when LibGL::DebugSeverity::DebugSeverityLow, LibGL::DebugSeverity::DebugSeverityNotification
      log.notice &.emit message, type: type, source: source
    end
  end

  def start
    hints = {
      Window::HintLabel::ContextVersionMajor => 4,
      Window::HintLabel::ContextVersionMinor => 6,
      Window::HintLabel::ClientAPI           => ClientAPI::OpenGL,
      Window::HintLabel::OpenGLProfile       => OpenGLProfile::Core,
      Window::HintLabel::OpenGLDebugContext  => true,
      Window::HintLabel::OpenGLForwardCompat => true,
    }

    window = Window.new(width: 640, height: 480, title: "woozy-client", hints: hints)
    window.make_context_current
    window.cursor.disable

    LibGL.enable(LibGL::EnableCap::DebugOutput)
    LibGL.enable(LibGL::EnableCap::DebugOutputSynchronous)
    LibGL.debug_message_callback(->RenderActor.opengl_debug_callback, Pointer(Void).null)
    LibGL.enable(LibGL::EnableCap::CullFace)
    LibGL.enable(LibGL::EnableCap::DepthTest)
    LibGL.clip_control(LibGL::ClipControlOrigin::LowerLeft, LibGL::ClipControlDepth::ZeroToOne)
    LibGL.blend_func(LibGL::BlendingFactor::SrcAlpha, LibGL::BlendingFactor::OneMinusSrcAlpha)

    shader_program = ShaderProgram.new("main.vsh", "main.fsh")

    eye = Vec3.new(0.0_f32, 0.0_f32, 1.0_f32)
    yaw = -180.0_f32
    pitch = 0.0_f32
    y_fov = 60.0_f32
    aspect = 640.0_f32 / 480.0_f32
    prev_cursor_x = 640.0_f32 / 2.0_f32
    prev_cursor_y = 480.0_f32 / 2.0_f32
    camera = Camera.new(eye, yaw, pitch, y_fov, aspect, prev_cursor_x, prev_cursor_y)

    LibGL.viewport(0, 0, 640, 480)
    window.on_resize do |event|
      camera.aspect = event.size[:width].to_f32 / event.size[:height].to_f32

      shader_program.bind do
        shader_program.set_uniform("uProjection", camera.projection)
      end

      LibGL.viewport(0, 0, event.size[:width], event.size[:height])
    end

    window.on_cursor_move do |event|
      cursor_x, cursor_y = event.position[:x].to_f32, event.position[:y].to_f32

      x_offset = (cursor_x - camera.prev_cursor_x) * 0.03_f32
      y_offset = (cursor_y - camera.prev_cursor_y) * 0.03_f32

      camera.yaw += x_offset
      camera.pitch += y_offset
      camera.pitch = camera.pitch.clamp(-89.0_f32, 89.0_f32)

      shader_program.bind do
        shader_program.set_uniform("uView", camera.view)
      end

      camera.prev_cursor_x = cursor_x
      camera.prev_cursor_y = cursor_y
    end

    window.on_key do |event|
      spawn @key_channel.send({event.key, event.action})
    end

    model = Matrix.identity
    textures = TextureArray.new(0, 16, @content.sprites.to_a)

    shader_program.bind do
      shader_program.set_uniform("uProjection", camera.projection)
      shader_program.set_uniform("uView", camera.view)
      shader_program.set_uniform("uModel", model)
      shader_program.set_uniform("uTextureArray", textures.unit)
    end

    delta_time = 0.01666667_f32 * 3.0_f32

    loop do
      select
      when @self_stop_channel.receive
        break
      when timeout(16.66667.milliseconds)
        if window.should_close?
          break
        end

        loop do
          select
          when chunk = @chunk_channel.receive
            @chunk_meshes << ChunkMesh.new(@content.blocks, chunk)
          else
            break
          end
        end

        shader_program.bind do
          if window.key_pressed?(Key::W)
            camera.eye += camera.direction * delta_time
            shader_program.set_uniform("uView", camera.view)
          end

          if window.key_pressed?(Key::S)
            camera.eye -= camera.direction * delta_time
            shader_program.set_uniform("uView", camera.view)
          end

          if window.key_pressed?(Key::A)
            camera.eye += camera.right * delta_time
            shader_program.set_uniform("uView", camera.view)
          end

          if window.key_pressed?(Key::D)
            camera.eye -= camera.right * delta_time
            shader_program.set_uniform("uView", camera.view)
          end

          if window.key_pressed?(Key::Space)
            camera.eye -= camera.up * delta_time
            shader_program.set_uniform("uView", camera.view)
          end

          if window.key_pressed?(Key::LeftShift)
            camera.eye += camera.up * delta_time
            shader_program.set_uniform("uView", camera.view)
          end
        end

        LibGL.clear_color(0.0, 0.0, 0.0, 1.0)
        LibGL.clear(LibGL::ClearBufferMask::ColorBuffer | LibGL::ClearBufferMask::DepthBuffer)

        shader_program.bind do
          @chunk_meshes.each do |chunk_mesh|
            pos = chunk_mesh.position
            shader_program.set_uniform("uChunkPosition", pos.x, pos.y, pos.z)
            chunk_mesh.vao.bind do
              LibGL.draw_arrays(LibGL::PrimitiveType::Triangles, 0, chunk_mesh.vertices_size)
            end
          end
        end

        CrystGLFW.poll_events
        window.swap_buffers
      end
    end
  end

  def stop : Nil
    @self_stop_channel.send(nil)
  end
end
