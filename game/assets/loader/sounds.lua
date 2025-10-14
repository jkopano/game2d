local assets = require "assets.loader.assets"

local button_hover = love.audio.newSource("assets/sound_effects/button_hover.ogg", "static")
local button_click = love.audio.newSource("assets/sound_effects/button_click.ogg", "static")

button_hover:setVolume(0.7)
button_click:setVolume(0.9)

return {
  [assets["menu.sound.button_hover"]] = button_hover,
  [assets["menu.sound.button_click"]] = button_click,
}
