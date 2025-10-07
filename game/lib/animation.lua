local anim8 = require("lib.anim8")
local class = require("lib.middleclass")

---@class (exact) anim.texture_atlas
---@field frames [string, number]
---@field on_loop? fun(s)
---@field duration? fun(): table|number

---@class (exact) drawOpts
---@field x number
---@field y number
---@field angle? number
---@field sx? number
---@field sy? number
---@field kx? number
---@field ky? number

---@class (exact) anim.table
---@field [string] anim

---@class (exact) anim.class: anim, class
---@field new fun(self, texture: love.Image, grid: asset.texture_atlas_layout, t: asset.texture_atlas[]): anim
local AnimationClass = class("Animation.Class")

function AnimationClass:init(texture, texture_atlas_layout, texture_atlas)
  assert(texture_atlas_layout, "no object")
  assert(texture, "no image")
  assert(texture_atlas, "no atlas")
  assert(texture_atlas_layout.width, "no width")
  assert(texture_atlas_layout.height, "no height")

  self.type = {}
  self.image = texture
  self.duration = texture_atlas_layout.duration
  self.state = texture_atlas_layout.state
  self.width = texture_atlas_layout.width
  self.height = texture_atlas_layout.height

  self.grid = anim8.newGrid(
    texture_atlas_layout.width,
    texture_atlas_layout.height,
    texture:getWidth(),
    texture:getHeight(),
    texture_atlas_layout.left,
    texture_atlas_layout.top,
    texture_atlas_layout.border
  )

  for name, grid in pairs(texture_atlas) do
    self.type[name] = anim8.newAnimation(
      self.grid(unpack(grid.frames)),
      grid.duration or self.duration,
      grid.on_loop
    )
  end

  return self
end

---@class anim: instance
---@field image love.Image
---@field width number width of frame
---@field height number height of frame
---@field duration table|number duration of frame
---@field state tag animation state type
---@field protected grid Grid
---@field type table<any, Animation> type of animation
local Animation = {}

--- set default animation's state
---@param s tag
---@return anim
function Animation:play(s)
  self.state = s

  return self
end

---@return anim
function Animation:flipV()
  self.type[self.state]:flipV()

  return self
end

---@return anim
function Animation:flipH()
  self.type[self.state]:flipH()

  return self
end

---@param num number
---@return self
function Animation:gotoFrame(num)
  self.type[self.state]:gotoFrame(num)

  return self
end

---@param self anim
---@return integer
function Animation:getFrame()
  return self.type[self.state].position
end

---@param self anim
---@return number, number, number, number
function Animation:getDimensions()
  return self.type[self.state]:getDimensions()
end

---@param self anim
---@param x number?
---@param y number?
---@param r number?
---@param sx number?
---@param sy number?
---@param ox number?
---@param oy number?
---@param kx number?
---@param ky number?
---@return love.Quad, number?, number?, number?, number?, number?, number?, number?, number?, number?
function Animation:getFrameInfo(x, y, r, sx, sy, ox, oy, kx, ky)
  return self.type[self.state]:getFrameInfo(x, y, r, sx, sy, ox, oy, kx, ky)
end

---@param O drawOpts
---@return nil
function Animation:draw(O)
  self.type[self.state]:draw(
    self.image,
    O.x,
    O.y,
    O.angle,
    O.sx or 1,
    O.sy or 1,
    self.height / 2,
    self.width / 2,
    O.kx,
    O.ky
  )
end

---@param dt number
function Animation:update(dt)
  self.type[self.state]:update(dt)
end

AnimationClass:include(Animation)

return AnimationClass
