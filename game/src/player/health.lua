---@class player.health
local Health = class("PlayerHealth")

---@param health number
function Health:init(health)
  self.max = health
  self.list = {}
end

function Health:takeDamage(amount)
  table.insert(self.list, amount)

  return self:get()
end

function Health:get()
  local health = self.max

  for _, value in ipairs(self.list) do
    health = health + value
  end

  return health
end

function Health:heal(amount)
  table.insert(self.list,
    math.min(self.max - self:get(), amount))

  return self:get()
end

function Health:increaseMax(amount)
  self.max = self.max + amount
end

function Health:decreaseMax(amount)
  self.max = self.max - amount
end

return Health
