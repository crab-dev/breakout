import gameball, rectangle, vector2d

proc collide*(ball: var Ball, rect: Rectangle, displacement: Vector2D): bool =
  let
    inTop = rect.top - ball.bottom
    inBottom = ball.top - rect.bottom
    inLeft = rect.left - ball.right
    inRight = ball.left - rect.right
    smallestIntersection = max(max(inTop, inBottom), max(inLeft, inRight))  

  if smallestIntersection >= 0.0:
    return false

  if inTop == smallestIntersection:
    if ball.velocity.y > 0:
      ball.velocity.y *= -1
    ball.y = rect.top - ball.radius.float
  elif inBottom == smallestIntersection:
    if ball.velocity.y < 0:
      ball.velocity.y *= -1
    ball.y = rect.bottom + ball.radius.float
  elif inLeft == smallestIntersection:
    if ball.velocity.x > 0:
      ball.velocity.x *= -1
    ball.x = rect.left - ball.radius.float
  elif inRight == smallestIntersection:
    if ball.velocity.x < 0:
      ball.velocity.x *= -1
    ball.x = rect.right + ball.radius.float

  return true

