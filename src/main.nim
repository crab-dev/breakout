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

var 
  ball: Ball 
  paddle: Paddle
  bricks: seq[Rectangle]

proc onWallBounce() =
  playSound() 

proc onBrickHit() =
  playSound()

proc bounceOffWalls(dt: float): bool = 
  let moveDist = ball.velocity * dt 
  if moveDist.y > 0:
    let distToWall = playAreaHeight.float - (ball.y + ball.radius.float)
    if moveDist.y >= distToWall:
      ball.y += distToWall 
      ball.velocity.y *= -1
      result = true
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

proc gameInit() =
  let paddleWidth = 48
  paddle = newPaddle(playAreaWidth div 2 - paddleWidth div 2, playAreaHeight - 24, paddleWidth, paddleWidth div 8)
  ball = newBall(20, paddle.y.float - 4, 4)
  ball.velocity = (100.0, 270.0)
  loadAudioFiles()
  bricks = newSeq[Rectangle]()

  for row in 0 .. 5:
    for col in 0 .. 9:
      let x = xOffset + col * (brickWidth + gap) 
      let y = yOffset + row * (brickHeight + gap)
      let rect = (x, y, brickWidth, brickHeight)
      bricks.add(rect)

proc destroyBrick(index: int) =
  bricks.delete(index) 

proc collideWithBricks(displacement: Vector2D): bool =
  for i, brick in bricks:
    if collide(ball, brick, displacement):
      destroyBrick(i)
      return true
    
  return false

proc gameUpdate(dt: float32) =
  let 
    mouseX = mouse()[0]
    newPaddleX = mouseX - paddle.width div 2
    displacement = ball.velocity * dt

  paddle.x = newPaddleX

  if bounceOffWalls(dt):
    onWallBounce()

  # TODO: Call this for each brick until one has been hit
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
  for brick in bricks:
    brick.render

nico.init("myOrg", "myApp")
nico.createWindow("myApp", playAreaWidth, playAreaHeight, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
