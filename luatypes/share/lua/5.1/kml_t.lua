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
require('xml_t')
require('coord_t')
require('vector_t')
require('color_t')
require('stack_t')

kml_t = {
   colors = {
      solid = {
         aqua = color_t(0, 1, 1, 1),
         black = color_t(0, 0, 0, 1),
         blue = color_t(0, 0, 1, 1),
         fuchsia = color_t(1, 0, 1, 1),
         gold = color_t(1, 0.84, 0, 1),
         green = color_t(0, 0.5, 0, 1),
         lime = color_t(0, 1, 0, 1),
         maroon = color_t(0.5, 0, 0, 1),
         navy = color_t(0, 0, 0.5, 1),
         olive = color_t(0.5, 0.5, 0, 1),
         purple = color_t(0.5, 0, 0.5, 1),
         red = color_t(1, 0, 0, 1),
         silver = color_t(0.75, 0.75, 0.75, 1),
         teal = color_t(0, 0.5, 0.5, 1),
         white = color_t(1, 1, 1, 1),
         yellow = color_t(1, 1, 0, 1),
         orange = color_t(1, 0.5, 0.25, 1),
         indigo = color_t(0.18, 0.03, 0.33, 1),
         violet = color_t(0.56, 0.35, 0.60, 1),
      },
      transparent = {
         aqua = color_t(0, 1, 1, 0.5),
         black = color_t(0, 0, 0, 0.5),
         blue = color_t(0, 0, 1, 0.5),
         fuchsia = color_t(1, 0, 1, 0.5),
         gold = color_t(1, 0.84, 0, 0.5),
         green = color_t(0, 0.5, 0, 0.5),
         lime = color_t(0, 1, 0, 0.5),
         maroon = color_t(0.5, 0, 0, 0.5),
         navy = color_t(0, 0, 0.5, 0.5),
         olive = color_t(0.5, 0.5, 0, 0.5),
         purple = color_t(0.5, 0, 0.5, 0.5),
         red = color_t(1, 0, 0, 0.5),
         silver = color_t(0.75, 0.75, 0.75, 0.5),
         teal = color_t(0, 0.5, 0.5, 0.5),
         white = color_t(1, 1, 1, 0.5),
         yellow = color_t(1, 1, 0, 0.5),
         orange = color_t(1, 0.5, 0.25, 0.5),
         indigo = color_t(0.18, 0.03, 0.33, 0.5),
         violet = color_t(0.56, 0.35, 0.60, 0.5),
      },
   },
   icons = {
      alpha_numeric = {
         'http://maps.google.com/mapfiles/kml/pal3/icon8.png', -- 1
         'http://maps.google.com/mapfiles/kml/pal3/icon9.png', -- 2
         'http://maps.google.com/mapfiles/kml/pal3/icon10.png', -- 3
         'http://maps.google.com/mapfiles/kml/pal3/icon11.png', -- 4

         'http://maps.google.com/mapfiles/kml/pal3/icon12.png', -- 5
         'http://maps.google.com/mapfiles/kml/pal3/icon13.png', -- 6
         'http://maps.google.com/mapfiles/kml/pal3/icon14.png', -- 7
         'http://maps.google.com/mapfiles/kml/pal3/icon15.png', -- 8

         'http://maps.google.com/mapfiles/kml/pal3/icon16.png', -- 9
         'http://maps.google.com/mapfiles/kml/pal5/icon56.png', -- A
         'http://maps.google.com/mapfiles/kml/pal5/icon57.png', -- B
         'http://maps.google.com/mapfiles/kml/pal5/icon58.png', -- C

         'http://maps.google.com/mapfiles/kml/pal5/icon59.png', -- D
         'http://maps.google.com/mapfiles/kml/pal5/icon60.png', -- E
         'http://maps.google.com/mapfiles/kml/pal5/icon61.png', -- F
         'http://maps.google.com/mapfiles/kml/pal5/icon62.png', -- G

         'http://maps.google.com/mapfiles/kml/pal5/icon63.png', -- H
      },
      house = 'http://maps.google.com/mapfiles/kml/pal3/icon56.png',
      crosshairs = 'http://maps.google.com/mapfiles/kml/pal3/icon52.png',
      down_arrow = 'http://maps.google.com/mapfiles/kml/pal4/icon28.png',
   },
}

setmetatable(kml_t, kml_t)

local tests = {}

