import rectangle 

type
  Paddle* = ref object of RootObj
    rectangle: Rectangle

proc newPaddle*(x, y, width, height: int): Paddle =
  Paddle(rectangle: (x, y, width, height))

proc x*(this: Paddle): int {.inline.} =
  this.rectangle.x

proc `x=`*(this: Paddle, x: int) {.inline.} =
  this.rectangle.x = x

proc y*(this: Paddle): int {.inline.} =
  this.rectangle.y

proc width*(this: Paddle): int =
  this.rectangle.width

proc height*(this: Paddle): int =
  this.rectangle.height

proc render*(this: Paddle) =
  this.rectangle.render()

proc right*(this: Paddle): int {.inline.} =
  this.rectangle.x + this.rectangle.width 


