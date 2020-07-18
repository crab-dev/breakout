type Vector2D* = object
  x*: float
  y*: float

const VECTOR_ZERO* = (0.0, 0.0)

proc newVector2D*(x, y: float): Vector2D =
  Vector2D(x: x, y: y)

proc `*`*(this: Vector2D, scalar: float): Vector2D =
  newVector2D(this.x * scalar, this.y * scalar)

proc `*`*(a, b: Vector2D): Vector2D =
  newVector2D(a.x * b.x, a.y * b.y)

proc `*=`*(a: var Vector2D, b: Vector2D) =
  a = a * b 

proc `*=`*(this: var Vector2D, scalar: float) =
  this = newVector2D(this.x * scalar, this.y * scalar)

proc `+`*(a, b: Vector2D): Vector2D =
  newVector2D(a.x + b.x, a.y + b.y)
  
proc `+=`*(a: var Vector2D, b: Vector2D) =
  a = a + b

proc abs*(this: Vector2D): Vector2D =
  return newVector2D(abs(this.x), abs(this.y))
