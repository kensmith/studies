--[[

Copyright (c) 2009, Ken Smith kgsmith gmail
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

  • Redistributions of source code must retain the above
    copyright notice, this list of conditions and the
    following disclaimer.
  • Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the
    following disclaimer in the documentation and/or other
    materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--]]

require('is')

---Three dimensional polar (spherical) vector implementation.  1000
--meters at 20 degrees azimuth is represented as,
--vector_t(1000,20).
--1000 meters at 45
--degrees azimuth and 56 degrees zenith is, vector_t(1000, 45, 56))
vector_t = {}

setmetatable(vector_t, vector_t)

local tests = {}

function tests.__call()
   local v1 = vector_t(1000, 2)
   assert(is.a(vector_t, v1))
end
---Instantiate a vector_t.
--@param length a number
--interpreted as meters.
--@param azimuth_angle a number
--interpreted as degrees counterclockwise, starting facing east,
--increasing initially toward the north.
--@param zenith_angle a number
--interpreted as degrees counterclockwise, starting at flat and
--increasing initially toward the sky.
--@return new vector_t
function vector_t:__call(length, azimuth_angle, zenith_angle)
   local o = {
      _ = {},
      length = vector_t.length,
      azimuth_angle = vector_t.azimuth_angle,
      zenith_angle = vector_t.zenith_angle,
      east = vector_t.east,
      north = vector_t.north,
      horizontal = vector_t.horizontal,
      up= vector_t.up,
      copy = vector_t.copy,
      degrees_clockwise_from_north = vector_t.degrees_clockwise_from_north,
      rectify = vector_t.rectify,
   }

   setmetatable(o, vector_t)

   o:length(length)
   o:azimuth_angle(azimuth_angle)
   o:zenith_angle(zenith_angle or 0)

   return o
end


function tests.rectify()
   local v1 = vector_t(-50, 45, 45)
   v1:rectify()
   
end
function vector_t:rectify()
   if self:length() < 0 then
      self:length(-self:length())
      self:azimuth_angle(self:azimuth_angle() + 180)
      self:zenith_angle(self:zenith_angle() + 180)
   end

   self:azimuth_angle(self:azimuth_angle() % 360)
   self:zenith_angle(self:zenith_angle() % 360)

   return self
end


function tests.degrees_clockwise_from_north()
   local v1= vector_t(50, 45)
   assert(v1:degrees_clockwise_from_north() == 45)
   v1:degrees_clockwise_from_north(30)
   assert(v1:azimuth_angle() == 60)
end
---Set or get the azimuth angle interpreted as degrees
--clockwise from north.
function vector_t:degrees_clockwise_from_north(val)
   if val then
      -- set the azimuth angle with val intepreted as
      -- degrees clockwise from north
      self:azimuth_angle(90 - val)
      if self:azimuth_angle() < 0 then
         self:azimuth_angle(-(-self:azimuth_angle() % 360) + 360)
      end
      self:rectify()
   else
      -- return azimuth angle interpreted as degrees
      -- clockwise from north
      local retval = 90 - self:azimuth_angle()
      if retval < 0 then
         retval = -(-retval % 360) + 360
      end
      return retval % 360
   end
end


function tests.azimuth_angle()
   local v = vector_t(1000, 45)
   assert(is.zero(v:azimuth_angle() - 45))

   v:azimuth_angle(55)
   assert(is.zero(v:azimuth_angle() - 55))
end
---Return the azimuth_angle of this vector_t.  When called with an optional
--number, set the azimuth_angle of this
--vector_t.
--@return number
function vector_t:azimuth_angle(azimuth_angle)
   assert(is.a(vector_t, self),
      "vector_t:azimuth_angle: self must be a vector_t"
   )

   if azimuth_angle then
      azimuth_angle = tonumber(azimuth_angle)
      assert(type(azimuth_angle) == 'number')
      self._.azimuth_angle = azimuth_angle

      return self
   else
      local result = self._.azimuth_angle
      return result
   end
end


function tests.zenith_angle()
   local v = vector_t(1000, 12, 45)
   assert(is.zero(v:zenith_angle() - 45))

   v:zenith_angle(55)
   assert(is.zero(v:zenith_angle() - 55))
