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
require('vector_t')

---Three dimensional Earth coordinate implementation.  Numbers
--are assumed to be in degrees and meters.  This,
--coord_t(33.606091, -117.9050000, 15), represents a point at
--33.606091N, 117.905W, 15 meters altitude.
coord_t = {
   earth_radius =
   {
      semi_major_axis = 6378137,
      semi_minor_axis = 6378137 * (1 - 298.25722356^-1),
      average = 6372795,
   },
}


setmetatable(coord_t, coord_t)

local tests = {}

function tests.__call()
   local c = coord_t(33, -118, 0)
   assert(is.a(coord_t, c))

   local success = pcall(coord_t.__call, coord_t, 33, -118, 0, 'bogus')
   assert(not success)
end
---Instantiate a coord_t.
--@param lat degrees north of the equator.
--@param lon degrees east of greenwich meridian.
--@param alt meters of altitude from mean seal level away from Earth center.
--@param display selects the behavior of tostring(coord_t(...))
--@see coord_t:__tostring
--@return a new coord_t instance
function coord_t:__call(lat, lon, alt, display)
   lat = tonumber(lat)
   assert(type(lat) == 'number',
      "coord_t:__call: lat must be a number, type(lat) is "
      .. type(lat)
   )

   lon = tonumber(lon)
   assert(type(lon) == 'number',
      "coord_t:__call: lon must be a number, type(lon) is "
      .. type(lon)
   )

   alt = tonumber(alt) or 0
   assert(type(alt) == 'number',
      "coord_t:__call: if alt is not nil, it must be a number, "
      .. "type(alt) is "
      .. type(alt)
   )

   local o = {
      _ = {
         lat = lat,
         lon = lon,
         alt = alt,
      },
      lat = coord_t.lat,
      lon = coord_t.lon,
      alt = coord_t.alt,
      copy = coord_t.copy,
      display = coord_t.display,
      spherical_earth_radius = coord_t.spherical_earth_radius,
      cylindrical_earth_radius = coord_t.cylindrical_earth_radius,
   }

   setmetatable(o, coord_t)

   o:display(display or 'traditional')

   return o
end


function tests.lat()
   local c = coord_t(33, -118, 0)
   assert(c:lat() == 33)
   c:lat(45)
   assert(c:lat() == 45)
end
---Get or set lat.  If new_value is specified, set, otherwise, get.
--@param new_value number of degrees north of the Equator.
--@return self when setting, latitude getting.
function coord_t:lat(new_value)
   assert(is.a(coord_t, self),
      "coord_t:lat: self must be a coord_t, type(self) = "
      .. type(self)
   )

   if new_value then
      assert(type(new_value) == 'number',
         "coord_t:lat: new_value must be a number, type(new_value) = "
         .. type(new_value)
      )
      self._.lat = new_value
      return self
   else
      return self._.lat
   end
end


function tests.lon()
   local c = coord_t(33, -118, 0)
   assert(c:lon() == -118)
   c:lon(45)
   assert(c:lon() == 45)
end
---Get or set lon.  If new_value is specified, set, otherwise, get.
--@param new_value number of degrees east of Greenwich Merdian.
--@return self when setting, longitude when getting.
function coord_t:lon(new_value)
   assert(is.a(coord_t, self),
      "coord_t:lon: self must be a coord_t, type(self) = "
      .. type(self)
   )

   if new_value then
      assert(type(new_value) == 'number',
         "coord_t:lon: new_value must be a number, type(new_value) is "
         .. type(new_value)
      )
      self._.lon = new_value
      return self
   else
      return self._.lon
   end
end


function tests.alt()
   local c = coord_t(33, -118, 51)
   assert(c:alt() == 51)
   c:alt(45)
   assert(c:alt() == 45)
end
---Get or set alt.  If new_value is specified, set, otherwise, get.
--@param new_value number of meters away from Earth center.
--@return self when setting, altitude when getting.
function coord_t:alt(new_value)
   assert(is.a(coord_t, self),
      "coord_t:alt: self must be a coord_t, type(self) is "
      .. type(self)
   )

   if new_value then
      assert(type(new_value) == 'number',
         "coord_t:alt: new_value must be a number, type(new_value) is "
         .. type(new_value)
      )
      self._.alt = new_value
      return self
   else
      return self._.alt
   end
end


function tests.display()
   local c = coord_t(1,2,3)
   assert(c:display() == 'traditional')
   c:display('verbose traditional')
   assert(c:display() == 'verbose traditional')
   local success = pcall(c.display, self, 'bogus')
   assert(not success)
end
---Get or set display.  If new_value is specified, set, otherwise,
--get.
--@param new_value a string representing the new display format.
--@return self when setting, current value as a string when getting.
--@see coord_t:__tostring
function coord_t:display(new_value)
   assert(is.a(coord_t, self),
      "coord_t:display: self must be a coord_t, type(self) is "
      .. type(self)
   )
   if type(new_value) == 'string' then
      assert(
         new_value == 'traditional'
         or new_value == 'verbose traditional'
         or new_value == 'kml',
         "coord_t:display: new_value must be one of, 'traditional', "
         .. "'verbose traditional', or 'kml', is "
         .. tostring(new_value)
      )

      self._.display = new_value

      return self
   else
      return self._.display
   end