function tests.__call()
end
---Instantiate a kml_t.  Eg. kml = kml_t()
function kml_t:__call()
   local o = {
      _ = {
         points = {insert = table.insert},
         paths = {insert = table.insert},
         polygons = {insert = table.insert},
      },
      coverage_arc = kml_t.coverage_arc,
      frustum = kml_t.frustum,
      point = kml_t.point,
      point_open_folder = kml_t.point_open_folder,
      point_close_folder = kml_t.point_close_folder,
      path = kml_t.path,
      path_open_folder = kml_t.path_open_folder,
      path_close_folder = kml_t.path_close_folder,
      polygon = kml_t.polygon,
      polygon_open_folder = kml_t.polygon_open_folder,
      polygon_close_folder = kml_t.polygon_close_folder,
      plot_polar = kml_t.plot_polar,
      plot_cylindrical = kml_t.plot_cylindrical,
   }

   setmetatable(o, kml_t)

   return o
end


function tests.point()
   local kml = kml_t()
   local success = pcall(kml.point)
   assert(not success)
   kml:point{
      coord = coord_t(33.606091, -117.905),
      name = 'tests.point',
      icon = kml_t.icons.down_arrow,
      color = kml_t.colors.solid.green,
   }
   local f = io.open('tests.point.kml','w')
   f:write(tostring(kml))
   f:close()
end
---Draw a placemark on a KML object.
--@param attr a table containing keys describing the point.
--Keys are: coord, a coord_t describing the location; name,
--the name of the placemark; color, a color_t describing the
--color of the placemark; icon, an icon URL from kml.icons;
--extras, a table containing raw KML key/value pairs to add
--to the placemark.
function kml_t:point(attr)
   assert(type(attr) == 'table',
      "kml_t:point: attr must be a table"
   )

   assert(attr.coord and is.a(coord_t, attr.coord),
      "kml_t:point: attr must contain a field coord containing a coord_t, "
      .. "is " .. type(attr.coord)
   )

   local point = {
      coord = attr.coord:copy(),
      name = attr.name,
      color = attr.color,
      icon = attr.icon,
      extras = {},
   }

   point.coord:display('kml')
   point.coord = tostring(point.coord)

   local altitudeModeSet = false

   for k,v in pairs(attr.extras or {}) do
      if k == 'altitudeMode' then
         altitudeModeSet = true
      end
      point.extras[k] = v
   end

   if not altitudeModeSet then
      point.extras.altitudeMode = 'relativeToGround'
   end

   self._.points:insert(point)

   return self
end


function tests.path()
   local c = coord_t(33.606091, -117.905)
   local path = {insert = table.insert}
   path:insert(c:copy())

   c = c + vector_t(100, 45)
   path:insert(c:copy())

   c = c + vector_t(100, 0)
   path:insert(c:copy())

   c = c + vector_t(100, -45)
   path:insert(c:copy())

   c = c + vector_t(100, -90)
   path:insert(c:copy())

   c = c + vector_t(100, -135)
   path:insert(c:copy())

   c = c + vector_t(100, -180)
   path:insert(c:copy())

   c = c + vector_t(100, 135)
   path:insert(c:copy())

   c = c + vector_t(100, 90)
   path:insert(c:copy())

   local kml = kml_t()
   kml:path{coords = path}
   local f = io.open('tests.path.kml','w')
   f:write(tostring(kml))
   f:close()
end
---Draw a path on a KML object.
--@param attr a table describing the path.  Keys are:
--coords, a list of coord_t that describes the path; name,
--the name of the path; color, a color_t describing the
--color to draw the path; width, a numerical width to adjust
--the thickness of the line; extras, a table containing raw
--KML key/value pairs to add to the path.
function kml_t:path(attr)
   assert(type(attr) == 'table',
      "kml_t:path: attr must be a table"
   )

   assert(type(attr.coords) == 'table' and is.a(coord_t, attr.coords[1]),
      "kml_t:path: attr must contain a field coords containing a list of "
      .. "coord_t"
   )

   local path = {
      coords = {insert = table.insert, concat = table.concat},
      name = attr.name,
      color = attr.color,
      width = attr.width,
      tessellate = attr.tessellate,
      extrude = attr.extrude,
      extras = {},
   }

   if type(path.tessellate) == 'nil' then
      path.tessellate = true
   end

   for i,coord in ipairs(attr.coords) do
      assert(is.a(coord_t, coord),
         "kml_t:path: element at position, "
         .. tostring(i)
         .. ", in attr.coords is not a coord_t, is "
         .. type(coord)
      )
      local c = coord:copy()

      c:display('kml')

      path.coords:insert(tostring(c))
   end

   local altitudeModeSet = false

   for k,v in pairs(attr.extras or {}) do
      if k == 'altitudeMode' then
         altitudeModeSet = true
      end
      path.extras[k] = v
   end

   if not altitudeModeSet then
      path.extras.altitudeMode = 'relativeToGround'
   end

   self._.paths:insert(path)

   return self
