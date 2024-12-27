lib LibGraphene
  fun quad_alloc = graphene_quad_alloc : Quad*
  fun quad_free = graphene_quad_free(quad : Quad*)
  fun quad_init = graphene_quad_init(quad : Quad*, p1 : Point*, p2 : Point*, p3 : Point*, p4 : Point*) : Quad*
  fun quad_init_from_rect = graphene_quad_init_from_rect(quad : Quad*, rect : Rect*) : Quad*
  fun quad_init_from_points = graphene_quad_init_from_points(quad : Quad*, points : Point*) : Quad*
  fun quad_contains = graphene_quad_contains(quad : Quad*, point : Point*) : Bool
  fun quad_bounds = graphene_quad_bounds(quad : Quad*, rect : Rect*)
  fun quad_get_point = graphene_quad_get_point(quad : Quad*, index : UInt) : Quad*
end
