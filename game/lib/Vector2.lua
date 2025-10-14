local class = require("lib.middleclass")

---@class (exact) Vector2
---@overload fun(x: number|Vector2, y?: number): Vector2
---@field x number The x component of the vector.
---@field y number The y component of the vector.
---@field private _ID number The unique identifier of the vector.
---@field len fun(self: Vector2): number Returns the length of the vector.
---@field normalize fun(self: Vector2): Vector2 Returns a normalized version of the vector.
---@field dot fun(self: Vector2, b: Vector2): number Calculates the dot product with another vector.
---@field cross fun(self: Vector2, b: Vector2): number Calculates the cross product with another vector (returns a scalar for 2D).
---@field distance fun(self: Vector2, b: Vector2): number Calculates the distance to another vector.
---@field angle fun(self: Vector2, b: Vector2): number Calculates the angle in radians between this vector and another vector.
---@field reflect fun(self: Vector2, normal: Vector2): Vector2 Reflects the vector around a normal vector.
---@field lerp fun(self: Vector2, b: Vector2, t: number): Vector2 Performs linear interpolation towards another vector.
---@field reflect fun(self: Vector2, normal: Vector2): Vector2 Reflects the vector around a normal vector.
---@field rotate fun(self: Vector2, angle: number): Vector2 Rotates the vector by a specified angle (in radians).
---@field toTable fun(self: Vector2): table Converts the vector to a table format.
local Vector2 = class("util.Vector2") -- Renamed class to Vector2

function Vector2:init(...)
  local x, y = ...
  if type(x) == "number" and type(y) == "number" then
    self.x = x
    self.y = y
  elseif type(x) == "table" then
    self.x = x.x
    self.y = x.y
  elseif not y then
    self.x = x
    self.y = x
  else
    error("Invalid arguments to Vector2 constructor")
  end
end

---Calculates the length (magnitude) of the vector.
---The length is computed using the Pythagorean theorem.
---@return number dist The length of the vector, calculated as √(x² + y²).
function Vector2:len()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

---Normalizes the vector, converting it to a unit vector.
---@return Vector2 vec New vector that is the normalized version of this vector.
function Vector2:normalize()
  local length = self:len()
  if length == 0 then
    return Vector2(0, 0)
  end
  return Vector2(self.x / length, self.y / length)
end

---Calculates the dot product of this vector and another vector.
---@param b Vector2 The other vector to calculate the dot product with.
---@return number dot The dot product of the two vectors.
function Vector2:dot(b)
  if type(b) == "table" and b.x and b.y then
    return self.x * b.x + self.y * b.y
  else
    error("Invalid argument to Vector2:dot, expected a Vector2")
  end
end

---Calculates the cross product of this vector and another vector.
---For 2D vectors, this returns a scalar value representing the magnitude of the cross product.
---@param b Vector2 The other vector to calculate the cross product with.
---@return number The magnitude of the cross product (scalar).
function Vector2:cross(b)
  if type(b) == "table" and b.x and b.y then
    return self.x * b.y - self.y * b.x
  else
    error("Invalid argument to Vector2:cross, expected a Vector2")
  end
end

---Calculates the distance between this vector and another vector.
---@param b Vector2 The other vector to calculate the distance to.
---@return number dist The distance between the two vectors.
function Vector2:distance(b)
  if type(b) == "table" and b.x and b.y then
    return math.sqrt((self.x - b.x) ^ 2 + (self.y - b.y) ^ 2)
  else
    error("Invalid argument to Vector2:distance, expected a Vector2")
  end
end

---Calculates the angle between this vector and another vector in radians.
---@param b Vector2 The other vector to calculate the angle with.
---@return number angle The angle in radians between the two vectors.
function Vector2:angle(b)
  if type(b) == "table" and b.x and b.y then
    local dotProduct = self:dot(b)
    local lengths = self:len() * b:len()
    if lengths == 0 then
      return 0
    end
    return math.acos(dotProduct / lengths)
  else
    error("Invalid argument to Vector2:angle, expected a Vector2")
  end
end

---Reflects this vector around a normal vector.
---@param normal Vector2 The normal vector to reflect around.
---@return Vector2 vec new vector that is the reflection of this vector.
function Vector2:reflect(normal)
  if type(normal) == "table" and normal.x and normal.y then
    local dotProduct = self:dot(normal)
    return Vector2(
      self.x - 2 * dotProduct * normal.x,
      self.y - 2 * dotProduct * normal.y
    )
  else
    error("Invalid argument to Vector2:reflect, expected a Vector2")
  end
end

---Performs linear interpolation between this vector and another vector.
---@param b Vector2 The target vector to interpolate towards.
---@param t number A value between 0 and 1 representing the interpolation factor.
---@return Vector2 vec new vector that is the result of the linear interpolation.
function Vector2:lerp(b, t)
  if type(b) == "table" and b.x and b.y then
    return Vector2(self.x + (b.x - self.x) * t, self.y + (b.y - self.y) * t)
  else
    error("Invalid argument to Vector2:lerp, expected a Vector2")
  end
end

---Rotates the vector by a specified angle (in radians).
---@param angle number The angle in radians to rotate the vector.
---@return Vector2 vec new vector that is the result of the rotation.
function Vector2:rotate(angle)
  local cosAngle = math.cos(angle)
  local sinAngle = math.sin(angle)
  return Vector2(
    self.x * cosAngle - self.y * sinAngle,
    self.x * sinAngle + self.y * cosAngle
  )
