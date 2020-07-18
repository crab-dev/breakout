import nico, gameball, gamepaddle, collision, rectangle, vector2d, audioplayer

const
  playAreaWidth = 300
  playAreaHeight = 256 
  columns = 10
  rows = 6
  brickAreaWidth = playAreaWidth - 24
  brickAreaHeight = (playAreaHeight / 3).int
  gap = 4
  brickWidth = ((brickAreaWidth - (gap * (columns - 1))) / columns).int
  brickHeight = ((brickAreaHeight - (gap * (rows - 1))) / rows).int
  xOffset = 12 
  yOffset = 16
  paddleWidth = 48
  paddleStartLoc: Vector2D = newVector2D(playAreaWidth / 2 - paddleWidth / 2, playAreaHeight.float - 24.0)

var 
  ball: Ball 
  paddle: Paddle
  bricks: seq[Rectangle]
  isRunning = false
  lives = 3
  score = 0

proc onWallBounce() =
  playSound() 

proc onBrickHit() =
  playSound()

proc bounceOffWalls(dt: float): bool = 
  let moveDist = ball.velocity * dt 
  if moveDist.y > 0:
    let distToWall = playAreaHeight.float - (ball.y + ball.radius.float)
    if moveDist.y >= distToWall:
      dec lives
      ball.velocity = newVector2D(0.0, 0.0)
      isRunning = false

  elif moveDist.y < 0:
    let distToWall = ball.y - ball.radius.float
    if moveDist.y.abs >= distToWall:
      ball.y -= distToWall  
      ball.velocity.y *= -1
      result = true

  if moveDist.x > 0:
    let distToWall = playAreaWidth.float - (ball.x + ball.radius.float)
    if moveDist.x >= distToWall:
      ball.x += distToWall 
      ball.velocity.x *= -1
      result = true
  elif moveDist.x < 0:
    let distToWall = ball.x - ball.radius.float
    if moveDist.x.abs >= distToWall:
      ball.x -= distToWall  
      ball.velocity.x *= -1
      result = true

proc collideBallAndPaddle*(dt: float): bool =
  let 
    ballDist = ball.velocity * dt
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
    ball.velocity.y *= -1
    return true

proc reset() =
  paddle = newPaddle(paddleStartLoc.x.int, paddleStartLoc.y.int, paddleWidth, paddleWidth div 8)
  lives = 3
  score = 0
  bricks = newSeq[Rectangle]()

  for row in 0 .. 5:
    for col in 0 .. 9:
      let x = xOffset + col * (brickWidth + gap) 
      let y = yOffset + row * (brickHeight + gap)
      let rect = (x, y, brickWidth, brickHeight)
      bricks.add(rect)

proc gameInit() =
  loadFont(0, "font.png")
  loadAudioFiles()
  ball = newBall(0, 0, 4)
  reset()
  
proc destroyBrick(index: int) =
  bricks.delete(index) 

proc collideWithBricks(displacement: Vector2D): bool =
  for i, brick in bricks:
    if collide(ball, brick, displacement):
      destroyBrick(i)
      inc score
      return true
    
  return false

proc setPaddleLocation(mouseX: int) =
  var newPaddleX = mouseX - paddle.width div 2
  if newPaddleX < 0:
    newPaddleX = 0
  elif newPaddleX > playAreaWidth - paddle.width:
    newPaddleX = playAreaWidth - paddle.width
  paddle.x = newPaddleX

proc centerBallOnPaddle() =
  ball.location = newVector2D(paddle.x.float + paddle.width / 2, paddle.y.float - ball.radius.float)

proc gameUpdate(dt: float32) =
  let mouseX = mouse()[0]  
  setPaddleLocation(mouseX)
  if not isRunning:
    centerBallOnPaddle()
    if key(K_SPACE):
      isRunning = true
      ball.velocity = newVector2D(150.0, 270.0)
      if lives == 0:
        reset()

  let displacement = ball.velocity * dt

  if bounceOffWalls(dt):
    onWallBounce()

  if collideWithBricks(displacement):
    onBrickHit()
  elif not collideBallAndPaddle(dt):
    ball.update(dt)
     
proc gameDraw() =
  cls()
  setColor(1)
  rectFill(0, 0, playAreaWidth, playAreaHeight)
  setColor(12)
  ball.render()
  setColor(13)
  paddle.render()
  setColor(12)
  print("Lives: " & $lives, 4, 246)
  print("Score: " & $score, 4, 236)
  if not isRunning:
    if lives > 0:
      printc("Press Space to Start", playAreaWidth div 2, playAreaHeight div 2)
    else:
      printc("Game Over!", playAreaWidth div 2, playAreaHeight div 2)
      printc("Press Space to Play Again", playAreaWidth div 2, playAreaHeight div 2 + 8)
  setColor(13)
  for brick in bricks:
    brick.render


nico.init("myOrg", "myApp")
nico.createWindow("myApp", playAreaWidth, playAreaHeight, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
