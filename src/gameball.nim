import nico, vector2d

type
  Ball* = ref object of RootObj
    x*: float
    y*: float
    radius*: int
    vector*: Vector2D 

proc newBall*(x, y: float, radius: int): Ball =
  return Ball(x: x, y: y, radius: radius) 

proc collide*(this: Ball, normal: Vector2D) =
  var absVector = this.vector.abs() 
  absVector *= normal  
  absVector *= 2
  this.vector += absVector
   
proc update*(this: Ball, dt: float) =
  this.x += dt * this.vector.x
  this.y += dt * this.vector.y

proc render*(this: Ball) =
  circfill(this.x, this.y, this.radius)
