--[[
copyright (c) 2012-2013 matthias richter

permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "software"), to deal
in the software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the software, and to permit persons to whom the software is
furnished to do so, subject to the following conditions:

the above copyright notice and this permission notice shall be included in
all copies or substantial portions of the software.

except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this software without prior written authorization.

the software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. in no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the software or the use or other dealings in
the software.
]] --

---@class Signal
local registry = {}
registry.__index = function(self, key)
  return registry[key] or (function()
    local t = {}
    rawset(self, key, t)
    return t
  end)()
end

---Rejestruje funkcję dla danego zdarzenia
---@param self table
---@param s any Nazwa zdarzenia
---@param f fun(...) Funkcja do zarejestrowania
---@return function Zarejestrowana funkcja
function registry:register(s, f)
  self[s][f] = f
  return f
end

---Wywołuje wszystkie funkcje zarejestrowane dla danego zdarzenia
---@param self table
---@param s any Nazwa zdarzenia
---@param ... any Argumenty do przekazania do funkcji
function registry:emit(s, ...)
  for f in pairs(self[s]) do
    f(...)
  end
end

---Usuwa funkcje z rejestracji dla danego zdarzenia
---@param self table
---@param s any Nazwa zdarzenia
---@param ... function Funkcje do usunięcia
function registry:remove(s, ...)
  local f = { ... }
  for i = 1, #f do
    self[s][f[i]] = nil
  end
end

---Czyści rejestracje dla podanych zdarzeń
---@param self table
---@vararg any Nazwy zdarzeń do wyczyszczenia
function registry:clear(...)
  local s = { ... }
  for i = 1, #s do
    self[s[i]] = {}
  end
end

---Wywołuje zdarzenia pasujące do wzorca
---@param self table
---@param p string Wzorzec zdarzenia (string.match)
---@vararg any Argumenty do przekazania do funkcji
function registry:emitpattern(p, ...)
  for s in pairs(self) do
    if s:match(p) then self:emit(s, ...) end
  end
end

---Rejestruje funkcję dla wszystkich zdarzeń pasujących do wzorca
---@param self table
---@param p string Wzorzec zdarzenia (string.match)
---@param f fun(...) Funkcja do zarejestrowania
---@return fun(...) Zarejestrowana funkcja
function registry:registerpattern(p, f)
  for s in pairs(self) do
    if s:match(p) then self:register(s, f) end
  end
  return f
end

---Usuwa funkcje ze zdarzeń pasujących do wzorca
---@param self table
---@param p string Wzorzec zdarzenia (string.match)
---@vararg fun(...) Funkcje do usunięcia
function registry:removepattern(p, ...)
  for s in pairs(self) do
    if s:match(p) then self:remove(s, ...) end
  end
end

---Czyści rejestracje dla zdarzeń pasujących do wzorca
---@param self table
---@param p string Wzorzec zdarzenia (string.match)
function registry:clearpattern(p)
  for s in pairs(self) do
    if s:match(p) then self[s] = {} end
  end
end

-- instancing
function registry.new()
  return setmetatable({}, registry)
end

-- default instance
local default = registry.new()

-- module forwards calls to default instance
local module = {}
for k in pairs(registry) do
  if k ~= "__index" then
    module[k] = function(...) return default[k](default, ...) end
  end
end

-- Register extension for signal serialization
-- bitser.registerExtension(1, {
--   ['bitser-type'] = "table",
--   ['bitser-match'] = function(obj)
--     local mt = getmetatable(obj)
--     return mt == registry
--   end,
--   ['bitser-dump'] = function(obj)
--     local events = {}
--     for eventName in pairs(obj) do
--       if type(eventName) == "string" and eventName ~= "__index" then
--         events[#events + 1] = eventName
--       end
--     end
--     return { events = events }
--   end,
--   ['bitser-load'] = function(data)
--     local signal = registry.new()
--     if data.events then
--       for _, eventName in ipairs(data.events) do
--         signal[eventName] = {}
--       end
--     end
--     return signal
--   end
-- })

---@type Signal
local signal = setmetatable(module, { __call = registry.new })

return signal
