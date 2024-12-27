lib LibGraphene
  fun size_alloc = graphene_size_alloc : Size*
  fun size_free = graphene_size_free(size : Size*)
  fun size_init = graphene_size_init(size : Size*, width : Float, height : Float) : Size*
  fun size_init_from_size = graphene_size_init_from_size(size : Size*, src : Size*) : Size*
  fun size_equal = graphene_size_equal(size : Size*, other : Size*) : Bool
  fun size_scale = graphene_size_scale(size : Size*, factor : Float, result : Size*)
  fun size_interpolate = graphene_size_interpolate(size : Size*, other : Size*, factor : Double, result : Size*)
  fun size_zero = graphene_size_zero : Size*
end
