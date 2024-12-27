lib LibGraphene
  fun point_alloc = graphene_point_alloc : Point*
  fun point_free = graphene_point_free(point : Point*)
  fun point_init = graphene_point_init(point : Point*, x : Float, y : Float) : Point*
  fun point_init_from_point = graphene_point_init_from_point(point : Point*, other : Point*) : Point*
  fun point_init_from_vec2 = graphene_point_init_from_vec2(point : Point*, vec : Vec2*) : Point*
  fun point_equal = graphene_point_equal(point : Point*, other : Point*) : Bool
  fun point_distance = graphene_point_distance(point : Point*, other : Point*, d_x : Float*, d_y : Float*) : Float
  fun point_near = graphene_point_near(point : Point*, other : Point*, epsilon : Float) : Bool
  fun point_interpolate = graphene_point_interpolate(point : Point*, other : Point*, factor : Double, result : Point*)
  fun point_to_vec2 = graphene_point_to_vec2(point : Point*, vec : Vec2*)
  fun point_zero = graphene_point_zero : Point*
end
