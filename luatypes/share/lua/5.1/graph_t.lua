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
require('coord_t')
require('stats')
require('helpers')
require('fun')

graph_t = {}

setmetatable(graph_t, graph_t)

local tests = {}

function tests.__call()
   local g = graph_t()
   assert(is.a(graph_t, g))
   local centroid_finder = graph_t(false)
   assert(is.a(graph_t, centroid_finder))
   assert(centroid_finder.maximum_distance == nil)
   assert(centroid_finder.minimum_distance == nil)
   assert(centroid_finder.average_distance == nil)
end
---Instantiate a graph_t.
--@param compute_distances set to false to avoid computing distances.  This can
--result in a dramatic performance improvement for large graph_t's, especially
--if you need to partition.
--@return a new graph_t instance
function graph_t:__call(compute_distances)
   if compute_distances == nil then
      compute_distances = true
   end
   local o = {
      _ = {
         points = {insert = table.insert},
         count = 0,
         num_distances = compute_distances and 0 or nil,
         minimum_distance = compute_distances and math.huge or nil,
         average_distance = compute_distances and 0 or nil,
         maximum_distance = compute_distances and 0 or nil,
         centroid = coord_t(0,0,0),
         compute_distances = compute_distances,
      },
      point = graph_t.point,
      minimum_distance = compute_distances and graph_t.minimum_distance or nil,
      maximum_distance = compute_distances and graph_t.maximum_distance or nil,
      average_distance = compute_distances and graph_t.average_distance or nil,
      num_points = graph_t.num_points,
      points = graph_t.points,
      centroid = graph_t.centroid,
      partition = graph_t.partition,
      which_partition = graph_t.which_partition,
   }

   setmetatable(o, graph_t)

   return o
end