end

---Calls the vector and returns its components.
---@return number x The x component of the vector.
---@return number y The y component of the vector.
function Vector2:__call()
  return self.x, self.y
end

function Vector2:ID()
  if self._ID == nil then
    local x, y = self.x, self.y
    self._ID = 0.5 * ((x + y) * (x + y + 1) + y)
  end
  return self._ID
end

---Multiplies this vector by a number or another vector.
---@param b number|Vector2 The number or vector to multiply with.
---@return Vector2 vec A new vector that is the result of the multiplication.
function Vector2:__mul(b)
  if type(b) == "number" then
    return Vector2(self.x * b, self.y * b)
  elseif type(self) == "number" then
    return Vector2(self * b.x, self * b.y)
  elseif type(b) == "table" and b.x and b.y then
    return Vector2(self.x * b.x, self.y * b.y)
  else
    error(
      "Invalid argument to Vector2:__mul, expected a number or a Vector2"
    )
  end
end

---Adds this vector to a number or another vector.
---@param b number|Vector2 The number or vector to add.
---@return Vector2 A new vector that is the result of the addition.
function Vector2:__add(b)
  if type(b) == "number" then
    return Vector2(self.x + b, self.y + b)
  elseif type(self) == "number" then
    return Vector2(self + b.x, self + b.y)
  elseif type(b) == "table" and b.x and b.y then
    return Vector2(self.x + b.x, self.y + b.y)
  else
    error(
      "Invalid argument to Vector2:__add, expected a number or a Vector2"
    )
  end
end

---Subtracts a number or another vector from this vector.
---@param b number|Vector2 The number or vector to subtract.
---@return Vector2 vec A new vector that is the result of the subtraction.
function Vector2:__sub(b)
  if type(b) == "number" then
    return Vector2(self.x - b, self.y - b)
  elseif type(self) == "number" then
    return Vector2(self - b.x, self - b.y)
  elseif type(b) == "table" and b.x and b.y then
    return Vector2(self.x - b.x, self.y - b.y)
  else
    error(
      "Invalid argument to Vector2:__sub, expected a number or a Vector2"
    )
  end
end

---Divides this vector by a number or another vector.
---@param b number|Vector2 The number or vector to divide by.
---@return Vector2 vec A new vector that is the result of the division.
function Vector2:__div(b)
  if type(b) == "number" then
    return Vector2(self.x / b, self.y / b)
  elseif type(self) == "number" then
    return Vector2(self / b.x, self / b.y)
  elseif type(b) == "table" and b.x and b.y then
    return Vector2(self.x / b.x, self.y / b.y)
  else
    error("Invalid argument to Vector2:__div, expected a number")
  end
end

---Checks if this vector is equal to another vector.
---@param b Vector2 The vector to compare with.
---@return boolean bool true if the vectors are equal, false otherwise.
function Vector2:__eq(b)
  if type(b) == "table" and b.x and b.y then
    return self.x == b.x and self.y == b.y
  else
    error("Invalid argument to Vector2:__eq, expected a Vector2")
  end
end

---Checks if this vector is less than another vector.
---@param b Vector2 The vector to compare with.
---@return boolean bool true if this vector is less than the other vector, false otherwise.
function Vector2:__lt(b)
  if type(b) == "table" and b.x and b.y then
    return self.x < b.x and self.y < b.y
  else
    error("Invalid argument to Vector2:__lt, expected a Vector2")
  end
end

---Checks if this vector is less than or equal to another vector.
---@param b Vector2 The vector to compare with.
---@return boolean bool true if this vector is less than or equal to the other vector, false otherwise.
function Vector2:__le(b)
  if type(b) == "table" and b.x and b.y then
    return self.x <= b.x and self.y <= b.y
  else
    error("Invalid argument to Vector2:__le, expected a Vector2")
  end
end

---Negates the vector, returning a new vector with inverted components.
---@return Vector2 vec new vector that is the negation of this vector.
function Vector2:__unm()
  return Vector2(-self.x, -self.y)
end

---Raises each component of the vector to the power of n.
---@param n number The exponent to raise each component to.
---@return Vector2 vec new vector with each component raised to the power of n.
function Vector2:__pow(n)
  return Vector2(self.x ^ n, self.y ^ n)
end

---Converts the vector to a string representation.
---@return string str string representation of the vector in the format "Vector2(x, y)".
function Vector2:__tostring()
  return string.format("Vector2(%f, %f)", self.x, self.y) -- Use %f for floating-point values
end

---Converts the vector to a table format.
---@return table tb table representation of the vector with x and y components.
function Vector2:toTable()
  return { x = self.x, y = self.y }
end

-- Vector2 = bitser.registerClass(Vector2)

local vec_mt = {
  __call = function(_, ...) return Vector2(...) end,
}

---@class (exact) Vector2.class
---@overload fun(x: number|Vector2, y?: number): Vector2
---@field private new fun(x: number|Vector2, y?: number): Vector2
---@field ZERO Vector2
---@field RIGHT Vector2
---@field LEFT Vector2
---@field UP Vector2
---@field DOWN Vector2
local vec = setmetatable({}, vec_mt)

vec.ZERO = Vector2(0, 0)
vec.LEFT = Vector2(-1, 0)
vec.RIGHT = Vector2(1, 0)
vec.UP = Vector2(0, -1)
vec.DOWN = Vector2(0, 1)

return vec
