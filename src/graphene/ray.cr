lib LibGraphene
  fun ray_alloc = graphene_ray_alloc : Ray*
  fun ray_free = graphene_ray_free(ray : Ray*)
  fun ray_init = graphene_ray_init(ray : Ray*, origin : Point3D*, direction : Point3D*) : Ray*
  fun ray_init_from_ray = graphene_ray_init_from_ray(ray : Ray*, src : Ray*) : Ray*
  fun ray_init_from_vec3 = graphene_ray_init_from_vec3(ray : Ray*, origin : Vec3*, direction : Vec3*) : Ray*
  fun ray_get_origin = graphene_ray_get_origin(ray : Ray*, origin : Point3D*)
  fun ray_get_direction = graphene_ray_get_direction(ray : Ray*, direction : Point3D*)
  fun ray_get_position_at = graphene_ray_get_position_at(ray : Ray*, distance : Float, position : Point3D*)
  fun ray_get_distance_to_point = graphene_ray_get_distance_to_point(ray : Ray*, point : Point3D*) : Float
  fun ray_get_distance_to_plane = graphene_ray_get_distance_to_plane(ray : Ray*, plane : Plane*) : Float
  fun ray_get_closest_point_to_point = graphene_ray_get_closest_point_to_point(ray : Ray*, point : Point3D*, result : Point3D*)
  fun ray_equal = graphene_ray_equal(ray : Ray*, other : Ray*) : Bool
  fun ray_intersect_sphere = graphene_ray_intersect_sphere(ray : Ray*, sphere : Sphere*, distance_at_intersection : Float*) : RayIntersectionKind
  fun ray_intersects_sphere = graphene_ray_intersects_sphere(ray : Ray*, sphere : Sphere*) : Bool
  fun ray_intersect_box = graphene_ray_intersect_box(ray : Ray*, box : Box*, distance_at_intersection : Float*) : RayIntersectionKind
  fun ray_intersects_box = graphene_ray_intersects_box(ray : Ray*, box : Box*) : Bool
  fun ray_intersect_triangle = graphene_ray_intersect_triangle(ray : Ray*, triangle : Triangle*, distance_at_intersection : Float*) : RayIntersectionKind
  fun ray_intersects_triangle = graphene_ray_intersects_triangle(ray : Ray*, triangle : Triangle*) : Bool
end
