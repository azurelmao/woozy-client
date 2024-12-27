lib LibGraphene
  fun vec3_alloc = graphene_vec3_alloc : Vec3*
  fun vec3_free = graphene_vec3_free(vec : Vec3*)
  fun vec3_init = graphene_vec3_init(vec : Vec3*, x : Float, y : Float, z : Float) : Vec3*
  fun vec3_init_from_vec3 = graphene_vec3_init_from_vec3(vec : Vec3*, src : Vec3*) : Vec3*
  fun vec3_init_from_float = graphene_vec3_init_from_float(vec : Vec3*, src : Float*) : Vec3*
  fun vec3_to_float = graphene_vec3_to_float(vec : Vec3*, dest : Float*)
  fun vec3_add = graphene_vec3_add(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_subtract = graphene_vec3_subtract(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_multiply = graphene_vec3_multiply(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_divide = graphene_vec3_divide(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_cross = graphene_vec3_cross(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_dot = graphene_vec3_dot(vec : Vec3*, other : Vec3*) : Float
  fun vec3_scale = graphene_vec3_scale(vec : Vec3*, factor : Float, result : Vec3*)
  fun vec3_length = graphene_vec3_length(vec : Vec3*) : Float
  fun vec3_normalize = graphene_vec3_normalize(vec : Vec3*, result : Vec3*)
  fun vec3_negate = graphene_vec3_negate(vec : Vec3*, result : Vec3*)
  fun vec3_equal = graphene_vec3_equal(vec : Vec3*, other : Vec3*) : Bool
  fun vec3_near = graphene_vec3_near(vec : Vec3*, other : Vec3*, epsilon : Float) : Bool
  fun vec3_min = graphene_vec3_min(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_max = graphene_vec3_max(vec : Vec3*, other : Vec3*, result : Vec3*)
  fun vec3_interpolate = graphene_vec3_interpolate(vec : Vec3*, other : Vec3*, factor : Float, result : Vec3*)
  fun vec3_get_x = graphene_vec3_get_x(vec : Vec3*) : Float
  fun vec3_get_y = graphene_vec3_get_y(vec : Vec3*) : Float
  fun vec3_get_z = graphene_vec3_get_z(vec : Vec3*) : Float
  fun vec3_get_xy = graphene_vec3_get_xy(vec : Vec3*, result : Vec2*)
  fun vec3_get_xy0 = graphene_vec3_get_xy0(vec : Vec3*, result : Vec3*)
  fun vec3_get_xyz0 = graphene_vec3_get_xyz0(vec : Vec3*, result : Vec4*)
  fun vec3_get_xyz1 = graphene_vec3_get_xyz1(vec : Vec3*, result : Vec4*)
  fun vec3_get_xyzw = graphene_vec3_get_xyzw(vec : Vec3*, w : Float, result : Vec4*)
  fun vec3_zero = graphene_vec3_zero : Vec3*
  fun vec3_one = graphene_vec3_one : Vec3*
  fun vec3_x_axis = graphene_vec3_x_axis : Vec3*
  fun vec3_y_axis = graphene_vec3_y_axis : Vec3*
  fun vec3_z_axis = graphene_vec3_z_axis : Vec3*
end

macro aligned_pointerof(expression)
  {% begin %}
  begin
    %array = uninitialized typeof({{expression}})[2]
    %offset = %array.to_unsafe.address
    %aligned_offset = (%offset + 15) & ~15_u64
    %ptr = Pointer(typeof({{expression}})).new(%aligned_offset)
    %ptr.copy_from(pointerof({{expression}}), 1)
    %ptr
  end
  {% end %}
end

struct Graphene::Vec3
  Zero  = Vec3.new(LibGraphene.vec3_zero.value)
  One   = Vec3.new(LibGraphene.vec3_one.value)
  XAxis = Vec3.new(LibGraphene.vec3_x_axis.value)
  YAxis = Vec3.new(LibGraphene.vec3_y_axis.value)
  ZAxis = Vec3.new(LibGraphene.vec3_z_axis.value)

  @value : LibGraphene::Vec3

  def initialize(@value)
  end

  def initialize(x : Float32, y : Float32, z : Float32)
    LibGraphene.vec3_init(out @value, x, y, z)
  end

  def initialize(src : self)
    LibGraphene.vec3_init_from_vec3(out @value, pointerof(src.@value))
  end

  def initialize(src : Float32[3])
    LibGraphene.vec3_init_from_float(out @value, pointerof(src))
  end

  def to_float : Float32[3]
    dest = uninitialized Float32[3]
    LibGraphene.vec3_to_float(pointerof(@value), pointerof(dest))
    dest
  end

  def +(value : Float32) : self
    self + Vec3.new(value, value, value)
  end

  def +(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_add(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def -(value : Float32) : self
    self - Vec3.new(value, value, value)
  end

  def -(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_subtract(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def *(value : Float32) : self
    self * Vec3.new(value, value, value)
  end

  def *(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_multiply(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def /(value : Float32) : self
    self / Vec3.new(value, value, value)
  end

  def /(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_divide(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def cross(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_cross(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def dot(other : self) : Float32
    LibGraphene.vec3_dot(pointerof(@value), pointerof(other.@value))
  end

  def scale(factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec3_scale(pointerof(@value), factor, pointerof(result.@value))
    result
  end

  def magnitude : Float32
    LibGraphene.vec3_length(pointerof(@value))
  end

  def normalize : self
    result = uninitialized self
    LibGraphene.vec3_normalize(pointerof(@value), pointerof(result.@value))
    result
  end

  def - : self
    result = uninitialized self
    LibGraphene.vec3_negate(pointerof(@value), pointerof(result.@value))
    result
  end

  def ==(other : self) : Bool
    LibGraphene.vec3_equal(pointerof(@value), pointerof(other.@value)) == 0 ? false : true
  end

  def near(other : self, epsilon : Float32) : Bool
    LibGraphene.vec3_near(pointerof(@value), pointerof(other.@value), epsilon)
  end

  def min(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_min(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def max(other : self) : self
    result = uninitialized self
    LibGraphene.vec3_max(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def interpolate(other : self, factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec3_interpolate(pointerof(@value), pointerof(other.@value), factor, pointerof(result.@value))
    result
  end

  def x : Float32
    LibGraphene.vec3_get_x(pointerof(@value))
  end

  def y : Float32
    LibGraphene.vec3_get_y(pointerof(@value))
  end

  def z : Float32
    LibGraphene.vec3_get_z(pointerof(@value))
  end

  def xy : Vec2
    result = uninitialized Vec2
    LibGraphene.vec3_get_xy(pointerof(@value), pointerof(result.@value))
    result
  end

  def xy0 : self
    result = uninitialized self
    LibGraphene.vec3_get_xy0(pointerof(@value), pointerof(result.@value))
    result
  end

  def xyz0 : Vec4
    result = uninitialized Vec4
    LibGraphene.vec3_get_xyz0(pointerof(@value), pointerof(result.@value))
    result
  end

  def xyz1 : Vec4
    result = uninitialized Vec4
    LibGraphene.vec3_get_xyz1(pointerof(@value), pointerof(result.@value))
    result
  end

  def xyzw(w : Float32) : Vec4
    result = uninitialized Vec4
    LibGraphene.vec3_get_xyzw(pointerof(@value), w, pointerof(result.@value))
    result
  end
end
