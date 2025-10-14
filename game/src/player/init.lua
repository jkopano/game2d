local Animation = require("src.player.animation")
local Health = require("src.player.health")
local Position = require("src.player.position")
local Scale = require("src.player.scale")
local Movement = require("src.player.movement")
local State = require("src.player.states")

---@class player.class
---@field new fun(self, anim_asset: string, position: Vector2, scale: Vector2?): self
---@field emit fun(self, s:signals.player, ...)
---@field register fun(self, s:signals.player, f: fun(...))
local Player = class("Player")
    :include(E())

---@alias signals.player
---|"update"
---|"before_draw"
---|"draw"
---|"after_draw"
---|"dead"
---|"attack"
---|"running"
---|"move"
---|"idle"
---|"heal"
---|"set_intent"
---|"reset_position"
---|"look"

function Player:init(anim_asset, position, scale)
  self.States = State(self)

  with(self, function()
    self.Position = Position(position or Vec(0, 0))
    self.Scale = Scale():set(scale or Vec(1, 1))
    self.Animation = Animation(anim_asset)
    self.Movement = Movement(100)
  end)
end

function Player:update(dt)
  self:emit("update", dt)
end

function Player:draw()
  self:emit(before .. "draw")
  self:emit("draw", self.Position, self.Scale)
  self:emit(after .. "draw")
end

return Player