end
---Return the zenith_angle of this vector_t.  When called with an optional
--number, set the zenith_angle of this
--vector_t.
--@return number
function vector_t:zenith_angle(zenith_angle)
   assert(is.a(vector_t, self),
      "vector_t:zenith_angle: self must be a vector_t"
   )

   if zenith_angle then
      zenith_angle = tonumber(zenith_angle)
      assert(type(zenith_angle) == 'number')
      self._.zenith_angle = zenith_angle

      return self
   else
      local result = self._.zenith_angle
      return result
   end
end


function tests.length()
   local v = vector_t(1000, 45)
   assert(v:length() == 1000)

   v:length(5000)
   assert(is.zero(v:length() - 5000))
end
---Return the length of this vector_t.  When called with an optional
--number, set the length of this
--vector_t.
--@return number
function vector_t:length(length)
   assert(is.a(vector_t, self),
      "vector_t:length: self must be a vector_t"
   )

   length = tonumber(length)

   if length then
      assert(type(length) == 'number')
      self._.length = length

      return self
   else
      local result = self._.length
      return result
   end
end


function tests.__tostring()
   local v1 = vector_t(1000, 20, 35)
   assert(tostring(v1) == '1000 meters, 20 degrees azimuth, 35 degrees zenith')

   local v2 = vector_t(1000, 30)
   assert(tostring(v2) == '1000 meters, 30 degrees azimuth, 0 degrees zenith')
end
---Render a vector_t as a printable string.
function vector_t:__tostring()
   assert(is.a(vector_t, self),
      "vector_t:__tostring: self must be a vector_t"
   )

   local b = {insert = table.insert, concat = table.concat}

   b:insert(tostring(self._.length))
   b:insert(' meters, ')
   b:insert(tostring(self._.azimuth_angle))
   b:insert(' degrees azimuth, ')
   b:insert(tostring(self._.zenith_angle))
   b:insert(' degrees zenith')

   local result = b:concat()

   return result
end


function tests.horizontal()
   local v1 = vector_t(1000, 45, 60)
   local v2 = v1:horizontal()
   assert(is.zero(v2:length() - 500))

   local v3 = vector_t(1000, 270, 180)
   local v4 = v3:horizontal()
   assert(is.zero(v4:length() - 1000))

   local v5 = vector_t(-1000,0,45)
   local v6 = v5:horizontal()
   assert(is.zero(v6:length() - -1*(1000^2+1000^2)^0.5/2))
end
---Return the horizontal component of this vector.
--@return vector_t
function vector_t:horizontal()
   assert(is.a(vector_t, self),
      "vector_t:horizontal: self must be a vector_t"
   )

   local horizontal_length =
      self:length()
      * math.abs(math.cos(math.rad(self:zenith_angle())))

   local horizontal_vector =
      vector_t(horizontal_length, self:azimuth_angle())

   return horizontal_vector
end


function tests.east()
   local v = vector_t(1000, 60)
   local e = v:east()
   assert(is.zero(e:azimuth_angle()))
   assert(is.zero(e:length() - 500))
end
---Return the east pointing component of this vector_t
--@return vector_t
function vector_t:east()
   assert(is.a(vector_t, self),
      "vector_t:east: self must be a vector_t"
   )

   local east_length =
      self:horizontal():length()
      * math.cos(math.rad(self:azimuth_angle()))
   local east_vector = vector_t(east_length, 0)

   return east_vector
end


function tests.north()
   local v = vector_t(1000, 60)
   local n = v:north()
   assert(is.zero(n:azimuth_angle() - 90))
   assert(is.zero(n:length() - 1000 * math.sin(math.rad(60))))
end
---Return the north pointing component of this vector_t
--@return vector_t
function vector_t:north()
   assert(is.a(vector_t, self),
      "vector_t:north: self must be a vector_t"
   )

   local north_multiplier = math.sin(math.rad(self:azimuth_angle()))

   local north_length = self:horizontal():length() * north_multiplier

   local north_vector = vector_t(north_length, 90)

   return north_vector
