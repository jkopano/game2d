---@class player.animation
---@field new fun(self, player: player.class, assetKey: string): self
local Animation = class("PlayerAnimation"):include(E()):include(AutoSelfMixin)

---@param player player.class
---@param assetKey string
function Animation:init(player, assetKey)
  -- Get all animations for this asset key (e.g., "player.*" gets all player animations)
  local atlas = getTextureAtlas(assetKey)

  self.flip = false
  self.assetKey = assetKey

  atlas.attack.on_loop = function()
    player.States:stop_attack()
  end

  atlas.death.on_loop = function(s)
    s:pauseAtEnd()
    player.States:die_clean()
  end

  -- Create animation instance with the asset key
  self.instance = require("lib.animation"):new(
    getTexture(assetKey),
    getTextureAtlasLayout(assetKey),
    atlas)

  -- Start with idle animation
  self.instance:play("idle")

  self.handle = {
    draw = player:register("draw",
      function(position, scale)
        self:draw(position, scale)
      end),

    update = player:register("update",
      function(dt) self:update(dt) end),

    move = player:register("running",
      function(dir)
        self.flip = dir.x < 0
        self.instance:play("jump")
      end),

    look = player:register("look",
      function(dir)
        self.flip = dir
      end),

    set_intent = player:register("set_intent",
      function(dir)
        local dir = dir()
        if dir == Vec.ZERO then
          self.instance:play("idle")
          return
        end
        self.flip = dir.x < 0
        self.instance:play("jump")
      end),

    dead = player:register("dead",
      function() self.instance:play("death") end),

    idle = player:register("idle",
      function() self.instance:play("idle") end),

    attack = player:register("attack",
      function()
        self.instance:play("attack")
        self.instance:gotoFrame(1)
      end),
  }
end

function Animation:update(dt)
  self.instance:update(dt)
end

---@return number, number
function Animation:getQuadSize()
  local _, _, w, h = self.instance:getDimensions()

  return w, h
end

---@return number, number
function Animation:getQuadPosition()
  local x, y = self.instance:getDimensions()

  return x, y
end

---@return number, number
function Animation:getImageSize()
  return self.instance.texture:getDimensions()
end

---@return number
function Animation:map_flip_to_value()
  if self.flip then return -1 else return 1 end
end

---@param position player.position
---@param scale player.scale
function Animation:draw(position, scale)
  local p, s = position:get(), scale:get()

  self.instance:draw({
    x = p.x,
    y = p.y,
    sx = s.x * self:map_flip_to_value(),
    sy = s.y,
  })
end

return Animation
