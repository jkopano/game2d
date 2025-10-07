https = nil
local overlayStats = require("lib.overlayStats")
local runtimeLoader = require("runtime.loader")

local Game = require("game")

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  https = runtimeLoader.loadHTTPS()
  -- Your game load here
  game = Game()
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