end


function tests.up()
   local v = vector_t(1000, 0, 60)
   local n = v:up()
   assert(is.zero(n:zenith_angle() - 90))
   assert(is.zero(n:length() - math.sin(math.rad(60))*1000))
end
---Return the up pointing component of this vector_t
--@return vector_t
function vector_t:up()
   assert(is.a(vector_t, self),
      "vector_t:up: self must be a vector_t"
   )

   local up_length = self:length() * math.sin(math.rad(self:zenith_angle()))
   local up_vector = vector_t(up_length, 0, 90)
   return up_vector
end


function tests.__eq()
   local v1 = vector_t(435, 23)
   local v2 = vector_t(435, 23)
   assert(v1 == v2)

   assert(v1 ~= 435)

   setmetatable(v1, {})
   setmetatable(v2, {})
   assert(v1 ~= v2)

   local v4 = vector_t(435, 23, 25)
   local v5 = vector_t(435, 23, 25)
   local v6 = vector_t(435, 23, 26)
   assert(v4 ~= v1)
   assert(v4 == v5)
   assert(v4 ~= v6)
end
---Return true if two vectors are equal.
--This necessitates that the azimuth and zenith angles can be
--converted to degrees and the length to meters.
--@return boolean
function vector_t:__eq(rhs)
   if not is.a(vector_t, self) then
      return false
   end

   if not is.a(vector_t, rhs) then
      return false
   end

   local result =
      is.zero(self:length() - rhs:length())
      and
      is.zero(self:azimuth_angle() - rhs:azimuth_angle())
      and
      is.zero(self:zenith_angle() - rhs:zenith_angle())

   return result
end


function tests.copy()
   local v = vector_t(1000, 45)
   local copy = v:copy()
   assert(v == copy)

   setmetatable(v, {})
   setmetatable(copy, {})
   assert(v ~= copy)
end
---Returns a new unique vector_t such that, if local v2 = v1:copy(),
--then v1 == v2.
--@return vector_t
function vector_t:copy()
   assert(is.a(vector_t,self),
      "vector_t:copy: self must be a vector_t"
   )

   local copy = vector_t(
      self:length(),
      self:azimuth_angle(),
      self:zenith_angle()
   )

   return copy
end


function tests.__add()
   local v1 = vector_t(1000, 0)
   local v2 = vector_t(1000, 90)
   local v3 = v1 + v2
   assert(is.zero(v3:azimuth_angle() - 45))
   assert(is.zero(v3:length() - (2*1000^2)^0.5))
   local v4 = vector_t(1000, 0, 90)

   local v5 = v1 + v4
   assert(is.zero(v5:zenith_angle() - 45))
   assert(is.zero(v5:length() - (2*1000^2)^0.5))

   local v6 = v2 + v4
   assert(is.zero(v6:zenith_angle() - 45))
   assert(is.zero(v6:azimuth_angle() - 90))
   assert(is.zero(v6:length() - (2*1000^2)^0.5))
end
---Adds two vectors.
--@return vector_t
function vector_t:__add(rhs)
   if is.a(coord_t, rhs) then
      local result = rhs + self

      return result
   end

   assert(is.a(vector_t, self),
      "vector_t:__add: lhs must be a vector_t"
   )

   assert(is.a(vector_t, rhs),
      "vector_t:__add: rhs must be a vector_t"
   )

   local result_east_length =
      self:east():length()
      + rhs:east():length()

   local result_north_length =
      self:north():length()
      + rhs:north():length()

   local result_up_length =
      self:up():length()
      + rhs:up():length()

   local result_horizontal_length =
      (result_east_length^2 + result_north_length^2)^0.5

   local result_length =
      (result_up_length^2 + result_horizontal_length^2)^0.5

   local result_azimuth_angle =
      (
         math.deg(
            math.atan2(
               result_north_length,
               result_east_length
            )
         )
         + 360
      ) % 360

   local result_zenith_angle =
      (
         math.deg(
            math.atan2(
               result_up_length,
               result_horizontal_length
            )
         )
         + 360
      ) % 360

   local result = vector_t(
      result_length,
      result_azimuth_angle,
      result_zenith_angle
   )

   return result
