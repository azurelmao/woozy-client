lib LibGraphene
  fun vec4_alloc = graphene_vec4_alloc : Vec4*
  fun vec4_free = graphene_vec4_free(vec : Vec4*)
  fun vec4_init = graphene_vec4_init(vec : Vec4*, x : Float, y : Float, z : Float, w : Float) : Vec4*
  fun vec4_init_from_vec4 = graphene_vec4_init_from_vec4(vec : Vec4*, src : Vec4*) : Vec4*
  fun vec4_init_from_vec3 = graphene_vec4_init_from_vec3(vec : Vec4*, src : Vec3*, w : Float) : Vec4*
  fun vec4_init_from_vec2 = graphene_vec4_init_from_vec2(vec : Vec4*, src : Vec2*, z : Float, w : Float) : Vec4*
  fun vec4_init_from_float = graphene_vec4_init_from_float(vec : Vec4*, src : Float*) : Vec4*
  fun vec4_to_float = graphene_vec4_to_float(vec : Vec4*, dest : Float*)
  fun vec4_add = graphene_vec4_add(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_subtract = graphene_vec4_subtract(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_multiply = graphene_vec4_multiply(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_divide = graphene_vec4_divide(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_dot = graphene_vec4_dot(vec : Vec4*, other : Vec4*) : Float
  fun vec4_scale = graphene_vec4_scale(vec : Vec4*, factor : Float, result : Vec4*)
  fun vec4_length = graphene_vec4_length(vec : Vec4*) : Float
  fun vec4_normalize = graphene_vec4_normalize(vec : Vec4*, result : Vec4*)
  fun vec4_negate = graphene_vec4_negate(vec : Vec4*, result : Vec4*)
  fun vec4_equal = graphene_vec4_equal(vec : Vec4*, other : Vec4*) : Bool
  fun vec4_near = graphene_vec4_near(vec : Vec4*, other : Vec4*, epsilon : Float) : Bool
  fun vec4_min = graphene_vec4_min(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_max = graphene_vec4_max(vec : Vec4*, other : Vec4*, result : Vec4*)
  fun vec4_interpolate = graphene_vec4_interpolate(vec : Vec4*, other : Vec4*, factor : Float, result : Vec4*)
  fun vec4_get_x = graphene_vec4_get_x(vec : Vec4*) : Float
  fun vec4_get_y = graphene_vec4_get_y(vec : Vec4*) : Float
  fun vec4_get_z = graphene_vec4_get_z(vec : Vec4*) : Float
  fun vec4_get_w = graphene_vec4_get_w(vec : Vec4*) : Float
  fun vec4_get_xy = graphene_vec4_get_xy(vec : Vec4*, result : Vec2*)
  fun vec4_get_xyz = graphene_vec4_get_xyz(vec : Vec4*, result : Vec3*)
  fun vec4_zero = graphene_vec4_zero : Vec4*
  fun vec4_one = graphene_vec4_one : Vec4*
  fun vec4_x_axis = graphene_vec4_x_axis : Vec4*
  fun vec4_y_axis = graphene_vec4_y_axis : Vec4*
  fun vec4_z_axis = graphene_vec4_z_axis : Vec4*
  fun vec4_w_axis = graphene_vec4_w_axis : Vec4*
end

struct Graphene::Vec4
  Zero  = Vec4.new(LibGraphene.vec4_zero.value)
  One   = Vec4.new(LibGraphene.vec4_one.value)
  XAxis = Vec4.new(LibGraphene.vec4_x_axis.value)
  YAxis = Vec4.new(LibGraphene.vec4_y_axis.value)
  ZAxis = Vec4.new(LibGraphene.vec4_z_axis.value)
  WAxis = Vec4.new(LibGraphene.vec4_w_axis.value)

  @value : LibGraphene::Vec4

  def initialize(@value)
  end

  def initialize(x : Float32, y : Float32, z : Float32)
    LibGraphene.vec4_init(out @value, x, y, z)
  end

  def initialize(src : self)
    LibGraphene.vec4_init_from_vec4(out @value, pointerof(src.@value))
  end

  def initialize(src : Vec3, w : Float32)
    LibGraphene.vec4_init_from_vec3(out @value, pointerof(src.@value), w)
  end

  def initialize(src : Vec2, z : Float32, w : Float32)
    LibGraphene.vec4_init_from_vec2(out @value, pointerof(src.@value), z, w)
  end

  def initialize(src : Float32[4])
    LibGraphene.vec4_init_from_float(out @value, pointerof(src))
  end

  def to_float : Float32[4]
    dest = uninitialized Float32[4]
    LibGraphene.vec4_to_float(pointerof(@value), pointerof(dest))
    dest
  end

  def +(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_add(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def -(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_subtract(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def *(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_multiply(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def /(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_divide(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def dot(other : self) : Float32
    LibGraphene.vec4_dot(pointerof(@value), pointerof(other.@value))
  end

  def scale(factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec4_scale(pointerof(@value), factor, pointerof(result.@value))
    result
  end

  def size : Float32
    LibGraphene.vec4_length(pointerof(@value))
  end

  def normalize : self
    result = uninitialized self
    LibGraphene.vec4_normalize(pointerof(@value), pointerof(result.@value))
    result
  end

  def - : self
    result = uninitialized self
    LibGraphene.vec4_negate(pointerof(@value), pointerof(result.@value))
    result
  end

  def ==(other : self) : Bool
    LibGraphene.vec4_equal(pointerof(@value), pointerof(other.@value)) == 0 ? false : true
  end

  def near(other : self, epsilon : Float32) : Bool
    LibGraphene.vec4_near(pointerof(@value), pointerof(other.@value), epsilon)
  end

  def min(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_min(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def max(other : self) : self
    result = uninitialized self
    LibGraphene.vec4_max(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def interpolate(other : self, factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec4_interpolate(pointerof(@value), pointerof(other.@value), factor, pointerof(result.@value))
    result
  end

  def x : Float32
    LibGraphene.vec4_get_x(pointerof(@value))
  end

  def y : Float32
    LibGraphene.vec4_get_y(pointerof(@value))
  end

  def z : Float32
    LibGraphene.vec4_get_z(pointerof(@value))
  end

  def w : Float32
    LibGraphene.vec4_get_w(pointerof(@value))
  end

  def xy : Vec2
    result = uninitialized Vec2
    LibGraphene.vec4_get_xy(pointerof(@value), pointerof(result.@value))
    result
  end

  def xyz : Vec3
    result = uninitialized Vec3
    LibGraphene.vec4_get_xyz(pointerof(@value), pointerof(result.@value))
    result
  end
end
