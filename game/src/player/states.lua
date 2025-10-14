---@class player.states
---@field stop_movement fun(...)
---@field start_movement fun(...)
---@field start_attack fun(...)
---@field stop_attack fun(...)
---@field die fun(...)
---@field die_clean fun(...)

---@param player player.class
---@return player.states
local function new(player)
  local instance = statemachine.create({
    initial = "idle",
    events = {
      { name = 'stop_movement',  from = "running",             to = "idle" },
      { name = 'start_movement', from = { "idle", "running" }, to = "running" },
      { name = 'start_attack',   from = { "idle", "running" }, to = "attack" },
      { name = 'stop_attack',    from = "attack",              to = "idle" },
      { name = 'die',            from = { '*' },               to = "dead" },
      { name = 'die_clean',      from = "dead",                to = "after_dead" }
    },
    ---@type table<string, fun(
    ---  S: table,
    ---  ev: string,
    ---  from: string,
    ---  to: string,
    ---  ...: any)>
    callbacks = {
      on_stop_movement = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
      on_start_movement = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
      on_start_attack = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
      on_stop_attack = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
      on_die = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
      on_die_clean = function(S, ev, from, to, ...)
        player:emit(to, ...)
      end,
    }
  })

  return instance
end

return new
