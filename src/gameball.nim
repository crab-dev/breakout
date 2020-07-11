import nico, vector2d

type
  Ball* = ref object of RootObj
    x*: float
    y*: float
    radius*: int
    velocity*: Vector2D 

proc newBall*(x, y: float, radius: int): Ball =
  return Ball(x: x, y: y, radius: radius) 

proc location*(this: Ball): Vector2D {.inline.} =
  (this.x, this.y)

proc left*(this: Ball): float {.inline.} =
  this.x - this.radius.float

proc right*(this: Ball): float {.inline.} =
  this.x + this.radius.float

proc top*(this: Ball): float {.inline.} =
  this.y - this.radius.float

proc bottom*(this: Ball): float {.inline.} =
  this.y + this.radius.float

proc collide*(this: Ball, normal: Vector2D) =
  var absVelocity = this.velocity.abs() 
  absvelocity *= normal  
  absvelocity *= 2
  this.velocity += absvelocity
   
proc update*(this: Ball, dt: float) =
  this.x += dt * this.velocity.x
  this.y += dt * this.velocity.y

proc render*(this: Ball) =
  circfill(this.x, this.y, this.radius)

