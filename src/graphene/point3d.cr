lib LibGraphene
  fun point3d_alloc = graphene_point3d_alloc : Point3D*
  fun point3d_free = graphene_point3d_free(point : Point3D*)
  fun point3d_init = graphene_point3d_init(point : Point3D*, x : Float, y : Float, z : Float) : Point3D*
  fun point3d_init_from_point = graphene_point3d_init_from_point(point : Point3D*, other : Point3D*) : Point3D*
  fun point3d_init_from_vec3 = graphene_point3d_init_from_vec3(point : Point3D*, vec : Vec3*) : Point3D*
  fun point3d_to_vec3 = graphene_point3d_to_vec3(point : Point3D*, vec : Vec3*)
  fun point3d_equal = graphene_point3d_equal(point : Point3D*, other : Point3D*) : Bool
  fun point3d_near = graphene_point3d_near(point : Point3D*, other : Point3D*, epsilon : Float) : Bool
  fun point3d_scale = graphene_point3d_scale(point : Point3D*, factor : Float, result : Point3D*)
  fun point3d_cross = graphene_point3d_cross(point : Point3D*, other : Point3D*, result : Point3D*)
  fun point3d_dot = graphene_point3d_dot(point : Point3D*, other : Point3D*) : Float
  fun point3d_length = graphene_point3d_length(point : Point3D*) : Float
  fun point3d_normalize = graphene_point3d_normalize(point : Point3D*, result : Point3D*)
  fun point3d_normalize_viewport = graphene_point3d_normalize_viewport(point : Point3D*, viewport : Rect*, z_near : Float, z_far : Float, result : Point3D*)
  fun point3d_distance = graphene_point3d_distance(point : Point3D*, other : Point3D*, delta : Vec3*) : Float
  fun point3d_interpolate = graphene_point3d_interpolate(point : Point3D*, other : Point3D*, factor : Double, result : Point3D*)
  fun point3d_zero = graphene_point3d_zero : Point3D*
end

struct Graphene::Point3D
  @value : LibGraphene::Point3D

  def initialize(x : Float32, y : Float32, z : Float32)
    LibGraphene.point3d_init(out @value, x, y, z)
  end

  def initialize(other : Point3D)
    LibGraphene.point3d_init_from_point(out @value, pointerof(other.@value))
  end

  def initialize(vec : Vec3)
    LibGraphene.point3d_init_from_vec3(out @value, pointerof(vec.@value))
  end
end