end


function tests.polygon()
   local c = coord_t(33.606091, -117.905, 0)
   local octagon = {insert = table.insert}
   octagon:insert(c:copy())

   c = c + vector_t(100, 45)
   octagon:insert(c:copy())

   c = c + vector_t(100, 0)
   octagon:insert(c:copy())

   c = c + vector_t(100, -45)
   octagon:insert(c:copy())

   c = c + vector_t(100, -90)
   octagon:insert(c:copy())

   c = c + vector_t(100, -135)
   octagon:insert(c:copy())

   c = c + vector_t(100, -180)
   octagon:insert(c:copy())

   c = c + vector_t(100, 135)
   octagon:insert(c:copy())

   c = c + vector_t(100, 90)
   octagon:insert(c:copy())

   c = coord_t(33.606091, -117.905, 0)
   c = c + vector_t((100^2/2)^0.5, 0)
   local square = {insert = table.insert}
   square:insert(c:copy())

   c = c + vector_t(100, 0)
   square:insert(c:copy())

   c = c + vector_t(100,-90)
   square:insert(c:copy())

   c = c + vector_t(100, 180)
   square:insert(c:copy())

   c = c + vector_t(100, 90)
   square:insert(c:copy())

   local kml = kml_t()
   kml:polygon{
      coords = octagon,
      cutout_coords = square,
      tessellate = true,
      color = kml_t.colors.solid.green,
      linewidth = 2.5,
      linecolor = kml_t.colors.solid.gold,
   }
   local f = io.open('tests.polygon.kml','w')
   f:write(tostring(kml))
   f:close()
end
---Draw a polygon on a KML object.
--@param attr a table describing the polygon.  Keys are:
--coords, a series of points (path) that desribes the outer
--perimeter of the polygon; cutout_coords, a series of
--points describing an inner polygon (hole); name, the name
--of the polygon; color, the fill color of the polygon;
--tessellate, a boolean indicating whether to map the polygon
--to the surface curvature; extrude, a boolean indicating
--whether to connect the rim of the polygon to the earth
--with perpendicular walls; linewidth, a number describing
--the thickness of the line used to draw the polygon;
--linecolor, color of the line used to draw the polygon.
function kml_t:polygon(attr)
   assert(type(attr) == 'table',
      "kml_t:polygon: attr must be a table"
   )

   assert(type(attr.coords) == 'table' and is.a(coord_t, attr.coords[1]),
      "kml_t:polygon: attr must contain a field coords containing a list of "
      .. "coord_t"
   )

   assert(not attr.cutout_coords or type(attr.cutout_coords) == 'table',
      "kml_t:polygon: if attr contains a field cutout_coords, "
      .. "it must be a list of coord_t."
   )

   if attr.cutout_coords then
      assert(not attr.cutout_coords[1]
         or is.a(coord_t, attr.cutout_coords[1]),
         "kml_t:polygon: if attr contains a field cutout_coords, "
         .. "it must be a list of coord_t."
      )
   end

   assert(not attr.tessellate or type(attr.tessellate) == 'boolean',
      "kml_t:polygon: if attr contains attr.tessellate, it must be a boolean"
   )

   assert(not attr.extrude or type(attr.extrude) == 'boolean',
      "kml_t:polygon: if attr contains attr.extrude, it must be a boolean"
   )

   assert(not attr.linewidth or type(attr.linewidth) == 'number',
      "kml_t:polygon: if attr contains attr.linewidth, it must be a number"
   )

   assert(not attr.linecolor or is.a(color_t, attr.linecolor),
      "kml_t:polygon: if attr contains attr.linecolor, it must be a color_t"
   )

   local polygon = {
      coords = {insert = table.insert, concat = table.concat},
      cutout_coords = {insert = table.insert, concat = table.concat},
      name = attr.name,
      color = attr.color,
      linewidth = attr.linewidth,
      linecolor = attr.linecolor,
      tessellate = attr.tessellate,
      extrude = attr.extrude,
      extras = {},
   }

   local border_has_altitude = false
   for i,coord in ipairs(attr.coords) do
      assert(is.a(coord_t, coord),
         "kml_t:polygon: element at position, "
         .. tostring(i)
         .. ", in attr.coords is not a coord_t, is "
         .. type(coord)
      )
      local c = coord:copy()

      c:display('kml')

      if not is.zero(c:alt()) then
         border_has_altitude = true
      end

      polygon.coords:insert(tostring(c))
   end

   local cutout_has_altitude = false
   for i,coord in ipairs(attr.cutout_coords or {}) do
      assert(is.a(coord_t, coord),
         "kml_t:polygon: element at position, "
         .. tostring(i)
         .. ", in attr.cutout_coords is not a coord_t, is "
         .. type(coord)
      )
      local c = coord:copy()

      c:display('kml')

      if not is.zero(c:alt()) then
         cutout_has_altitude = true
      end

      polygon.cutout_coords:insert(tostring(c))
   end

   assert(not polygon.tessellate or
      (not border_has_altitude and not cutout_has_altitude),
      "kml_t:polygon: tessellation is meaningless for a polygon with "
      .. "non-zero altitude"
   )

   local altitudeModeSet = false

   for k,v in pairs(attr.extras or {}) do
      if k == 'altitudeMode' then
         altitudeModeSet = true
      end
      polygon.extras[k] = v
   end

   if not altitudeModeSet then
      polygon.extras.altitudeMode = 'relativeToGround'
   end

   self._.polygons:insert(polygon)

   return self
