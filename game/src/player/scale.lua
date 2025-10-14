---@class player.scale
---@field new fun(self, p: player.class, s: Vector2): self
---@field set fun(self, instance: Vector2): Vector2
---@field get fun(self): Vector2
local Scale = class("scale"):include(VecLike()):include(AutoSelfMixin)

---@param scale Vector2
function Scale:init(scale)
  self:set(scale)
end

return Scale
