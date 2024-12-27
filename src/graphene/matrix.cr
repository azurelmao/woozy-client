lib LibGraphene
  fun matrix_alloc = graphene_matrix_alloc : Matrix*
  fun matrix_free = matrix_free(matrix : Matrix*)
  fun matrix_init_identity = graphene_matrix_init_identity(matrix : Matrix*) : Matrix*
  fun matrix_init_from_float = graphene_matrix_init_from_float(matrix : Matrix*, values : Float*) : Matrix*
  fun matrix_init_from_vec4 = graphene_matrix_init_from_vec4(matrix : Matrix*, v1 : Vec4*, v2 : Vec4*, v3 : Vec4*, v4 : Vec4*) : Matrix*
  fun matrix_init_from_matrix = graphene_matrix_init_from_matrix(matrix : Matrix*, other : Matrix*) : Matrix*
  fun matrix_init_from_2d = graphene_matrix_init_from_2d(matrix : Matrix*, xx : Double, yx : Double, xy : Double, yy : Double, x_0 : Double, y_0 : Double) : Matrix*
  fun matrix_init_perspective = graphene_matrix_init_perspective(matrix : Matrix*, fov_y : Float, aspect : Float, z_near : Float, z_far : Float) : Matrix*
  fun matrix_init_ortho = graphene_matrix_init_ortho(matrix : Matrix*, left : Float, right : Float, top : Float, bottom : Float, z_near : Float, z_far : Float) : Matrix*
  fun matrix_init_look_at = graphene_matrix_init_look_at(matrix : Matrix*, eye : Vec3*, target : Vec3*, up : Vec3*) : Matrix*
  fun matrix_init_frustum = graphene_matrix_init_frustum(matrix : Matrix*, left : Float, right : Float, bottom : Float, top : Float, z_near : Float, z_far : Float) : Matrix*
  fun matrix_init_scale = graphene_matrix_init_scale(matrix : Matrix*, x : Float, y : Float, z : Float) : Matrix*
  fun matrix_init_translate = graphene_matrix_init_translate(matrix : Matrix*, point : Point3D*) : Matrix*
  fun matrix_init_rotate = graphene_matrix_init_rotate(matrix : Matrix*, angle : Float, axis : Vec3*) : Matrix*
  fun matrix_init_skew = graphene_matrix_init_skew(matrix : Matrix*, x_skew : Float, y_skew : Float) : Matrix*
  fun matrix_is_identity = graphene_matrix_is_identity(matrix : Matrix*) : Bool
  fun matrix_is_2d = graphene_matrix_is_2d(matrix : Matrix*) : Bool
  fun matrix_is_backface_visible = graphene_matrix_is_backface_visible(matrix : Matrix*) : Bool
  fun matrix_is_singular = graphene_matrix_is_singular(matrix : Matrix*) : Bool
  fun matrix_to_float = graphene_matrix_to_float(matrix : Matrix*, values : Float*)
  fun matrix_to_2d = graphene_matrix_to_2d(matrix : Matrix*, xx : Double*, yx : Double*, xy : Double*, yy : Double*, x_0 : Double*, y_0 : Double*) : Bool
  fun matrix_get_row = graphene_matrix_get_row(matrix : Matrix*, index : UInt, result : Vec4*)
  fun matrix_get_value = graphene_matrix_get_value(matrix : Matrix*, row : UInt, column : UInt) : Float
  fun matrix_multiply = graphene_matrix_multiply(matrix : Matrix*, other : Matrix*, res : Matrix*)
  fun matrix_determinant = graphene_matrix_determinant(matrix : Matrix*) : Float
  fun matrix_transform_vec4 = graphene_matrix_transform_vec4(matrix : Matrix*, vec : Vec4*, result : Vec4*)
  fun matrix_transform_vec3 = graphene_matrix_transform_vec3(matrix : Matrix*, vec : Vec3*, result : Vec3*)
  fun matrix_transform_point = graphene_matrix_transform_point(matrix : Matrix*, point : Point*, result : Point*)
  fun matrix_transform_point3d = graphene_matrix_transform_point3d(matrix : Matrix*, point : Point3D*, result : Point3D*)
  fun matrix_transform_rect = graphene_matrix_transform_rect(matrix : Matrix*, rect : Rect*, result : Quad*)
  fun matrix_transform_bounds = graphene_matrix_transform_bounds(matrix : Matrix*, rect : Rect*, result : Rect*)
  fun matrix_transform_box = graphene_matrix_transform_box(matrix : Matrix*, box : Box*, result : Box*)
  fun matrix_transform_sphere = graphene_matrix_transform_sphere(matrix : Matrix*, sphere : Sphere*, result : Sphere*)
  fun matrix_transform_ray = graphene_matrix_transform_ray(matrix : Matrix*, ray : Ray*, result : Ray*)
  fun matrix_project_point = graphene_matrix_project_point(matrix : Matrix*, point : Point*, result : Point*)
  fun matrix_project_rect_bounds = graphene_matrix_project_rect_bounds(matrix : Matrix*, rect : Rect*, result : Rect*)
  fun matrix_project_rect = graphene_matrix_project_rect(matrix : Matrix*, rect : Rect*, result : Rect*)
  fun matrix_untransform_point = graphene_matrix_untransform_point(matrix : Matrix*, point : Point*, bounds : Rect*, result : Point*) : Bool
  fun matrix_untransform_bounds = graphene_matrix_untransform_bounds(matrix : Matrix*, rect : Rect*, bounds : Rect*, result : Rect*)
  fun matrix_unproject_point3d = graphene_matrix_unproject_point3d(projection : Matrix*, model_view : Matrix*, point : Point3D*, result : Point3D*)
  fun matrix_translate = graphene_matrix_translate(matrix : Matrix*, position : Point3D*)
  fun matrix_rotate = graphene_matrix_rotate(matrix : Matrix*, angle : Float, axis : Vec4*)
  fun matrix_rotate_x = graphene_matrix_rotate_x(matrix : Matrix*, angle : Float)
  fun matrix_rotate_y = graphene_matrix_rotate_y(matrix : Matrix*, angle : Float)
  fun matrix_rotate_z = graphene_matrix_rotate_z(matrix : Matrix*, angle : Float)
  fun matrix_rotate_quaternion = graphene_matrix_rotate_quaternion(matrix : Matrix*, quaternion : Quaternion*)
  fun matrix_rotate_euler = graphene_matrix_rotate_euler(matrix : Matrix*, euler : Euler*)
  fun matrix_scale = graphene_matrix_scale(matrix : Matrix*, factor_x : Float, factor_y : Float, factor_z : Float)
  fun matrix_skew_xy = graphene_matrix_skew_xy(matrix : Matrix*, factor : Float)
  fun matrix_skew_xz = graphene_matrix_skew_xz(matrix : Matrix*, factor : Float)
  fun matrix_skew_yz = graphene_matrix_skew_yz(matrix : Matrix*, factor : Float)
  fun matrix_transpose = graphene_matrix_transpose(matrix : Matrix*, result : Matrix*)
  fun matrix_inverse = graphene_matrix_inverse(matrix : Matrix*, result : Matrix*) : Bool
  fun matrix_perspective = graphene_matrix_perspective(matrix : Matrix*, depth : Float, result : Matrix*)
  fun matrix_normalize = graphene_matrix_normalize(matrix : Matrix*, result : Matrix*)
  fun matrix_get_x_translation = graphene_matrix_get_x_translation(matrix : Matrix*) : Float
  fun matrix_get_y_translation = graphene_matrix_get_y_translation(matrix : Matrix*) : Float
  fun matrix_get_z_translation = graphene_matrix_get_z_translation(matrix : Matrix*) : Float
  fun matrix_get_x_scale = graphene_matrix_get_x_scale(matrix : Matrix*) : Float
  fun matrix_get_y_scale = graphene_matrix_get_y_scale(matrix : Matrix*) : Float
  fun matrix_get_z_scale = graphene_matrix_get_z_scale(matrix : Matrix*) : Float
  fun matrix_decompose = graphene_matrix_decompose(matrix : Matrix*, translate : Matrix*, scale : Matrix*, rotate : Quaternion*, shear : Vec3*, perspective : Vec4*) : Bool
  fun matrix_interpolate = graphene_matrix_interpolate(matrix : Matrix*, other : Matrix*, factor : Double, result : Matrix*)
  fun matrix_equal = graphene_matrix_equal(matrix : Matrix*, other : Matrix*) : Bool
  fun matrix_equal_fast = graphene_matrix_equal_fast(matrix : Matrix*, other : Matrix*) : Bool
  fun matrix_near = graphene_matrix_near(matrix : Matrix*, other : Matrix*, epsilon : Float) : Bool
  fun matrix_print = graphene_matrix_print(matrix : Matrix*)
