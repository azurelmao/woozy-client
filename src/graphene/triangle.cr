lib LibGraphene
  fun triangle_alloc = graphene_triangle_alloc : Triangle*
  fun triangle_free = graphene_triangle_free(triangle : Triangle*)
  fun triangle_init_from_point3d = graphene_triangle_init_from_point3d(triangle : Triangle*, a : Point3D*, b : Point3D*, c : Point3D*) : Triangle*
  fun triangle_init_from_vec3 = graphene_triangle_init_from_vec3(triangle : Triangle*, a : Vec3*, b : Vec3*, c : Vec3*) : Triangle*
  fun triangle_init_from_float = graphene_triangle_init_from_float(triangle : Triangle*, a : Float, b : Float, c : Float) : Triangle*
  fun triangle_get_points = graphene_triangle_get_points(triangle : Triangle*, a : Point3D*, b : Point3D*, c : Point3D*)
  fun triangle_get_vertices = graphene_triangle_get_vertices(triangle : Triangle*, a : Vec3*, b : Vec3*, c : Vec3*)
  fun triangle_get_area = graphene_triangle_get_area(triangle : Triangle*) : Float
  fun triangle_get_midpoint = graphene_triangle_get_midpoint(triangle : Triangle*, result : Point3D*)
  fun triangle_get_normal = graphene_triangle_get_normal(triangle : Triangle*, result : Vec3*)
  fun triangle_get_plane = graphene_triangle_get_plane(triangle : Triangle*, result : Plane*)
  fun triangle_get_bounding_box = graphene_triangle_get_bounding_box(triangle : Triangle*, result : Box*)
  fun triangle_get_barycoords = graphene_triangle_get_barycoords(triangle : Triangle*, point : Point3D*, result : Vec2*) : Bool
  fun triangle_get_uv = graphene_triangle_get_uv(triangle : Triangle*, point : Point3D*, uv_a : Vec2*, uv_b : Vec2*, uv_c : Vec2*, result : Vec2*) : Bool
  fun triangle_contains_point = graphene_triangle_contains_point(triangle : Triangle*, point : Point3D*) : Bool
  fun triangle_equal = graphene_triangle_equal(triangle : Triangle*, other : Triangle*) : Bool
end