end


function tests.__tostring()
   local c_traditional = coord_t(33, -118, 51)
   assert(tostring(c_traditional) == '33, -118, 51')
   local c_verbose_traditional = coord_t(33, -118, 51, 'verbose traditional')
   assert(tostring(c_verbose_traditional)
      == '33 degrees, -118 degrees, 51 meters'
   )
   local c_kml = coord_t(33, -118, 51, 'kml')
   assert(tostring(c_kml) == '-118, 33, 51')
end
---Render a coord_t as a printable string.  The format of this
--string is dependent on the value of display passed in to the
--coord_t constructor or set via the display method.  Regardless of
--the display method, latitude is displayed in degrees north of the
--Equator, longitude is displayed in degrees east of Greenwich
--Meridian, and altitude is displayed in meters away from the center
--of the Earth with zero being subject to interpretation either as
--absolute difference from mean sea level or distance from the
--ground as defined by the current topology.
--
--When display is 'traditional', render as "lat, lon, alt".  When
--display is 'verbose traditional', render as "lat degrees, lon
--degrees, alt meters".  When display is 'kml', render as "lon, lat,
--alt".
--@return string
function coord_t:__tostring()
   assert(is.a(coord_t, self),
      "coord_t:__tostring: self must be a coord_t, type(self) is "
      .. type(self)
   )

   local b = {insert = table.insert, concat = table.concat}

   if self:display() == 'traditional' then
      b:insert(tostring(self:lat()))
      b:insert(', ')
      b:insert(tostring(self:lon()))
      b:insert(', ')
      b:insert(tostring(self:alt()))
   elseif self:display() == 'verbose traditional' then
      b:insert(tostring(self:lat()))
      b:insert(' degrees, ')
      b:insert(tostring(self:lon()))
      b:insert(' degrees, ')
      b:insert(tostring(self:alt()))
      b:insert(' meters')
   elseif self:display() == 'kml' then
      b:insert(tostring(self:lon()))
      b:insert(', ')
      b:insert(tostring(self:lat()))
      b:insert(', ')
      b:insert(tostring(self:alt()))
   else
      assert(false,
         "coord_t:__tostring: invalid value for display, "
         .. tostring(self:display())
      )
   end

   local result = b:concat()

   return result
end


function tests.__eq()
   local c1 = coord_t(33, -118, 51)
   local c2 = coord_t(33, -118, 51)
   assert(c1 == c2)
   local c3 = coord_t(34, -118, 51)
   assert(c1 ~= c3)
   local c4 = coord_t(33, -119, 51)
   assert(c1 ~= c4)
   local c5 = coord_t(33, -118, 52)
   assert(c1 ~= c5)
end
---Return true if coord_t's are equal.
--@param rhs the right hand side of the operation
--@return boolean
function coord_t:__eq(rhs)
   if not is.a(coord_t, self) then
      return false
   end

   if not is.a(coord_t, rhs) then
      return false
   end

   local result = self:lat() == rhs:lat()
   result = result and self:lon() == rhs:lon()
   result = result and self:alt() == rhs:alt()

   return result
end


function tests.copy()
   local c1 = coord_t(33, -118, 51)
   local c2 = c1:copy()
   assert(c1 == c2)
   setmetatable(c1, {})
   setmetatable(c2, {})
   assert(c1 ~= c2)
end
function coord_t:copy()
   local result = coord_t(
      self:lat(),
      self:lon(),
      self:alt(),
      self:display()
   )

   return result
end


function tests.spherical_earth_radius()
   local c = coord_t(33, -118, 0)
   assert(tostring(c:spherical_earth_radius()):match('^6371801.1.*$'))
end
---Distance from current coordinate to the center of the earth.
--@return number of meters
function coord_t:spherical_earth_radius()
   local result =
      (
         coord_t.earth_radius.semi_major_axis^2
         *
         math.cos(math.rad(self:lat()))^2

            +

         coord_t.earth_radius.semi_minor_axis^2
         *
         math.sin(math.rad(self:lat()))^2
      )^0.5

   return result
end


function tests.cylindrical_earth_radius()
   local c = coord_t(33, -118, 0)
   assert(tostring(c:cylindrical_earth_radius()):match('^5343842.0.*$'))
end
---Closest distance from current coordinate to an imaginary line
--intersecting the north and south pole.
--@return number of meters
function coord_t:cylindrical_earth_radius()
   local result =
      self:spherical_earth_radius()
      * math.cos(math.rad(self:lat()))

   return result
end


