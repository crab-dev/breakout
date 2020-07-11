import nico

type
  Rectangle* = tuple[x, y, width, height: int]
  
proc left*(this: Rectangle): float {.inline.} =
  this.x.float

proc right*(this: Rectangle): float {.inline.} =
  this.x.float + this.width.float

proc top*(this: Rectangle): float {.inline.} =
  this.y.float

proc bottom*(this: Rectangle): float {.inline.} =
  this.y.float + this.height.float

proc render*(this: Rectangle) =
  rectfill(this.x, this.y, this.x + this.width, this.y + this.height)
