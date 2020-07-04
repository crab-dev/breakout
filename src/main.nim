import nico, gameball, gamepaddle, vector2d, audioplayer

const
  playAreaWidth = 256
  playAreaHeight = 256 
  
var 
  ball: Ball 
  paddle: Paddle

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

proc collideBallAndPaddle*(dt: float): bool =
  let 
    ballDist = ball.vector * dt
    ballBottomStart = ball.y + ball.radius.float
    ballBottomEnd = ballBottomStart + ballDist.y
    paddleBottom = (paddle.y + paddle.height).float

  if ballBottomStart > paddleBottom or ballBottomEnd < paddle.y.float:
    return false

  let 
    displacedBallY = paddle.y.float - ballBottomStart 
    yDistToPaddle = abs(displacedBallY)
    distToPaddleRatio = yDistToPaddle / ballDist.y
    displacedBallX = ballDist.x * distToPaddleRatio
    displacedBallLeft = ball.x + displacedBallX - ball.radius.float
    displacedBallRight = ball.x + displacedBallX + ball.radius.float

  if displacedBallLeft >= paddle.x.float and displacedBallLeft <= paddle.right.float or 
     displacedBallRight >= paddle.x.float and displacedBallRight <= paddle.right.float:
    ball.x += displacedBallX
    ball.y += displacedBallY
    ball.vector.y *= -1
    return true

proc gameInit() =
  let paddleWidth = 48
  paddle = newPaddle(playAreaWidth div 2 - paddleWidth div 2, playAreaHeight - 24, paddleWidth, paddleWidth div 8)
  ball = newBall(20, 20, 4)
  ball.vector = (200.0, 370.0)
  loadAudioFiles()

proc gameUpdate(dt: float32) =
  let 
    mouseX = mouse()[0]
    newPaddleX = mouseX - paddle.width div 2

  paddle.x = newPaddleX

  if bounceOffWalls(dt):
    onWallBounce()
  if not collideBallAndPaddle(dt):
    ball.update(dt)

proc gameDraw() =
  cls()
  setColor(8)
  ball.render()
  paddle.render()

nico.init("myOrg", "myApp")
nico.createWindow("myApp", playAreaWidth, playAreaHeight, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