end

struct Graphene::Matrix
  @value : LibGraphene::Matrix*

  def initialize
    @value = Pointer(LibGraphene::Matrix).malloc
  end

  def initialize(values : Float32*)
    @value = Pointer(LibGraphene::Matrix).malloc
    LibGraphene.matrix_init_from_float(@value, values)
  end

  def initialize(v1 : Vec4, v2 : Vec4, v3 : Vec4, v4 : Vec4)
    @value = Pointer(LibGraphene::Matrix).malloc
    LibGraphene.matrix_init_from_vec4(@value)
  end

  def initialize(other : Matrix)
    @value = Pointer(LibGraphene::Matrix).malloc
    LibGraphene.matrix_init_from_matrix(@value, other.@value)
  end

  def initialize(xx : Float64, yx : Float64, xy : Float64, yy : Float64, x_0 : Float64, y_0 : Float64)
    @value = Pointer(LibGraphene::Matrix).malloc
    LibGraphene.matrix_init_from_2d(@value, xx, yx, xy, yy, x_0, y_0)
  end

  def self.identity : self
    matrix = Matrix.new
    LibGraphene.matrix_init_identity(matrix.@value)
    matrix
  end

  def self.perspective(fov_y : Float32, aspect : Float32, z_near : Float32, z_far : Float32) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_perspective(matrix.@value, fov_y, aspect, z_near, z_far)
    matrix
  end

  def self.orthographic(left : Float32, right : Float32, top : Float32, bottom : Float32, z_near : Float32, z_far : Float32) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_ortho(matrix.@value, left, right, top, bottom, z_near, z_far)
    matrix
  end

  def self.look_at(eye : Vec3, target : Vec3, up : Vec3) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_look_at(matrix.@value, pointerof(eye.@value), pointerof(target.@value), pointerof(up.@value))
    matrix
  end

  def self.frustum(left : Float32, right : Float32, bottom : Float32, top : Float32, z_near : Float32, z_far : Float32) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_frustum(matrix.@value, left, right, bottom, top, z_near, z_far)
    matrix
  end

  def self.scale(x : Float32, y : Float32, z : Float32) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_scale(matrix.@value, x, y, z)
    matrix
  end

  def self.translate(point : Point3D) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_translate(matrix.@value, pointerof(point.@value))
    matrix
  end

  def self.rotate(angle : Float32, axis : Vec3) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_rotate(matrix.@value, angle, pointerof(axis.@value))
    matrix
  end

  def self.skew(x_skew : Float32, y_skew : Float32) : self
    matrix = Matrix.new
    LibGraphene.matrix_init_skew(matrix.@value, x_skew, y_skew)
    matrix
  end

  def identity? : Bool
    LibGraphene.matrix_is_identity(@value) == 0 ? false : true
  end

  def is_2d? : Bool
    LibGraphene.matrix_is_2d(@value) == 0 ? false : true
  end

  def backface_visible? : Bool
    LibGraphene.matrix_is_backface_visible(@value) == 0 ? false : true
  end

  def singular? : Bool
    LibGraphene.matrix_is_singular(@value) == 0 ? false : true
  end

  def to_float : Float32*
    values = Pointer(Float32).malloc(16)
    LibGraphene.matrix_to_float(@value, values)
    values
  end

  def to_2d : {xx: Float64, yx: Float64, xy: Float64, yy: Float64, x_0: Float64, y_0: Float64}
    success = LibGraphene.matrix_to_2d(@value, out xx, out yx, out xy, out yy, out x_0, out y_0)
    {xx: xx, yx: yx, xy: xy, yy: yy, x_0: x_0, y_0: y_0}
  end

  def row_at(index : UInt) : Vec4
    result = uninitialized Vec4
    LibGraphene.matrix_get_row(@value, index, pointerof(result.@value))
    result
  end

  def [](row : UInt, column : UInt) : Float32
    LibGraphene.matrix_get_value(@value, row, column)
  end

  def *(other : self) : self
    result = Matrix.new
    LibGraphene.matrix_multiply(@value, other.@value, result.@value)
    result
  end

  def determinant : Float32
    LibGraphene.matrix_determinant(@value)
  end

  def transform(vec : Vec4) : Vec4
    result = uninitialized Vec4
    LibGraphene.matrix_transform_vec4(@value, pointerof(vec.@value), pointerof(result.@value))
    result
  end

  def transform(vec : Vec3) : Vec3
    result = uninitialized Vec3
    LibGraphene.matrix_transform_vec3(@value, pointerof(vec.@value), pointerof(result.@value))
    result
  end

  def transform(point : Point) : Point
    result = uninitialized Point
    LibGraphene.matrix_transform_point(@value, pointerof(point.@value), pointerof(result.@value))
    result
  end

  def transform(point : Point3D) : Point3D
    result = uninitialized Point3D
    LibGraphene.matrix_transform_point3d(@value, pointerof(point.@value), pointerof(result.@value))
    result
  end

  def transform(rect : Rect) : Quad
    result = uninitialized Quad
    LibGraphene.matrix_transform_rect(@value, pointerof(rect.@value), pointerof(result.@value))
    result
  end

  def transform_bounds(rect : Rect) : Rect
    result = uninitialized Rect
    LibGraphene.matrix_transform_bounds(@value, pointerof(rect.@value), pointerof(result.@value))
    result
  end

  def transform(box : Box) : Box
    result = uninitialized Box
    LibGraphene.matrix_transform_box(@value, pointerof(box.@value), pointerof(result.@value))
    result
  end

  def transform(sphere : Sphere) : Sphere
    result = uninitialized Sphere
    LibGraphene.matrix_transform_sphere(@value, pointerof(sphere.@value), pointerof(result.@value))
    result
  end

  def transform(ray : Ray) : Ray
    result = uninitialized Ray
    LibGraphene.matrix_transform_ray(@value, pointerof(ray.@value), pointerof(result.@value))
    result
  end

  def project(point : Point) : Point
    result = uninitialized Point
    LibGraphene.matrix_project_point(@value, pointerof(ray.@value), pointerof(result.@value))
    result
  end

  def project_bounds(rect : Rect) : Rect
    result = uninitialized Rect
    LibGraphene.matrix_project_rect_bounds(@value, pointerof(rect.@value), pointerof(result.@value))
    result
  end

  def project(rect : Rect) : Rect
    result = uninitialized Rect
    LibGraphene.matrix_project_rect(@value, pointerof(rect.@value), pointerof(result.@value))
    result
  end

  def untransform(point : Point, bounds : Rect) : {result: Point, success: Bool}
    result = uninitialized Point
    success = LibGraphene.matrix_untransform_point(@value, pointerof(point.@value), pointerof(bounds.@value), pointerof(result.@value))
    {result: result, success: success}
  end

  def untransform_bounds(rect : Rect, bounds : Rect) : Rect
    result = uninitialized Rect
    success = LibGraphene.matrix_untransform_point(@value, pointerof(rect.@value), pointerof(bounds.@value), pointerof(result.@value))
    {result: result, success: success}
  end

  def self.unproject(projection : self, model_view : self, point : Point3D) : Point3D
    result = uninitialized Point3D
    LibGraphene.matrix_unproject_point3d(projection.@value, model_view.@value, pointerof(point.@value), pointerof(result.@value))
    result
  end

  def translate!(position : Point3D) : Nil
    LibGraphene.matrix_translate(@value, pointerof(position.@value))
  end

  def rotate!(angle : Float32, axis : Vec4) : Nil
    LibGraphene.matrix_rotate(@value, angle, pointerof(axis.@value))
  end

  def rotate_x!(angle : Float32) : Nil
    LibGraphene.matrix_rotate_x(@value, angle)
  end

  def rotate_y!(angle : Float32) : Nil
    LibGraphene.matrix_rotate_y(@value, angle)
  end

  def rotate_z!(angle : Float32) : Nil
    LibGraphene.matrix_rotate_z(@value, angle)
  end

  def rotate!(quaternion : Quaternion) : Nil
    LibGraphene.matrix_rotate_quaternion(@value, pointerof(quaternion.@value))
  end

  def rotate!(euler : Euler) : Nil
    LibGraphene.matrix_rotate_euler(@value, pointerof(euler.@value))
  end

  def scale!(factor_x : Float32, factor_y : Float32, factor_z : Float32) : Nil
    LibGraphene.matrix_scale(@value, factor_x, factor_y, factor_z)
  end

  def skew_xy!(factor : Float32) : Nil
    LibGraphene.matrix_skew_xy(@value, factor)
  end

  def skew_xz!(factor : Float32) : Nil
    LibGraphene.matrix_skew_xz(@value, factor)
  end

  def skew_yz!(factor : Float32) : Nil
    LibGraphene.matrix_skew_yz(@value, factor)
  end

  def transpose : self
    result = Matrix.new
    LibGraphene.matrix_transpose(@value, result.@value)
    result
  end

  def inverse : {result: self, success: Bool}
    result = Matrix.new
    success = LibGraphene.matrix_inverse(@value, result.@value)
    {result: result, success: success}
  end

  def perspective(depth : Float32) : self
    result = Matrix.new
    LibGraphene.matrix_perspective(@value, depth, result.@value)
    result
  end

  def normalize : self
    result = Matrix.new
    LibGraphene.matrix_normalize(@value, result.@value)
    result
  end

  def x_translation : Float32
    LibGraphene.matrix_get_x_translation(@value)
  end

  def y_translation : Float32
    LibGraphene.matrix_get_y_translation(@value)
  end

  def z_translation : Float32
    LibGraphene.matrix_get_z_translation(@value)
  end

  def x_scale : Float32
    LibGraphene.matrix_get_x_scale(@value)
  end

  def y_scale : Float32
    LibGraphene.matrix_get_y_scale(@value)
  end

  def z_scale : Float32
    LibGraphene.matrix_get_z_scale(@value)
  end

  def decompose : {translate: Vec3, scale: Vec3, rotate: Quaternion, shear: Vec3, perspective: Vec4, success: Bool}
    success = LibGraphene.matrix_decompose(@value, out translate, out scale, out rotate, out shear, out perspective)
    {translate: translate, scale: scale, rotate: rotate, shear: shear, perspective: perspective, success: success}
  end

  def interpolate(other : self, factor : Float64) : self
    result = Matrix.new
    LibGraphene.matrix_interpolate(@value, other.@value, factor, result.@value)
    result
  end

  def ==(other : self) : Bool
    if Lib.matrix_equal_fast(@value, other.@value) != 0
      return true
    elsif LibGraphene.matrix_equal(@value, other.@value) != 0
      return true
    else
      return false
    end
  end

  def near(other : self, epsilon : Float64) : Bool
    LibGraphene.matrix_near(@value, other.@value, epsilon) == 0 ? false : true
  end

  def print : Nil
    LibGraphene.matrix_print(@value)
  end
end
