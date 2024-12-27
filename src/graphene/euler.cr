lib LibGraphene
  fun euler_alloc = graphene_euler_alloc : Euler*
  fun euler_free = graphene_euler_free(euler : Euler*)
  fun euler_init = graphene_euler_init(euler : Euler*, x : Float, y : Float, z : Float) : Euler*
  fun euler_init_with_order = graphene_euler_init_with_order(euler : Euler*, x : Float, y : Float, z : Float, order : EulerOrder) : Euler*
  fun euler_init_from_matrix = graphene_euler_init_from_matrix(euler : Euler*, matrix : Matrix*, order : EulerOrder) : Euler*
  fun euler_init_from_quaternion = graphene_euler_init_from_quaternion(euler : Euler*, quaternion : Quaternion*, order : EulerOrder) : Euler*
  fun euler_init_from_vec3 = graphene_euler_init_from_vec3(euler : Euler*, vec : Vec3*, order : EulerOrder) : Euler*
  fun euler_init_from_euler = graphene_euler_init_from_euler(euler : Euler*, other : Euler*) : Euler*
  fun euler_init_from_radians = graphene_euler_init_from_radians(euler : Euler*, x : Float, y : Float, z : Float, order : EulerOrder) : Euler*
  fun euler_equal = graphene_euler_equal(euler : Euler*, other : Euler*) : Bool
  fun euler_get_x = graphene_euler_get_x(euler : Euler*) : Float
  fun euler_get_y = graphene_euler_get_y(euler : Euler*) : Float
  fun euler_get_z = graphene_euler_get_z(euler : Euler*) : Float
  fun euler_get_order = graphene_euler_get_order(euler : Euler*) : EulerOrder
  fun euler_get_alpha = graphene_euler_get_alpha(euler : Euler*) : Float
  fun euler_get_beta = graphene_euler_get_beta(euler : Euler*) : Float
  fun euler_get_gamma = graphene_euler_get_gamma(euler : Euler*) : Float
  fun euler_to_vec3 = graphene_euler_to_vec3(euler : Euler*, result : Vec3*)
  fun euler_to_matrix = graphene_euler_to_matrix(euler : Euler*, result : Matrix*)
  fun euler_to_quaternion = graphene_euler_to_quaternion(euler : Euler*, result : Quaternion*)
  fun euler_reorder = graphene_euler_reorder(euler : Euler*, order : EulerOrder, result : Euler*)
end
