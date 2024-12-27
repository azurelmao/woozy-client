lib LibGraphene
  fun plane_alloc = graphene_plane_alloc : Plane*
  fun plane_free = graphene_plane_free(plane : Plane*)
  fun plane_init = graphene_plane_init(plane : Plane*, normal : Vec3*, constant : Float) : Plane*
  fun plane_init_from_vec4 = graphene_plane_init_from_vec4(plane : Plane*, src : Vec4*) : Plane*
  fun plane_init_from_plane = graphene_plane_init_from_plane(plane : Plane*, src : Plane*) : Plane*
  fun plane_init_from_point = graphene_plane_init_from_point(plane : Plane*, normal : Vec3*, point : Point3D*) : Plane*
  fun plane_init_from_points = graphene_plane_init_from_points(plane : Plane*, a : Point3D*, b : Point3D*, c : Point3D*) : Plane*
  fun plane_normalize = graphene_plane_normalize(plane : Plane*, result : Plane*)
  fun plane_negate = graphene_plane_negate(plane : Plane*, result : Plane*)
  fun plane_equal = graphene_plane_equal(plane : Plane*, other : Plane*) : Bool
  fun plane_distance = graphene_plane_distance(plane : Plane*, point : Point3D*) : Float
  fun plane_transform = graphene_plane_transform(plane : Plane*, matrix : Matrix*, normal_matrix : Matrix*, result : Plane*)
  fun plane_get_normal = graphene_plane_get_normal(plane : Plane*, normal : Vec3*)
  fun plane_get_constant = graphene_plane_get_constant(plane : Plane*) : Float
end
