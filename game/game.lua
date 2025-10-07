local class = require("lib.middleclass")

local Game = class("Game")

local function create_spreetsheet(iw, ih, qw, qh, sheet)
  local o = {}

  for i, v in ipairs(sheet) do
    local quad = love.graphics.newQuad(
      v.x * qw,
      v.y * qh,
      qw, qh, iw, ih
    )

    table.insert(o, i, quad)
  end

  return o
end

function Game:initialize()
  self.rec = { x = 800, y = 400, width = 100, height = 100 }
  self.dt = 0
  self.image = love.graphics.newImage("assets/main.png")
  self.quads_one = create_spreetsheet(512, 512, 16, 16, {
    { x = 8,  y = 1 },
    { x = 9,  y = 1 },
    { x = 10, y = 1 },
    { x = 11, y = 1 },
  })
  self.quads_two = create_spreetsheet(512, 512, 16, 32, {
    { x = 8,  y = 1 },
    { x = 9,  y = 1 },
    { x = 10, y = 1 },
    { x = 11, y = 1 },
  })
end

function Game:update(dt)
  self.dt = self.dt + dt
end

function Game:draw()
  love.graphics.setBackgroundColor(1, 0.5, 0.5, 1)
  -- love.graphics.push()
  -- love.graphics.setColor(0, 0, 0, 1)
  local sin_pos = math.sin(self.dt) * 100
  local sx = 5
  if math.cos(self.dt) > 0 then sx = 5 else sx = -5 end

  local quad_one = self.quads_one[math.floor(self.dt * 2) % 4 + 1]
  local _, _, w1, h1 = quad_one:getViewport()

  local quad_two = self.quads_two[math.floor(self.dt * 2) % 4 + 1]
  local _, _, w2, h2 = quad_one:getViewport()

  love.graphics.draw(
    self.image,
    quad_one,
    940 + sin_pos,
    640,
    0,
    sx,
    5,
    w1 / 2,
    h1 / 2
  )

  love.graphics.draw(
    self.image,
    quad_two,
    940,
    240 + (sin_pos / 2),
    0,
    5,
    5,
    w2 / 2,
    h2 / 2
  )
end

return Game
