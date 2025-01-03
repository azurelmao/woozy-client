lib LibGraphene
  fun rect_alloc = graphene_rect_alloc : Rect*
  fun rect_free = graphene_rect_free(rect : Rect*)
  fun rect_init = graphene_rect_init(rect : Rect*, x : Float, y : Float, width : Float, height : Float) : Rect*
  fun rect_init_from_rect = graphene_rect_init_from_rect(rect : Rect*, src : Rect*) : Rect*
  fun rect_equal = graphene_rect_equal(rect : Rect*, other : Rect*) : Bool
  fun rect_normalize = graphene_rect_normalize(rect : Rect*) : Rect*
  fun rect_normalize_r = graphene_rect_normalize_r(rect : Rect*, result : Rect*)
  fun rect_get_center = graphene_rect_get_center(rect : Rect*, point : Point*)
  fun rect_get_top_left = graphene_rect_get_top_left(rect : Rect*, point : Point*)
  fun rect_get_top_right = graphene_rect_get_top_right(rect : Rect*, point : Point*)
  fun rect_get_bottom_right = graphene_rect_get_bottom_right(rect : Rect*, point : Point*)
  fun rect_get_bottom_left = graphene_rect_get_bottom_left(rect : Rect*, point : Point*)
  fun rect_get_x = graphene_rect_get_x(rect : Rect*) : Float
  fun rect_get_y = graphene_rect_get_y(rect : Rect*) : Float
  fun rect_get_width = graphene_rect_get_width(rect : Rect*) : Float
  fun rect_get_height = graphene_rect_get_height(rect : Rect*) : Float
  fun rect_get_area = graphene_rect_get_area(rect : Rect*) : Float
  fun rect_get_vertices = graphene_rect_get_vertices(rect : Rect*, vertices : Vec2*)
  fun rect_union = graphene_rect_union(rect : Rect*, other : Rect*, result : Rect*)
  fun rect_intersection = graphene_rect_intersection(rect : Rect*, other : Rect*, result : Rect*) : Bool
  fun rect_contains_point = graphene_rect_contains_point(rect : Rect*, point : Point*) : Bool
  fun rect_contains_rect = graphene_rect_contains_rect(rect : Rect*, other : Rect*) : Bool
  fun rect_offset = graphene_rect_offset(rect : Rect*, d_x : Float, d_y : Float) : Rect*
  fun rect_offset_r = graphene_rect_offset_r(rect : Rect*, d_x : Float, d_y : Float, result : Rect*)
  fun rect_inset = graphene_rect_inset(rect : Rect*, d_x : Float, d_y : Float) : Rect*
  fun rect_inset_r = graphene_rect_inset_r(rect : Rect*, d_x : Float, d_y : Float, result : Rect*)
  fun rect_round_to_pixel = graphene_rect_round_to_pixel(rect : Rect*) : Rect* # Deprecated
  fun rect_round = graphene_rect_round(rect : Rect*, result : Rect*)           # Deprecated
  fun rect_round_extents = graphene_rect_round_extents(rect : Rect*, result : Rect*)
  fun rect_expand = graphene_rect_expand(rect : Rect*, point : Point*, result : Rect*)
  fun rect_interpolate = graphene_rect_interpolate(rect : Rect*, other : Rect*, factor : Double, result : Rect*)
  fun rect_zero = graphene_rect_zero : Rect*
  fun rect_scale = graphene_rect_scale(rect : Rect*, s_h : Float, s_v : Float, result : Rect*)
end
