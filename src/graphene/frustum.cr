lib LibGraphene
  fun frustum_alloc = graphene_frustum_alloc : Frustum*
  fun frustum_free = graphene_frustum_free(frustum : Frustum*)
  fun frustum_init = graphene_frustum_init(frustum : Frustum*, p1 : Plane*, p2 : Plane*, p3 : Plane*, p4 : Plane*, p5 : Plane*, p6 : Plane*) : Frustum*
  fun frustum_init_from_frustum = graphene_frustum_init_from_frustum(frustum : Frustum*, src : Frustum*) : Frustum*
  fun frustum_init_from_matrix = graphene_frustum_init_from_matrix(frustum : Frustum*, matrix : Matrix*) : Frustum*
  fun frustum_get_planes = graphene_frustum_get_planes(frustum : Frustum*, planes : Plane*)
  fun frustum_contains_point = graphene_frustum_contains_point(frustum : Frustum*, point : Point3D*) : Bool
  fun frustum_intersects_sphere = graphene_frustum_intersects_sphere(frustum : Frustum*, sphere : Sphere*) : Bool
  fun frustum_intersects_box = graphene_frustum_intersects_box(frustum : Frustum*, box : Box*) : Bool
  fun frustum_equal = graphene_frustum_equal(frustum : Frustum*, other : Frustum*) : Bool
end
