local bloom_shader = class("DyingShader")

---@param player player.class
function bloom_shader:init(player)
  self.player = player

  self.player:register(before .. "draw",
    function() self:before_draw() end)

  self.player:register(after .. "draw",
    function() self:after_draw() end)

  local shader_asset = getShader("entity.dying")
  local shader = shader_asset.shader
  local samples = shader_asset.samples
  local quality = shader_asset.quality
  local image_size = shader_asset.image_size
  local quad_size = shader_asset.quad_size
  local quad_position = shader_asset.quad_position

  self.instance = shader
  do
    self.samples = samples
    self.quality = quality
    self.image_size = image_size
    self.quad_size = quad_size
    self.quad_position = quad_position
    self.instance = shader_asset.shader
  end

  do
    self.instance:send(self.image_size, {
      self.player.Animation:getImageSize()
    })
    self.instance:send(self.samples, 4)
    self.instance:send(self.quality, 2)
    self.instance:send(self.quad_size, { 16, 16 })
  end
end

function bloom_shader:update()
  self.instance:send(self.quad_position, {
    self.player.Animation:getQuadPosition()
  })
end

function bloom_shader:before_draw()
  self:update()
  love.graphics.setShader(self.instance)
end

function bloom_shader:after_draw()
  love.graphics.setShader()
end

return bloom_shader