function tests.__sub()
   local c1 = coord_t(33.606091, -117.9050000, 0)
   local c2 = coord_t(33.608349, -117.920362, 0)
   -- 1445.91 meters
   local v1 = c2 - c1
   assert(tostring(v1:length()):match('^1444.7.*$'))
   assert(tostring(v1:azimuth_angle()):match('^169.9.*$'))
end
--TODO make __sub 3d instead of 2d

---Returns a vector pointing from rhs to self and whose length is the
--distance between the two coordinates.
--@param rhs the right hand side of the '-' operator.
--@return vector_t.
function coord_t:__sub(rhs)
   assert(is.a(coord_t, self),
      'coord_t:__sub: lhs must be a coord_t, type(lhs) is '
      .. type(self)
   )

   assert(is.a(coord_t, rhs),
      'coord_t:__sub: rhs must be a coord_t, type(rhs) is '
      .. type(rhs)
   )

   local north = vector_t(
      (
         math.rad(self:lat()) - math.rad(rhs:lat())
      )
      * self:spherical_earth_radius(),
      90
   )

   local east = vector_t(
      (
         math.rad(self:lon()) - math.rad(rhs:lon())
      )
      * self:cylindrical_earth_radius(),
      0
   )

   local result = north + east

   return result
end


function tests.__add()
   local c1 = coord_t(33.606091, -117.9050000, 0)
   local v1 = vector_t(1000, 90, 1)

   local c2 = c1 + v1
   local c3 = v1 + c1
   assert(c2 == c3)
   local v4 = c2 - coord_t(33.615082008585, -117.905, 17.452406437284)
   assert(v4:length() < 1)

   local v2 = vector_t(1000, 180 + 45, 1)
   local c4 = c1 + v2
   local v3 = c4 - coord_t(33.59973339686, -117.91263343752, 17.452406437284)
   assert(v3:length() < 1)
end
---Add a coord_t and a vector_t or two coord_t's.  The
--result is a coord_t displaced by the direction and
--magnitude of the vector_t or the simple sum of the
--components in the case of two coord_t's.
--@param rhs the vector_t by which to displace
--@return displaced coord_t
function coord_t:__add(rhs)
   assert(is.a(coord_t, self),
      "coord_t:__add: lhs must be a coord_t, type(lhs) is "
      .. type(self)
   )

   assert(is.a(coord_t, rhs) or is.a(vector_t, rhs),
      "coord_t:__add: rhs must be a coord_t or a vector_t, "
      .. "type(rhs) is "
      .. type(rhs)
   )

   if is.a(coord_t, rhs) then
      return coord_t(
         self:lat() + rhs:lat(),
         self:lon() + rhs:lon(),
         self:alt() + rhs:alt()
      )
   elseif is.a(vector_t, rhs) then
      local coord = self
      local vector = rhs

      local delta_lon =
         vector:east():length() * 180/math.pi
         /
         self:cylindrical_earth_radius()

      local delta_lat =
         vector:north():length() * 180/math.pi
         /
         self:spherical_earth_radius()

      local delta_alt =
         vector:up():length()

      local result = coord_t(
         coord:lat() + delta_lat,
         coord:lon() + delta_lon,
         coord:alt() + delta_alt,
         coord:display()
      )

      return result
   end

   assert(false,
      "coord_t:__add: unexpected value for rhs, type(rhs) = "
      .. type(rhs)
   )
end


function tests.__mul()
   local c1 = coord_t(34, -118, 50)
   local c2 = c1 * 2
   assert(c2:lat() == 34*2)
   assert(c2:lon() == -118*2)
   assert(c2:alt() == 50*2)
end
--- Multiply all components by some scalar.  Exists to support weighted
--averaging of two coord_t's.
function coord_t:__mul(rhs)
   assert(is.a(coord_t, self),
      "coord_t:__div: lhs must be a coord_t, type(lhs) is "
      .. type(self)
   )

   assert(type(rhs) == 'number',
      "coord_t:__div: the divisor must be a number, type(rhs) is "
      .. type(rhs)
   )

   return coord_t(
      self:lat() * rhs,
      self:lon() * rhs,
      self:alt() * rhs
   )
end


function tests.__div()
   local c1 = coord_t(34, -118, 50)
   local c2 = c1 / 2
   assert(c2:lat() == 17)
   assert(c2:lon() == -59)
   assert(c2:alt() == 25)
end
--- Divide all components by some scalar.  Exists to support
--averaging a set of coord_t's.  stats.avg can be applied to
--a list of coord_t's.
function coord_t:__div(rhs)
   assert(is.a(coord_t, self),
      "coord_t:__div: lhs must be a coord_t, type(lhs) is "
      .. type(self)
   )

   assert(type(rhs) == 'number',
      "coord_t:__div: the divisor must be a number, type(rhs) is "
      .. type(rhs)
   )

   return coord_t(
      self:lat() / rhs,
      self:lon() / rhs,
      self:alt() / rhs
   )
end



if arg and arg[0]:match('.*coord_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('coord_t')
