local assets = require "assets.loader.assets"

---@class (exact) asset.texture_atlas
---@field frames [string, number]
---@field on_loop? fun(s)
---@field duration? number|table
---@field effect? table

---@alias asset.texture_atlas.array table<tag, asset.texture_atlas>

---@type {[tag]: asset.texture_atlas.array}
local texture_atlas = {
  [assets["player"]] = {
    jump = {
      frames = { "9-12", 2 },
      duration = 0.1,
    },
    idle = {
      frames = { "9-12", 2 },
      duration = 0.2
    },
    attack = {
      frames = { "9-14", 2 },
    },
    death = {
      frames = { "15-22", 2 },
    },
  },
  [assets["knight"]] = {
    jump = {
      frames = { "1-4", 1 },
      duration = 0.1,
    },
    idle = {
      frames = { "1-4", 1 },
      duration = 0.2
    },
    attack = {
      frames = { "9-14", 1 },
    },
    death = {
      frames = { "15-22", 1 },
    },
  },
}

return texture_atlas
