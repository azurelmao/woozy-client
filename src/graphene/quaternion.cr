lib LibGraphene
  fun quaternion_alloc = graphene_quaternion_alloc : Quaternion*
  fun quaternion_free = graphene_quaternion_free(quaternion : Quaternion*)
  fun quaternion_init = graphene_quaternion_init(quaternion : Quaternion*, x : Float, y : Float, z : Float, w : Float) : Quaternion*
  fun quaternion_init_identity = graphene_quaternion_init_identity(quaternion : Quaternion*) : Quaternion*
  fun quaternion_init_from_quaternion = graphene_quaternion_init_from_quaternion(quaternion : Quaternion*, src : Quaternion*) : Quaternion*
  fun quaternion_init_from_vec4 = graphene_quaternion_init_from_vec4(quaternion : Quaternion*, vec : Vec4*) : Quaternion*
  fun quaternion_init_from_matrix = graphene_quaternion_init_from_matrix(quaternion : Quaternion*, matrix : Matrix*) : Quaternion*
  fun quaternion_init_from_angles = graphene_quaternion_init_from_angles(quaternion : Quaternion*, deg_x : Float, deg_y : Float, deg_z : Float) : Quaternion*
  fun quaternion_init_from_radians = graphene_quaternion_init_from_radians(quaternion : Quaternion*, rad_x : Float, rad_y : Float, rad_z : Float) : Quaternion*
  fun quaternion_init_from_angle_vec3 = graphene_quaternion_init_from_angle_vec3(quaternion : Quaternion*, angle : Float, axis : Vec3*) : Quaternion*
  fun quaternion_init_from_euler = graphene_quaternion_init_from_euler(quaternion : Quaternion*, euler : Euler*) : Quaternion*
  fun quaternion_to_vec4 = graphene_quaternion_to_vec4(quaternion : Quaternion*, result : Vec4*)
  fun quaternion_to_matrix = graphene_quaternion_to_matrix(quaternion : Quaternion*, result : Matrix*)
  fun quaternion_to_angles = graphene_quaternion_to_angles(quaternion : Quaternion*, deg_x : Float*, deg_y : Float*, deg_z : Float*)
  fun quaternion_to_radians = graphene_quaternion_to_radians(quaternion : Quaternion*, deg_x : Float*, deg_y : Float*, deg_z : Float*)
  fun quaternion_to_angle_vec3 = graphene_quaternion_to_angle_vec3(quaternion : Quaternion*, angle : Float*, axis : Vec3*)
  fun quaternion_equal = graphene_quaternion_equal(quaternion : Quaternion*, other : Quaternion*) : Bool
  fun quaternion_dot = graphene_quaternion_dot(quaternion : Quaternion*, other : Quaternion*) : Float
  fun quaternion_invert = graphene_quaternion_invert(quaternion : Quaternion*, result : Quaternion*)
  fun quaternion_normalize = graphene_quaternion_normalize(quaternion : Quaternion*, result : Quaternion*)
  fun quaternion_add = graphene_quaternion_add(quaternion : Quaternion*, other : Quaternion*, result : Quaternion*)
  fun quaternion_multiply = graphene_quaternion_multiply(quaternion : Quaternion*, other : Quaternion*, result : Quaternion*)
  fun quaternion_scale = graphene_quaternion_scale(quaternion : Quaternion*, factor : Float, result : Quaternion*)
  fun quaternion_slerp = graphene_quaternion_slerp(quaternion : Quaternion*, other : Quaternion*, factor : Float, result : Quaternion*)
end
