@[Link(ldflags: "#{__DIR__}/../../slib/libgraphene-1.0.a")]
lib LibGraphene
  alias Float = LibC::Float
  alias Double = LibC::Double
  alias Int = LibC::Int
  alias UInt = LibC::UInt
  alias Bool = LibC::Int

  struct SIMD4f # Private
    x : Float
    y : Float
    z : Float
    w : Float
  end

  struct SIMD4x4f # Private
    x : SIMD4f
    y : SIMD4f
    z : SIMD4f
    w : SIMD4f
  end

  struct Vec2 # Private
    value : SIMD4f
  end

  struct Vec3 # Private
    value : SIMD4f
  end

  struct Vec4 # Private
    value : SIMD4f
  end

  struct Euler # Private
    angles : Vec3
    order : EulerOrder
  end

  enum EulerOrder : Int
    Default = -1
    XYZ
    YZX
    ZXY
    XZY
    YXZ
    ZYX
    SXYZ
    SXYX
    SXZY
    SXZX
    SYZX
    SYZY
    SYXZ
    SYXY
    SZXY
    SZXZ
    SZYX
    SZYZ
    RZYX
    RXYX
    RYZX
    RXZX
    RXZY
    RYZY
    RZXY
    RYXY
    RYXZ
    RZXZ
    RXYZ
    RZYZ
  end

  struct Quaternion # Private
    x : Float
    y : Float
    z : Float
    w : Float
  end

  struct Matrix # Private
    value : SIMD4x4f
  end

  struct Point
    x : Float
    y : Float
  end

  struct Point3D
    x : Float
    y : Float
    z : Float
  end

  struct Size
    width : Float
    height : Float
  end

  struct Ray # Private
    origin : Vec3
    direction : Vec3
  end

  enum RayIntersectionKind
    None
    Enter
    Leave
  end

  struct Plane # Private
    normal : Vec3
    constant : Float
  end

  struct Box # Private
    min : Vec3
    max : Vec3
  end

  struct Sphere # Private
    center : Vec3
    radius : Float
  end

  struct Frustum # Private
    planes : Plane[6]
  end

  struct Triangle # Private
    a : Vec3
    b : Vec3
    c : Vec3
  end

  struct Quad # Private
    points : Point[4]
  end

  struct Rect
    origin : Point
    size : Size
  end
end
