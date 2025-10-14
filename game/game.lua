local Game = class("Game")
---@type player.class
local Player = require("src.player")

function Game:init()
  self.player1 = Player:new("player", Vec(950, 600), Vec(5, 5))
  self.player2 = Player:new("knight", Vec(950, 500), Vec(5, 5))
end

function Game:update(dt)
  self.player1:emit("update", dt)
  self.player1:emit("set_intent", function() return self:keyboard_input() end)
  self.player2:emit("update", dt)
  self.player2:emit("set_intent", function() return self:mouse_input(self.player2.Position:get()) end)
end

function Game:draw()
  love.graphics.setBackgroundColor(1, 0.5, 0.5, 1)
  self.player1:draw()
  self.player2:draw()
end

function Game:keyboard_input()
  local input = Vec(0, 0)

  if love.keyboard.isDown("up") then input.y = input.y - 1 end
  if love.keyboard.isDown("down") then input.y = input.y + 1 end
  if love.keyboard.isDown("right") then input.x = input.x + 1 end
  if love.keyboard.isDown("left") then input.x = input.x - 1 end

  return input
end

function Game:mouse_input(pos)
  local x, y = love.mouse.getPosition()
  local input = Vec(x, y)
  local diff = Vec(input - pos)
  if diff:len() < 5 then return Vec.ZERO end
  return diff:normalize()
end

return Game