function tests.point()
   local g = graph_t()

   g:point(coord_t(40.613993, -74.011806))
   g:point(coord_t(40.749088, -73.950004))
   g:point(coord_t(40.710183, -73.865064))

   assert(#g._.points == 3)
end
---Add a geographical coordinate to the graph.  This method
--does the additional work of computing the distance between
--the new point and all points already in the graph.
--@param the geographical coordinate.
--@return self
function graph_t:point(newp)
   assert(is.a(coord_t, newp))

   self._.count = self._.count + 1
   for _,p in ipairs(self._.points) do
      if self._.compute_distances then
         self._.num_distances = self._.num_distances + 1
         local dist = (p - newp):length()
         self._.maximum_distance = math.max(dist, self._.maximum_distance)
         self._.minimum_distance = math.min(dist, self._.minimum_distance)
         self._.average_distance =
            self._.average_distance * (self._.num_distances - 1) / self._.num_distances
            + dist * 1 / self._.num_distances
      end
   end
   self._.centroid =
      self._.centroid * (self._.count - 1) / self._.count
      + newp * 1 / self._.count

   self._.points:insert(newp)
end


function tests.minimum_distance()
   local g = graph_t()

   g:point(coord_t(40.613993, -74.011806))
   g:point(coord_t(40.749088, -73.950004))
   g:point(coord_t(40.710183, -73.865064))
   g:point(coord_t(40.637603, -73.966806))
   g:point(coord_t(40.684556, -73.914333))
   g:point(coord_t(40.637603, -73.966806)) -- dup
   g:point(coord_t(40.702028, -73.832889))

   is.zero(g:minimum_distance())
end
---Compute the minimum distance between all points in a
--graph.
--@return the minimum distance
function graph_t:minimum_distance()
   return self._.minimum_distance
end


function tests.maximum_distance()
   local g = graph_t()

   g:point(coord_t(40.613993, -74.011806))
   g:point(coord_t(40.749088, -73.950004))
   g:point(coord_t(40.710183, -73.865064))
   g:point(coord_t(40.637603, -73.966806))
   g:point(coord_t(40.684556, -73.914333))
   g:point(coord_t(40.637603, -73.966806)) -- dup
   g:point(coord_t(40.702028, -73.832889))

   assert(is.zero(g:maximum_distance() - 17991.931759581))
end
---Find the maximum distance between all points in the
--graph.
--@return the maximum distance
function graph_t:maximum_distance()
   return self._.maximum_distance
end

function tests.average_distance()
   local g = graph_t()

   g:point(coord_t(40.613993, -74.011806))
   g:point(coord_t(40.749088, -73.950004))
   g:point(coord_t(40.710183, -73.865064))
   g:point(coord_t(40.637603, -73.966806))
   g:point(coord_t(40.684556, -73.914333))
   g:point(coord_t(40.637603, -73.966806)) -- dup
   g:point(coord_t(40.702028, -73.832889))

   assert(is.zero(g:average_distance() - 9623.9126259506))
end
---Find the average distance between all points in the
--graph.
--@return the average distance
function graph_t:average_distance()
   return self._.average_distance
end


function tests.num_points()
   local g = graph_t()

   g:point(coord_t(40.613993, -74.011806))
   g:point(coord_t(40.749088, -73.950004))
   g:point(coord_t(40.710183, -73.865064))
   g:point(coord_t(40.637603, -73.966806))
   g:point(coord_t(40.684556, -73.914333))
   g:point(coord_t(40.637603, -73.966806)) -- dup
   g:point(coord_t(40.702028, -73.832889))

   assert(g:num_points() == 7)
end
---@eturns the number of points in the graph.
function graph_t:num_points()
   return self._.count
end


function tests.points()
   local g = graph_t()

   local points = {
      coord_t(40.613993, -74.011806),
      coord_t(40.749088, -73.950004),
      coord_t(40.710183, -73.865064),
      coord_t(40.637603, -73.966806),
      coord_t(40.684556, -73.914333),
      coord_t(40.637603, -73.966806), -- dup
      coord_t(40.702028, -73.832889),
   }
   for _,p in ipairs(points) do
      g:point(p)
   end

   local min = g:minimum_distance()
   local avg = g:average_distance()
   local max = g:maximum_distance()

   local count = 0
   for point in g:points() do
      count = count + 1
      assert(point == points[count])
      point:lat(0) -- mess up the copy
      point:lon(0)
      point:alt(0)
   end

   -- Check that we iterated properly
   assert(count == #points)

   -- make sure the modified copies didn't affect the graph
   assert(min == g:minimum_distance())
   assert(max == g:maximum_distance())
   assert(avg == g:average_distance())
end
---Iterator that gives you each point, one at a time.
--@param dont_copy boolean when set, you get the actual coord_t that was
--inserted rather than a copy.  Useful if you happened to have associated some
--metadata with the coord_t and wish to retrieve it.
function graph_t:points(dont_copy)
   local current_point = 1
   return function ()
      if current_point > #self._.points then
         return nil
      end
      local point
      if dont_copy then
         point = self._.points[current_point]
      else
         point = self._.points[current_point]:copy()
      end
      current_point = current_point + 1
      return point
   end
end

function tests.centroid()
   local g = graph_t()

   local points = {
      coord_t(40.613993, -74.011806),
      coord_t(40.749088, -73.950004),
      coord_t(40.710183, -73.865064),
      coord_t(40.637603, -73.966806),
      coord_t(40.684556, -73.914333),
      coord_t(40.637603, -73.966806), -- dup
      coord_t(40.702028, -73.832889),
   }

   for _,p in ipairs(points) do
      g:point(p)
   end

   local centroid = coord_t(40.676436285714, -73.929672571429, 0)
   local delta_centroid = centroid - g:centroid()
   assert(delta_centroid:length() < 0.01)
end
---Return the centroid of the graph.
function graph_t:centroid()
   return self._.centroid
end


function tests.__tostring()
   local g = graph_t()
   assert(tostring(g) == 'graph_t:')

   local points = {
      coord_t(40.613993, -74.011806),
      coord_t(40.749088, -73.950004),
      coord_t(40.710183, -73.865064),
      coord_t(40.637603, -73.966806),
      coord_t(40.684556, -73.914333),
      coord_t(40.637603, -73.966806), -- dup
      coord_t(40.702028, -73.832889),
   }

   for _,p in ipairs(points) do
      g:point(p)
   end

   assert(tostring(g) ==
[[graph_t:
   40.613993, -74.011806, 0
   40.749088, -73.950004, 0
   40.710183, -73.865064, 0
   40.637603, -73.966806, 0
   40.684556, -73.914333, 0
   40.637603, -73.966806, 0
   40.702028, -73.832889, 0]]
   )
end
---Renders a graph_t as a printable string.
function graph_t:__tostring()
   local sb = {insert = table.insert, concat = table.concat}

   sb:insert('graph_t:')
   for point in self:points() do
      sb:insert('\n   ')
      sb:insert(tostring(point))
   end

   return sb:concat()
end


function tests.which_partition()
   local g = graph_t()

   local points = {
      coord_t(40.613993, -74.011806),
      coord_t(40.749088, -73.950004),
      coord_t(40.710183, -73.865064),
      coord_t(40.637603, -73.966806),
      coord_t(40.684556, -73.914333),
      coord_t(40.637603, -73.966806), -- dup
      coord_t(40.702028, -73.832889),
   }

   for _,p in ipairs(points) do
      g:point(p)
   end

   local partitions = {3, 2, 1, 3, 1, 3, 1}

   for i,p in ipairs(points) do
      assert(g.which_partition(p, g:centroid()) == partitions[i])
   end
end
---Class method that returns a number between 1 and 4 indicating which
--partition of this graph the input coordintates would fall.
--@param coord input coordinates
function graph_t.which_partition(coord, centroid)
   local distance_vec = coord - centroid
   local bearing = distance_vec:azimuth_angle()
   local partition_num = math.floor(bearing / 90) + 1
   return partition_num
end


function tests.partition()
   local g = graph_t()

   local points = {
      coord_t(40.613993, -74.011806),
      coord_t(40.749088, -73.950004),
      coord_t(40.710183, -73.865064),
      coord_t(40.637603, -73.966806),
      coord_t(40.684556, -73.914333),
      coord_t(40.637603, -73.966806), -- dup
      coord_t(40.702028, -73.832889),
   }

   for _,p in ipairs(points) do
      g:point(p)
   end

   local p = g:partition()

   local expected_quadrants = {
      {points[3], points[5], points[7]},
      {points[2]},
      {points[1], points[4], points[6]},
      {},
   }

   for i,subp in ipairs(p) do
      local count = 1
      for point in subp:points() do
         assert(point == expected_quadrants[i][count])
         count = count+1
      end
   end

   local p2 = g:partition(2)
   local expected_quadrants2 =
   {
      {
         {points[3], points[7]},
         {},
         {points[5]},
         {},
      },
      {points[2]},
      {
         {points[4], points[6]},
         {},
         {points[1]},
         {},
      },
      {},
   }

   for i,v in ipairs(p2) do
      if #v > 0 then
         for j,w in ipairs(v) do
            local count = 1
            for point in w:points() do
               assert(point == expected_quadrants2[i][j][count])
               count = count + 1
            end
         end
      else
         local count = 1
         for point in v:points() do
            assert(point == expected_quadrants2[i][count])
            count = count + 1
         end
      end
   end
end
---@return four new graph_t's, 1, 2, 3, 4 where all 1 contains all
--points northwest of the centroid, 2, contains all points northeast of
--the centroid, 3 contains all points southwest of the centroid, and 4
--contains all points southeast of the centroid.
function graph_t:partition(max_per_partition)
   local p = {
      centroid = self:centroid(),
      graph_t(self._.compute_distances),
      graph_t(self._.compute_distances),
      graph_t(self._.compute_distances),
      graph_t(self._.compute_distances),
   }

   -- Assign all points to a partition.
   -- northeast partition is quadrant 1 with quadrant indices increasing
   -- clockwise.  2=northwest, 3=southwest, 4=southeast.
   for point in self:points(true) do
      local partition_num = self.which_partition(point, self:centroid())
      assert(1 <= partition_num and partition_num <= 4,
         'graph_t:partition: invalid quadrant, ' .. tostring(partition_num))
      p[partition_num]:point(point)
   end

   if max_per_partition then
      -- Recurse until each partition has the required number of points
      for i,subp in ipairs(p) do
         if subp:num_points() > max_per_partition then
            p[i] = subp:partition(max_per_partition)
         end
      end
   end

   return p
end


if arg and arg[0]:match('.*graph_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('graph_t')
