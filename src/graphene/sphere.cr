lib LibGraphene
  fun sphere_alloc = graphene_sphere_alloc : Sphere*
  fun sphere_free = graphene_sphere_free(sphere : Sphere*)
  fun sphere_init = graphene_sphere_init(sphere : Sphere*, center : Point3D*, radius : Float) : Sphere*
  fun sphere_init_from_points = graphene_sphere_init_from_points(sphere : Sphere*, size : UInt, points : Point3D*, center : Point3D*) : Sphere*
  fun sphere_init_from_vectors = graphene_sphere_init_from_vectors(sphere : Sphere*, size : UInt, vectors : Vec3*, center : Point3D*) : Sphere*
  fun sphere_get_center = graphene_sphere_get_center(sphere : Sphere*, center : Point3D*)
  fun sphere_get_radius = graphene_sphere_get_radius(sphere : Sphere*) : Float
  fun sphere_get_bounding_box = graphene_sphere_get_bounding_box(sphere : Sphere*, box : Box*)
  fun sphere_is_empty = graphene_sphere_is_empty(sphere : Sphere*) : Bool
  fun sphere_distance = graphene_sphere_distance(sphere : Sphere*, point : Point3D*) : Float
  fun sphere_contains_point = graphene_sphere_contains_point(sphere : Sphere*, point : Point3D*) : Bool
  fun sphere_translate = graphene_sphere_translate(sphere : Sphere*, point : Point3D*, result : Sphere*)
  fun sphere_equal = graphene_sphere_equal(sphere : Sphere*, other : Sphere*) : Bool
end
