---@class player.position
---@field new fun(self, p: player.class, pos: Vector2): player.position
---@field emit fun(self, s:signals.player, ...)
---@field register fun(self, s:signals.player, f: fun(...))
---@field set fun(self, instance: Vector2): Vector2
---@field get fun(self): Vector2
local Position = class("Movement")
    :include(VecLike())
    :include(AutoSelfMixin)

---@param player player.class
---@param pos Vector2
function Position:init(player, pos)
  self:set(pos)

  player:register("reset_position", function(new_pos)
    self:set(new_pos)
  end)

  player:register("move", function(vec)
    self:set(self:get() + vec)
  end)
end

return Position
