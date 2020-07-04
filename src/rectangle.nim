import nico

type
  Rectangle* = tuple[x, y, width, height: int]
  
proc render*(this: Rectangle) =
  rectfill(this.x, this.y, this.x + this.width, this.y + this.height)
