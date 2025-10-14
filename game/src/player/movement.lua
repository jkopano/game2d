---@class player.movement
---@field new fun(self, player: player.class, speed: number): player.movement
---@field emit fun(self, s:signals.player, ...)
---@field register fun(self, s:signals.player, f: fun(...))
---@field set fun(self, instance: Vector2): Vector2
---@field get fun(self): Vector2
local Movement = class("Movement")
    :include(E())
    :include(VecLike())
    :include(AutoSelfMixin)

---@param player player.class
function Movement:init(player, speed)
  self.velocity = speed
  self:register("update", function(dt)
    player:emit("move", self:get() * self.velocity * dt)
  end)

  player:register("update", function(dt) self:update(dt) end)
  player:register("set_intent", function(dir) self:set(dir()) end)
end

function Movement:load() end

function Movement:update(dt)
  self:emit("update", dt)
end

return Movement
