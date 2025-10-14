---@alias assets.table table<tag, table>

local function init()
  local self = {}

  local A = require "assets.loader"
  self.assets = {}

  self.textures = A.textures
  self.textures_atlas = A.textures_atlas
  self.texture_atlas_layout = A.texture_atlas_layout
  self.shaders = A.shaders
  self.fonts = A.fonts
  self.bg = A.bg
  self.quads = A.quads
  self.sounds = A.sounds

  self.tags = A.assets

  return self
end

local manager = init()

---@param tag string
---@return asset.texture_atlas_layout
local function get_texture_atlas_layout(tag)
  return manager.texture_atlas_layout[manager.tags[tag]]
end

---@param tag string
---@return asset.texture_atlas.array
local function get_texture_atlas(tag)
  return manager.textures_atlas[manager.tags[tag]]
end

---@param tag string
---@return love.Image
local function get_texture(tag)
  return manager.textures[manager.tags[tag]]
end

local function get_shader(tag)
  return manager.shaders[manager.tags[tag]]
end

local function get_font(tag)
  return manager.fonts[manager.tags[tag]]
end

local function get_sound(tag)
  return manager.sounds[manager.tags[tag]]
end

---@param tag string
---@return love.Quad
local function get_quad(tag)
  return manager.quads[manager.tags[tag]]
end

_G.T = manager.tags
_G.getTextureAtlasLayout = get_texture_atlas_layout
_G.getTextureAtlas = get_texture_atlas
_G.getTexture = get_texture
_G.getShader = get_shader
_G.getFont = get_font
_G.getQuad = get_quad
_G.getSound = get_sound
