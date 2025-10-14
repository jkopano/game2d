local assets = require "assets.loader.assets"
local texture_atlas = require "assets.loader.texture_atlas"
local texture_atlas_layout = require "assets.loader.texture_atlas_layout"
local textures = require "assets.loader.textures"
-- local fonts = require "assets.loader.fonts"
-- local sounds = require "assets.loader.sounds"

return {
  assets = assets,
  textures_atlas = texture_atlas,
  texture_atlas_layout = texture_atlas_layout,
  textures = textures,
  -- fonts = fonts,
  -- sounds = sounds
}