end


function tests.__unm()
   local v1 = vector_t(1000, 30)
   local v2 = -v1
   assert(is.zero(v2:azimuth_angle() - (30+180)))

   local v3 = vector_t(1000, 291)
   local v4 = -v3
   assert(is.zero(v4:azimuth_angle() - (291+180)%360))

   local v5 = vector_t(1000, 45, 45)
   local v6 = -v5

   assert(is.zero(v6:azimuth_angle() - (45+180)))
   assert(is.zero(v6:zenith_angle() - (45+180)))
end
---Returns a new vector 180 degrees opposed to self in both the
--zenith and azimuth angles.
--@return vector_t
function vector_t:__unm()
   assert(is.a(vector_t, self),
      "vector_t:__unm: self must be a vector_t"
   )

   local new_azimuth_angle = (self:azimuth_angle() + 180) % 360

   local new_zenith_angle = (self:zenith_angle() + 180) % 360

   local result = vector_t(self:length(), new_azimuth_angle, new_zenith_angle)

   return result
end


function tests.__sub()
   local v1 = vector_t(1000, 0)
   local v2 = vector_t(1000, 90)
   local v3 = v1 - v2

   assert(is.zero(v3:azimuth_angle() - 315))
   assert(is.zero(v3:length() - (2*1000^2)^0.5))
end
---Subtracts two vectors.
--@return vector_t
function vector_t:__sub(rhs)
   assert(is.a(vector_t, self),
      "vector_t:__sub: lhs must be a vector_t"
   )

   assert(is.a(vector_t, rhs),
      "vector_t:__sub: rhs must be a vector_t"
   )

   local result = self + -rhs

   return result
end


function tests.__lt()
   local v1 = vector_t(35, 45)
   local v2 = vector_t(45, 12)
   assert(v1 < v2)
   assert(not (v1 > v2))
end
---Returns true if the magnitude of self is less than rhs
function vector_t:__lt(rhs)
   assert(is.a(vector_t, self),
      "vector_t:__sub: lhs must be a vector_t"
   )
   assert(is.a(vector_t, rhs),
      "vector_t:__sub: rhs must be a vector_t"
   )

   local result = self:length() < rhs:length()

   return result
end

function tests.__mul()
   local v = vector_t(100,60,60)
   local d = v * 2
   assert(is.a(vector_t, d))
   assert(is.zero(d:length() - 200))
   assert(is.zero(d:azimuth_angle() - 60))
   assert(is.zero(d:azimuth_angle() - 60))
end
---Multiplies a vector by a scalar
function vector_t:__mul(rhs)
   local vector,multiplier

   if is.a(vector_t,self) then
      vector = self
   elseif is.a(vector_t,rhs) then
      vector = rhs
   end

   if type(self) == 'number' then
      multiplier = self
   elseif type(rhs) == 'number' then
      multiplier = rhs
   end
   
   assert(is.a(vector_t,vector),
      "vector_t:__div: vector must be a vector_t"
   )
   assert(type(multiplier) == 'number',
      "vector_t:__div: multiplier must be a number"
   )

   local result = vector_t(
      vector:length() * multiplier,
      vector:azimuth_angle(),
      vector:zenith_angle()
   )

   return result
end

function tests.__div()
   local v = vector_t(100,60,60)
   local d = v / 2
   assert(is.a(vector_t, d))
   assert(is.zero(d:length() - 50))
   assert(is.zero(d:azimuth_angle() - 60))
   assert(is.zero(d:azimuth_angle() - 60))
end
---Divides a vector by a scalar
function vector_t:__div(rhs)
   assert(is.a(vector_t,self),
      "vector_t:__div: lhs must be a vector_t"
   )
   assert(type(rhs) == 'number',
      "vector_t:__div: rhs must be a number"
   )

   local result = vector_t(
      self:length() / rhs,
      self:azimuth_angle(),
      self:zenith_angle()
   )

   return result
end


if arg and arg[0]:match('.*vector_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('vector_t')
