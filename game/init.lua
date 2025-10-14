require "lib.fun" ()

---@class tag: integer

---@return fun(): tag
_G.tag              = (function()
  local tag_id = 0
  return function()
    tag_id = tag_id + 1
    return tag_id
  end
end)()

_G.class            = require "lib.middleclass"
_G.stateful         = require "lib.stateful"
-- _G.bitser           = require "lib.bitser"
_G.H                = {
  signal = require("lib.signal"),
  timer = require("lib.hump.timer"),
  states = require("lib.hump.gamestate"),
}

_G.S                = {
  mouse = tag(),
  resize = tag(),
}

_G.TODO             = function(err)
  err = err or ""
  error("NOT IMPLEMENTED: " .. err)
end

_G.statemachine     = require "lib.statemachine"
-- _G.rs               = require "lib.resolution"
_G.load_assets      = function()
  require("asset_manager")
end
_G.merge            = function(t1, t2)
  local result = {}
  for k, v in pairs(t1) do
    result[k] = v
  end
  for k, v in pairs(t2) do
    result[k] = v
  end
  return result
end

_G.Hex              = function(hex, value)
  return {
    tonumber(string.sub(hex, 2, 3), 16) / 256,
    tonumber(string.sub(hex, 4, 5), 16) / 256,
    tonumber(string.sub(hex, 6, 7), 16) / 256,
    value or 1 }
end

_G.hash             = function(str)
  return love.data.hash("sha512", str)
end

_G.E                = require("lib.SignalTrait")
_G.Vec              = require("lib.Vector2")
_G.VecLike          = require("lib.VecTrait")

_G.before           = "before_"
_G.after            = "after_"
_G.on               = "on_"

-- AutoSelfMixin globals
local AutoSelfMixin = require("lib.AutoSelfMixinTrait")
_G.AutoSelfMixin    = AutoSelfMixin.AutoSelfMixin
_G.with             = AutoSelfMixin.withParent
