module Woozy
  class RenderActor
    class Camera
      getter eye : Vec3
      getter yaw : Float32
      getter pitch : Float32
      property prev_cursor_x : Float32
      property prev_cursor_y : Float32
      getter up : Vec3
      getter right : Vec3
      getter direction : Vec3
      getter y_fov : Float32
      getter aspect : Float32
      getter z_near : Float32
      getter z_far : Float32
      getter projection : Matrix
      getter view : Matrix

      def initialize(@eye, @yaw, @pitch, @y_fov, @aspect, @prev_cursor_x, @prev_cursor_y)
        yaw_radians = @yaw * Math::PI / 180.0_f32
        pitch_radians = @pitch * Math::PI / 180.0_f32

        x = Math.cos(yaw_radians) * Math.cos(pitch_radians)
        z = Math.sin(yaw_radians) * Math.cos(pitch_radians)
        @up = Vec3::YAxis
        @right = Graphene::Vec3.new(x, 0.0_f32, z).normalize
        @direction = @right.cross(@up).normalize

        @z_near = 0.1_f32
        @z_far = 1000.0_f32

        @projection = Matrix.perspective(@y_fov, @aspect, @z_near, @z_far)
        @view = Matrix.translate(Point3D.new(@eye)) * Matrix.rotate(@pitch, @right) * Matrix.rotate(@yaw, @up)
      end

      private def cache_view : Nil
        yaw_radians = @yaw * Math::PI / 180.0_f32
        pitch_radians = @pitch * Math::PI / 180.0_f32

        x = Math.cos(yaw_radians) * Math.cos(pitch_radians)
        z = Math.sin(yaw_radians) * Math.cos(pitch_radians)
        @right = Graphene::Vec3.new(x, 0.0_f32, z).normalize
        @direction = @right.cross(@up).normalize

        @view = Matrix.translate(Point3D.new(@eye)) * Matrix.rotate(@pitch, @right) * Matrix.rotate(@yaw, @up)
      end

      private def cache_projection : Nil
        @projection = Matrix.perspective(@y_fov, @aspect, @z_near, @z_far)
      end

      def eye=(@eye)
        self.cache_view
      end

      def yaw=(@yaw)
        self.cache_view
      end

      def pitch=(@pitch)
        self.cache_view
      end

      def y_fov=(@y_fov)
        self.cache_projection
      end

      def aspect=(@aspect)
        self.cache_projection
      end

      def z_near=(@z_near)
        self.cache_projection
      end

      def z_far=(@z_far)
        self.cache_projection
      end
    end
  end
end
