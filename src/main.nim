import nico, gameball, vector2d, audioplayer

const
  playAreaWidth = 256
  playAreaHeight = 256 
  
var 
  ball: Ball 

proc onWallBounce() =
  playSound() 
  
proc bounceOffWalls(dt: float): bool = 
  let moveDist = ball.vector * dt 
  if moveDist.y > 0:
    let distToWall = playAreaHeight.float - (ball.y + ball.radius.float)
    if moveDist.y >= distToWall:
      ball.y += distToWall 
      ball.vector.y *= -1
      result = true
  elif moveDist.y < 0:
    let distToWall = ball.y - ball.radius.float
    if moveDist.y.abs >= distToWall:
      ball.y -= distToWall  
      ball.vector.y *= -1
      result = true

  if moveDist.x > 0:
    let distToWall = playAreaWidth.float - (ball.x + ball.radius.float)
    if moveDist.x >= distToWall:
      ball.x += distToWall 
      ball.vector.x *= -1
      result = true
  elif moveDist.x < 0:
    let distToWall = ball.x - ball.radius.float
    if moveDist.x.abs >= distToWall:
      ball.x -= distToWall  
      ball.vector.x *= -1
      result = true

proc gameInit() =
  ball = newBall(20, 20, 4)
  ball.vector = (600.0, 570.0)
  loadAudioFiles()

proc gameUpdate(dt: float32) =
  if bounceOffWalls(dt):
    onWallBounce()
  ball.update(dt)

proc gameDraw() =
  cls()
  setColor(8)
  ball.render()

nico.init("myOrg", "myApp")
nico.createWindow("myApp", playAreaWidth, playAreaHeight, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
