local function _changeInit(old)
  return function(klass, ...)
    local parent = _G._parent_context
    if parent then
      local instance = old(klass, parent, ...)
      return instance
    else
      local instance = old(klass, ...)
      return instance
    end
  end
end

local auto = {
  included = function(_, klass)
    klass.static.new = _changeInit(klass.static.new)
  end,
}

-- Helper function to set parent context
local function withParent(parent, fn)
  _G._parent_context = parent
  local result = fn()
  _G._parent_context = nil
  return result
end

return {
  AutoSelfMixin = auto,
  withParent = withParent,
}