end


function kml_t:path_open_folder(name)
   self._.paths:insert{action = 'open_folder', name = tostring(name)}
end

function kml_t:path_close_folder()
   self._.paths:insert{action = 'close_folder'}
end
function kml_t:point_open_folder(name)
   self._.points:insert{action = 'open_folder', name = tostring(name)}
end

function kml_t:point_close_folder()
   self._.points:insert{action = 'close_folder'}
end
function kml_t:polygon_open_folder(name)
   self._.polygons:insert{action = 'open_folder', name = tostring(name)}
end

function kml_t:polygon_close_folder()
   self._.polygons:insert{action = 'close_folder'}
end


function tests.plot_polar()
   local kml = kml_t()
   local c = coord_t(33.606091, -117.905, 0)
   kml:plot_polar{
      origin = c,
      f = function(theta)
         return
            vector_t(
               100 + theta,
               theta
            )
      end,
      theta_generator = function()
         local theta = 0
         return function()
            if theta == 720 then
               return nil
            else
               theta = theta + 1
               return theta
            end
         end
      end,
      name = 'spiral',
   }
   local f = io.open('tests.plot_polar.kml','w')
   f:write(tostring(kml))
   f:close()
end
---Plot a polar function.
--@param attr a table describing the polar function.  Keys
--are: origin, a coord_t describing the center of the plot;
--f a Lua function that takes a single number (theta) and
--returns a vector pointing from the origin to the point at
--that theta; theta_generator, an iterator function that
--returns consecutive values of theta when called,
--eventually returning nil to indicate completion; name, the
--name of the function; color, a color_t describing the
--color for the plot; width, a number describing the width
--of the line for the plot
function kml_t:plot_polar(attr)
   local origin = attr.origin
   local f = attr.f
   local theta_generator = attr.theta_generator
   local name = attr.name
   local path = {insert = table.insert}

   for theta in theta_generator() do
      local vector = f(theta)
      assert(is.a(vector_t, vector),
         "kml_t:plot_polar: expected vector_t from user supplied function, "
         .. "received a "
         .. type(vector)
      )
      path:insert(origin + vector)
   end

   self:path{
      coords = path,
      name = name,
      color = attr.color or kml_t.colors.solid.gold,
      width = attr.width or 2.5,
   }
end


function tests.plot_cylindrical()
   local kml = kml_t()
   local c = coord_t(33.606091, -117.905, 0)
   kml:plot_cylindrical{
      origin = c,
      f = function(theta)
         return
            vector_t(
               10 + theta,
               theta
            )
      end,
      theta_z_generator = function()
         local theta = 0
         local z = 0
         return function()
            if theta >= 10000 then
               return nil
            else
               theta = theta + 3
               z = z + 100
               return theta, z
            end
         end
      end,
      name = 'vortex',
   }
   local f = io.open('tests.plot_cylindrical.kml','w')
   f:write(tostring(kml))
   f:close()
