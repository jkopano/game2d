local assets = require "assets.loader.assets"

--- Create animation grid
---@class (exact) asset.texture_atlas_layout
---@field width number width of frames
---@field height number height of frames
---@field state? string animation state type
---@field top? number origin coordinate top
---@field left? number origin coordinate left
---@field border? number
---@field duration number

---@type table<tag, asset.texture_atlas_layout>
local texture_atlas_layout = {
  [assets["player"]] = {
    height = 16,
    width = 16,
    duration = 0.1,
    border = 0,
  },
  [assets["knight"]] = {
    top = 236,
    left = 128,
    width = 16,
    height = 20,
    duration = 0.1,
    border = 0,
  },
}

return texture_atlas_layout
