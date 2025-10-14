local overlayStats = require("lib.overlayStats")
require "init"

local Game = require("game")
local game

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  load_assets()
  game = Game()
  -- Your game load here
  overlayStats.load() -- Should always be called last
end

function love.draw()
  -- Your game draw here
  game:draw()
  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  game:update(dt)
  -- Your game update here
  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
