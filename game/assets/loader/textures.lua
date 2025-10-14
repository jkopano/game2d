local assets = require "assets.loader.assets"

---@alias asset.texture love.Image
local main = love.graphics.newImage("assets/main.png")

---@type table<tag, love.Image>
return {
  [assets["player"]] = main,
  [assets["knight"]] = main,
  -- [assets["base.bg.type1"]] = love.graphics.newImage("assets/base.png"),
  -- [assets["menu.main.bg"]] = love.graphics.newImage("assets/main_menu.png"),
}
