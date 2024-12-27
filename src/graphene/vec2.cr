lib LibGraphene
  fun vec2_alloc = graphene_vec2_alloc : Vec2*
  fun vec2_free = graphene_vec2_free(vec : Vec2*)
  fun vec2_init = graphene_vec2_init(vec : Vec2*, x : Float, y : Float) : Vec2*
  fun vec2_init_from_vec2 = graphene_vec2_init_from_vec2(vec : Vec2*, src : Vec2*) : Vec2*
  fun vec2_init_from_float = graphene_vec2_init_from_float(vec : Vec2*, src : Float*) : Vec2*
  fun vec2_to_float = graphene_vec2_to_float(vec : Vec2*, dest : Float*)
  fun vec2_add = graphene_vec2_add(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_subtract = graphene_vec2_subtract(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_multiply = graphene_vec2_multiply(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_divide = graphene_vec2_divide(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_dot = graphene_vec2_dot(vec : Vec2*, other : Vec2*) : Float
  fun vec2_scale = graphene_vec2_scale(vec : Vec2*, factor : Float, result : Vec2*)
  fun vec2_length = graphene_vec2_length(vec : Vec2*) : Float
  fun vec2_normalize = graphene_vec2_normalize(vec : Vec2*, result : Vec2*)
  fun vec2_negate = graphene_vec2_negate(vec : Vec2*, result : Vec2*)
  fun vec2_equal = graphene_vec2_equal(vec : Vec2*, other : Vec2*) : Bool
  fun vec2_near = graphene_vec2_near(vec : Vec2*, other : Vec2*, epsilon : Float) : Bool
  fun vec2_min = graphene_vec2_min(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_max = graphene_vec2_max(vec : Vec2*, other : Vec2*, result : Vec2*)
  fun vec2_interpolate = graphene_vec2_interpolate(vec : Vec2*, other : Vec2*, factor : Float, result : Vec2*)
  fun vec2_get_x = graphene_vec2_get_x(vec : Vec2*) : Float
  fun vec2_get_y = graphene_vec2_get_y(vec : Vec2*) : Float
  fun vec2_zero = graphene_vec2_zero : Vec2*
  fun vec2_one = graphene_vec2_one : Vec2*
  fun vec2_x_axis = graphene_vec2_x_axis : Vec2*
  fun vec2_y_axis = graphene_vec2_y_axis : Vec2*
end

struct Graphene::Vec2
  Zero  = Vec2.new(LibGraphene.vec2_zero.value)
  One   = Vec2.new(LibGraphene.vec2_one.value)
  XAxis = Vec2.new(LibGraphene.vec2_x_axis.value)
  YAxis = Vec2.new(LibGraphene.vec2_y_axis.value)

  @value : LibGraphene::Vec2

  def initialize(@value)
  end

  def initialize(x : Float32, y : Float32)
    LibGraphene.vec2_init(out @value, x, y)
  end

  def initialize(src : self)
    LibGraphene.vec2_init_from_vec2(out @value, pointerof(src.@value))
  end

  def initialize(src : Float32[2])
    LibGraphene.vec2_init_from_float(out @value, pointerof(src))
  end

  def to_float : Float32[2]
    dest = uninitialized Float32[2]
    LibGraphene.vec2_to_float(pointerof(@value), pointerof(dest))
    dest
  end

  def +(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_add(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def -(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_subtract(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def *(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_multiply(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def /(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_divide(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def dot(other : self) : Float32
    LibGraphene.vec2_dot(pointerof(@value), pointerof(other.@value))
  end

  def scale(factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec2_scale(pointerof(@value), factor, pointerof(result.@value))
    result
  end

  def size : Float32
    LibGraphene.vec2_length(pointerof(@value))
  end

  def normalize : self
    result = uninitialized self
    LibGraphene.vec2_normalize(pointerof(@value), pointerof(result.@value))
    result
  end

  def - : self
    result = uninitialized self
    LibGraphene.vec2_negate(pointerof(@value), pointerof(result.@value))
    result
  end

  def ==(other : self) : Bool
    LibGraphene.vec2_equal(pointerof(@value), pointerof(other.@value)) == 0 ? false : true
  end

  def near(other : self, epsilon : Float32) : Bool
    LibGraphene.vec2_near(pointerof(@value), pointerof(other.@value), epsilon)
  end

  def min(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_min(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def max(other : self) : self
    result = uninitialized self
    LibGraphene.vec2_max(pointerof(@value), pointerof(other.@value), pointerof(result.@value))
    result
  end

  def interpolate(other : self, factor : Float32) : self
    result = uninitialized self
    LibGraphene.vec2_interpolate(pointerof(@value), pointerof(other.@value), factor, pointerof(result.@value))
    result
  end

  def x : Float32
    LibGraphene.vec2_get_x(pointerof(@value))
  end

  def y : Float32
    LibGraphene.vec2_get_y(pointerof(@value))
  end
end
