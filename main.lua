function love.load()
  playerx = 0
  constantplayery = 0
  playerimg = love.graphics.newImage("red.png")
  player2x = 448
  player2img = love.graphics.newImage("blue.png")
  jump = 64
  bg = love.graphics.newImage("bg.png")
  love.mouse.setVisible(false)
  playing = false
  timer = 3
  defaulttime = 3
  redblocks = {}
  blueblocks = {}
  shakey = 10
  oof = 50
  moving = false
  roundx = -200
  string = "press space to start"
  win = false
  winx = 10
  winy = 100
  winxv = 100
  winimg = love.graphics.newImage("win.png")
end

function love.draw()
  if playing then
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(bg, shakey, 0)
    for i = 1, 6 do
      love.graphics.setColor(0, 0, 1)
      love.graphics.rectangle("fill", blueblocks[i].x * 64 + shakey, blueblocks[i].y * 64, 64, 64)
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", redblocks[i].x * 64 + shakey, redblocks[i].y * 64, 64, 64)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(playerimg, playerx + shakey, constantplayery)
    love.graphics.draw(player2img, player2x + shakey, constantplayery)
    love.graphics.printf(math.ceil(timer), 0, 0, 500, "center")
    love.graphics.print("next round: "..defaulttime, roundx, 100)
  else
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(string, shakey, 128, 500, "center")
    if win then
      love.graphics.draw(winimg, winx, winy)
    end
  end
end

function love.update(dt)
  if win then
    winx = winx + dt * winxv
  end
  if winx < 0 then
    winxv = 100
  end
  if winx > 448 then
    winxv = -100
  end
  if shakey > 10 then
    oof = -50
  end
  if shakey < - 10 then
    oof = 50
  end
  shakey = shakey + dt * oof
  if playing and timer > 0 then
    timer = timer - dt
  end
  if playing and timer < 0 then
    isdead()
    timer = 0
    oof = 0
    shakey = 0
  end
  if love.keyboard.isDown("escape") then
    love.event.quit()
  end
  if not moving and playing then
    roundx = roundx + dt * 200
  end
  if roundx > 550 then
    moving = true
    spawnblocks()
    timer = defaulttime
    roundx = -175
  end
end

function love.keypressed(key)
  if moving then
    if key == "d" and not (playerx == 192) then
      playerx = playerx + jump
      player2x = player2x - jump
    end
    if key == "a" and not (playerx == 0) then
      playerx = playerx - jump
      player2x = player2x + jump
    end
    if key == "w" and not (constantplayery == 0) then
      constantplayery = constantplayery - 64
    end
    if key == "s" and not (constantplayery == 192) then
      constantplayery = constantplayery + 64
    end
  end
  if key == "space" and not playing then
    playing = true
    spawnblocks()
    timer = 3
    moving = true
  end
end

function spawnblocks()
  oof = 50
  redblocks = {}
  blueblocks = {}
  for i = 1, 6 do
    table.insert(redblocks, {x = math.floor(love.math.random(5, 7)), y = math.floor(love.math.random(0, 4))})
    table.insert(blueblocks, {x = math.floor(love.math.random(0, 3)), y = math.floor(love.math.random(0, 4))})
  end
end

function isdead()
  for i = 1, 6 do
    if constantplayery == redblocks[i].y * 64 then
      if (player2x == redblocks[i].x * 64) then
        playing = false
        moving = false
      end
    end
    if constantplayery == blueblocks[i].y * 64 and playerx == blueblocks[i].x * 64 then
      playing = false
      moving = false
    end
  end
  if defaulttime == 2.5 then
    playing = false
    string = "You Won!"
    oof = 100
    shakey = 10
    win = true
  elseif playing then
    defaulttime = defaulttime - 0.25
    moving = false
  end
end
