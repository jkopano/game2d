local function new(name)
  if not name then name = "instance" end

  local function _changeAllocate(old)
    return function(klass, ...)
      function klass:set(instance) return rawset(self, name, instance) end

      function klass:get() return self[name] end

      local instance = old(klass, ...)

      instance[name] = instance[name] or Vec(0, 0)

      return instance
    end
  end

  return {
    included = function(_, klass)
      klass.static.allocate = _changeAllocate(klass.static.allocate)
    end
  }
end

return new