end
---Plots a function using cylindrical coordinates.
--@param attr a table describing the function.  Keys are:
--origin, a coord_t describing the origin of the plot; name,
--the name of the plot; color, the color of the plot; f, a
--Lua function which takes a single parameter (theta) and
--returns a horizontal vector pointing to the polar solution
--for that theta; theta_z_generator, a Lua iterator function
--that returns conscutive values for theta and z until it
--returns nil indicating completion of the plot; width, a
--number describing the width of the line used to draw the
--plot
function kml_t:plot_cylindrical(attr)
   local origin = attr.origin:copy()
   local f = attr.f
   local theta_z_generator = attr.theta_z_generator
   local name = attr.name
   local path = {insert = table.insert}

   for theta,z in theta_z_generator() do
      local vector = f(theta)
      assert(is.a(vector_t, vector),
         "kml_t:plot_cylindrical: expected vector_ from user supplied function, "
         .. "received a "
         .. type(vector)
      )
      origin = origin + vector_t(z, 0, 90)
      path:insert(origin + vector)
   end

   self:path{
      coords = path,
      name = name,
      color = attr.color or kml_t.colors.solid.gold,
      width = 2.5,
   }
end

function tests.frustum()
   local kml = kml_t()

   local point = coord_t(40.839917, -73.98077, 0)

   kml:point{
      coord = point,
      name = 'center',
   }

   --pie segment
   kml:frustum{
      name = 'pie segment',
      center = point,
      bottom_radius = 0,
      top_radius = 1046.3366728907,
      rise = 0,
      clockwise_start_angle = 61.5,
      clockwise_sweep = 81,
      tessellate = true,
   }

   --circle
   kml:frustum{
      name = 'circle',
      center = point + vector_t(5000, 270),
      top_radius = 2000,
      tessellate = true,
      linewidth = 2,
      linecolor = kml_t.colors.solid.gold,
   }

   --annulus
   kml:frustum{
      name = 'annulus',
      center = point + vector_t(5000,360-45),
      top_radius = 3000,
      bottom_radius = 2500,
      tessellate = true,
      color = kml_t.colors.transparent.gold,
      linewidth = 2,
      linecolor = kml_t.colors.solid.gold,
   }

   --frustum
   kml:frustum{
      name = 'frustum',
      center = point + vector_t(5000, 360-90-45),
      top_radius = 200,
      bottom_radius = 1000,
      rise = 800,
      color = kml_t.colors.transparent.gold,
      tessellate = false,
      angle_increment = 30,
   }

   --pyramid
   kml:frustum{
      name = 'pyramid',
      center = point + vector_t(5000, 180),
      top_radius = 0,
      bottom_radius = 300,
      rise = 150,
      angle_increment = 90,
      clockwise_start_angle = 45,
      clockwise_stop_angle = 360-45,
   }

   --pac man
   kml:frustum{
      name = 'pac man',
      center = point + vector_t(5000, 90+45),
      top_radius = 1000,
      bottom_radius = 0,
      clockwise_start_angle = 90+25,
      clockwise_sweep = 360-50,
      tessellate = true,
   }

   --hourglass
   kml:frustum{
      name = 'hourglass',
      center = point + vector_t(5000, 90),
      top_radius = 1000,
      bottom_radius = -1000,
      rise = 2000,
   }

   --cylinder
   kml:frustum{
      name = 'cylinder',
      center = point + vector_t(5000, 45),
      top_radius = 1000,
      bottom_radius = 1000,
      rise = 2000,
   }

   --overlapping pie segments
   kml:frustum{
      name = 'yorba kramer from long beach bsa (fine)',
      center = point + vector_t(5000, 0),
      top_radius = 1718,
      bottom_radius = 0,
      clockwise_start_angle = 110+91/2,
      clockwise_sweep = 91,
      tessellate = true,
   }
   kml:frustum{
      name = 'yorba kramer from long beach bsa (coarse)',
      center = point + vector_t(5000, 0),
      top_radius = 1718,
      bottom_radius = 0,
      clockwise_start_angle = 110+91/2,
      clockwise_sweep = 91,
      angle_increment = 20,
      tessellate = true,
   }

   local f = io.open('tests.frustum.kml','w')
   f:write(tostring(kml))
   f:close()
