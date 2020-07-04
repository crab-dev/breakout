type Vector2D* = tuple[x, y: float]

const VECTOR_ZERO* = (0.0, 0.0)

proc `*`*(this: Vector2D, scalar: float): Vector2D =
  (this.x * scalar, this.y * scalar)

proc `*`*(a, b: Vector2D): Vector2D =
  (a.x * b.x, a.y * b.y)

proc `*=`*(a: var Vector2D, b: Vector2D) =
  a = a * b 

proc `*=`*(this: var Vector2D, scalar: float) =
  this = (this.x * scalar, this.y * scalar)

proc `+`*(a, b: Vector2D): Vector2D =
  (a.x + b.x, a.y + b.y)
  
proc `+=`*(a: var Vector2D, b: Vector2D) =
  a = a + b

proc abs*(this: Vector2D): Vector2D =
  return (abs(this.x), abs(this.y))
