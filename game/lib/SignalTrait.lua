local function new(name)
  name = name or "signals"

  local function _changeAllocate(old)
    return function(klass, ...)
      function klass:emit(event, ...)
        self[name]:emit(event, ...)
      end

      function klass:register(event, f)
        self[name]:register(event, f)
      end

      local instance = old(klass, ...)

      instance[name] = instance[name] or H.signal.new()

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