end
---handles drawing
--    frusta, semifrusta,
--    cones, semicones,
--    pyramids,
--    cylinders, semicylinders,
--    disks, semidisks,
--    annuli, semiannuli,
--    circles, semicircles,
--    triangles
--@param attr a table describing the frustum.  Keys are:
--    name, 'Display name';
--    color, color_t describing the fill color;
--    linecolor, color_t describing the line color;
--    linewidth, number describing the line width;
--    center, coord_t;
--    bottom_radius, lower/inner radius of the shape in meters;
--    top_radius = upper/outer radius of the shape in meters;
--    rise = height of the shape in meters;
--    rise_increment = number of meters for each vertical
--       segment;
--    clockwise_start_angle = degrees clockwise from N;
--    clockwise_sweep = degrees about the axis for which
--       the shape is visible
--    angle_increment = degrees,
--    tessellate = boolean, follow the terrain? In other words
--       the polygon will have an implicit great circle
--       curvature.  Enable this for large low altitude shapes
--       when they appear dirty.
function kml_t:frustum(attr)
   assert(
      is.a(kml_t, self),
      'kml_t:frustum: must be called as a method on an instance'
   )
   assert(
      type(attr) == 'table',
      'kml_t:frustum: attr must be a table'
   )

   local name = attr.name
      or 'Anonymous Frustum'
   local color = attr.color
      or kml_t.colors.transparent.gold
   local center = attr.center
      or error('kml_t:frustum: missing attr.center')
   local bottom_radius =
      attr.bottom_radius or attr.top_radius
   local top_radius =
      attr.top_radius or attr.bottom_radius
   assert(
      bottom_radius and top_radius,
      'kml_t:frustum: must define either '
      .. 'attr.bottom_radius '
      .. ' or attr.top_radius'
   )
   local rise = attr.rise or 0
   local rise_increment = attr.rise_increment
      or 100

   -- rise and rise_increment are constrained to the same direction
   if rise < 0 then
      top_radius,bottom_radius = bottom_radius,top_radius
      rise = -rise
   end
   rise_increment = math.abs(rise_increment)

   if rise ~= 0 then
      assert(
         rise_increment ~= 0,
         'kml_t:frustum: rise_increment must be nonzero when '
         .. 'rise is nonzero'
      )
   end

   local clockwise_start_angle = (attr.clockwise_start_angle
      or 0) % 360
   local clockwise_sweep = attr.clockwise_sweep
      or 360
   local angle_increment = attr.angle_increment
      or 1

   -- ensure clockwise sweep
   if clockwise_sweep < 0 then
      clockwise_start_angle =
         clockwise_start_angle + clockwise_sweep
      clockwise_sweep = math.abs(clockwise_sweep)
      angle_increment = math.abs(angle_increment)
   end

   assert(
      not is.zero(math.abs(angle_increment)),
      'kml_t:frustum: angle_increment must be nonzero'
   )

   local tessellate = attr.tessellate

   local bottom_center = center:copy()
   local top_center = center:copy()

   -- half aperture is the angle of inclination of the edge of the
   -- frustum with respect to the vertex
   local half_aperture =
      math.atan2(rise, top_radius - bottom_radius)

   local current_bottom_radius = bottom_radius
   local current_top_radius = bottom_radius
   repeat
      local polygon = {
         name = name,
         color = color,
         cutout_coords = {
            insert = table.insert,
            concat = table.concat
         },
         coords = {
            insert = table.insert,
            concat = table.concat
         },
         tessellate = tessellate,
         linewidth = attr.linewidth,
         linecolor = attr.linecolor,
      }

      local remaining_rise =
         rise - (top_center:alt() - center:alt())
      local current_rise = math.min(remaining_rise, rise_increment)
      local current_top_radius =
         current_rise / math.tan(half_aperture)
         + current_bottom_radius
      if current_top_radius ~= current_top_radius then
         -- nan, math.tan was 0
         -- this is always the case when we are drawing circles
         current_top_radius = top_radius
      end
      top_center:alt(top_center:alt() + current_rise)

      -- Drawing is performed counterclockwise since, it seems,
      -- that Google earth renders colors differently depending
      -- on which side of the polygon is shown.  When rendering
      -- clockwise, it's like we get the dark underside of the
      -- polygon and colors are all very dark.  Drawing is also
      -- performed relative to east rather than from north since
      -- this is a more natural interpretation of angle.
      local counterclockwise_start_angle =
         (90-(clockwise_start_angle + clockwise_sweep)+360)%360
      local counterclockwise_sweep = clockwise_sweep

      local start = true
      local start_point
      function draw(d)
         local d_angle = d % 360
         local new_cutout_coords_point = 
            bottom_center
            + vector_t(current_bottom_radius, d_angle)
         new_cutout_coords_point:display('kml')
         local new_coords_point = 
            top_center
            + vector_t(current_top_radius, d_angle)
         new_coords_point:display('kml')
         if start then
            start = false
            if clockwise_sweep < 360 then
               -- insert the "pacman dent" to connect the
               -- inner to the outer polygons
               polygon.coords:insert(tostring(new_cutout_coords_point))
               start_point = new_cutout_coords_point
            end
         end
         polygon.cutout_coords:insert(tostring(new_cutout_coords_point))
         polygon.coords:insert(tostring(new_coords_point))
      end
      local sweep_left = counterclockwise_sweep
      local last_d = 0
      for
         d = counterclockwise_start_angle,
         counterclockwise_start_angle + counterclockwise_sweep,
         angle_increment
      do
         sweep_left = sweep_left - angle_increment
         last_d = d
         draw(d)
      end

      sweep_left = sweep_left + angle_increment

      if sweep_left > 0 then
         local d = last_d + sweep_left
         draw(d)
      end

      if start_point then
         -- reverse cutout_coords path so the polygon draws in one
         -- continuous loop
         -- adding the cutout_coords loop to the coords loop causes
         -- this polygon to be treated as a convex polygon
         -- by google and rendering is better
         polygon.cutout_coords = stack_t(polygon.cutout_coords):pop(#polygon.cutout_coords)
         polygon.coords = stack_t(polygon.coords)
         polygon.coords:join(polygon.cutout_coords)
         polygon.cutout_coords = {}

         -- finish the arc
         --polygon.coords:insert(start_point)
      end


      self._.polygons:insert(polygon)

      current_bottom_radius = current_top_radius
      bottom_center:alt(top_center:alt())
   until top_center:alt() - center:alt() >= rise
end


function tests.coverage_arc()
   local kml = kml_t()
   kml:coverage_arc{
      name = 'test',
      coord = coord_t(41.00853, -73.9723, 28),
      orientation = 102,
      opening = 103,
      radius = 2248.1458450356,
      color = kml_t.colors.transparent.black,
   }

   io.open('tests.coverage_arc.kml','w'):write(tostring(kml))
end
function kml_t:coverage_arc(attr)
   local name = attr.name or 'arc'
   local coord = assert(attr.coord,
      'kml_t:coverage_arc: expected attr.coord'
   )
   local orientation = assert(attr.orientation,
      'kml_t:coverage_arc: expected attr.orientation'
   )
   local opening = assert(attr.opening,
      'kml_t:coverage_arc: expected attr.opening'
   )
   local radius = assert(attr.radius,
      'kml_t:coverage_arc: expected attr.radius'
   )
   local color = attr.color

   local sweep_segments = attr.sweep_segments
      or math.floor(opening / 13)
   -- sweep_segments is the number of straight lines used to
   -- approximate the curve of the arc => sweep_segments.  Larger
   -- numbers make smoother curves at the cost of larger files and
   -- longer load times

   local start_angle = orientation - opening/2
   local sweep = opening
   local center = coord:copy()
   center:alt(0)
   self:frustum{
      name =
         tostring(name)
         .. ', orientation = '
         .. tostring(orientation)
         .. ', opening = '
         .. tostring(opening)
         .. ', r = '
         .. tostring(math.floor(radius))
      ,
      center = center,
      bottom_radius = 0,
      top_radius = radius,
      rise = 0,
      clockwise_start_angle = start_angle,
      clockwise_sweep = sweep,
      angle_increment = opening / sweep_segments,
      tessellate = true,
      color = color,
   }
end


function tests.__tostring()
end
---Render the KML object to a string.  This string may be
--very large depending on the number and detail of the
--objects in your KML document.
function kml_t:__tostring()
   local kml = xml_t('kml', {xmlns = 'http://earth.google.com/kml/2.2'})
   local doc = kml('Document')
   doc('visibility', 1)
   doc('open', 1)

   -- Plot points
   local points_folder_stack = stack_t()
   local points_folder = doc('Folder')
   points_folder('name', 'points')
   for _,p in ipairs(self._.points) do
      if p.action then
         if p.action == 'open_folder' then
            points_folder_stack:push(points_folder)
            points_folder = points_folder('Folder')
            points_folder('name', p.name)
         elseif p.action == 'close_folder' then
            if #points_folder_stack > 0 then
               points_folder = points_folder_stack:pop()
            end
         end
      else
         local placemark = points_folder('Placemark')
         if p.name then
            placemark('name', tostring(p.name))
         end
         if p.color or p.icon then
            local style = placemark('Style')
            if p.color then
               local iconstyle = style('IconStyle')
               iconstyle('color', tostring(p.color))
            end
            if p.icon then
               local icon = style('Icon')
               icon('href', tostring(p.icon))
            end
         end
         local point = placemark('Point')
         for k,v in pairs(p.extras) do
            point(k, v)
         end
         point('coordinates', tostring(p.coord))
      end
   end

   -- Plot paths
   local paths_folder_stack = stack_t()
   local paths_folder = doc('Folder')
   paths_folder('name', 'paths')
   for _,p in ipairs(self._.paths) do
      if p.action then
         if p.action == 'open_folder' then
            paths_folder_stack:push(paths_folder)
            paths_folder = paths_folder('Folder')
            paths_folder('name', p.name)
         elseif p.action == 'close_folder' then
            if #paths_folder_stack > 0 then
               paths_folder = paths_folder_stack:pop()
            end
         end
      else
         local placemark = paths_folder('Placemark')
         if p.name then
            placemark('name', tostring(p.name))
         end
         if p.color or p.width then
            local style = placemark('Style')
            local linestyle = style('LineStyle')
            if p.color then
               linestyle('color', tostring(p.color))
            end
            if p.width then
               linestyle('width', tostring(p.width))
            end
         end
         local linestring = placemark('LineString')
         for k,v in pairs(p.extras) do
            linestring(k, v)
         end
         local tessellate = 0
         if p.tessellate then
            tessellate = 1
         end
         if tessellate == 1 then
            linestring('tessellate', tostring(tessellate))
            --required for tessellate
            linestring('altitudeMode', 'clampToGround')
         end
         linestring('coordinates', tostring(p.coords:concat('\n')))
      end
   end

   -- Plot polygons
   local polygons_folder_stack = stack_t()
   local polygons_folder = doc('Folder')
   polygons_folder('name', 'polygons')
   for _,p in ipairs(self._.polygons) do
      if p.action then
         if p.action == 'open_folder' then
            polygons_folder_stack:push(polygons_folder)
            polygons_folder = polygons_folder('Folder')
            polygons_folder('name', p.name)
         elseif p.action == 'close_folder' then
            if #polygons_folder_stack > 0 then
               polygons_folder = polygons_folder_stack:pop()
            end
         end
      else
         local placemark = polygons_folder('Placemark')
         if p.name then
            placemark('name', tostring(p.name))
         end
         if p.color or p.linewidth or p.linecolor then
            local style = placemark('Style')
            if p.linewidth or p.linecolor then
               local linestyle = style('LineStyle')
               if p.linewidth then
                  linestyle('width', tostring(p.linewidth))
               end
               if p.linecolor then
                  linestyle('color', tostring(p.linecolor))
               end
            end

            if p.color then
               local polystyle = style('PolyStyle')
               polystyle('color', tostring(p.color))
            end
         end

         local polygon = placemark('Polygon')

         local extrude = 0
         if p.extrude then
            extrude = 1
         end
         polygon('extrude', tostring(extrude))

         local tessellate = 0
         if p.tessellate then
            tessellate = 1
         end
         if tessellate == 1 then
            polygon('tessellate', tostring(tessellate))

            --required for tessellate
            polygon('altitudeMode', 'clampToGround')
         else
            --required for non-tessellated
            polygon('altitudeMode', 'relativeToGround')
         end

         for k,v in pairs(p.extras or {}) do
            if k ~= 'altitudeMode' or
               (k == 'altitudeMode' and tessellate ~= 1)
            then
               polygon(k, v)
            end
         end

         local outerboundary = polygon('outerBoundaryIs')
         local outerring = outerboundary('LinearRing')
         outerring('coordinates', tostring(p.coords:concat('\n')))

         if #p.cutout_coords > 0 then
            local innerboundary = polygon('innerBoundaryIs')
            local innerring = innerboundary('LinearRing')
            innerring('coordinates', tostring(p.cutout_coords:concat('\n')))
         end
      end
   end

   local s = tostring(kml)

   return s
end

---[[
if arg and arg[0]:match('.*kml_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end
--]]
--[[
tests.plot_polar()
--]]

module('kml_t')
