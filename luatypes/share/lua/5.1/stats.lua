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
require('fun')
require('helpers')

--- Basic statistical analysis functions.
stats = {epsilon = 1e-20}

local tests = {}

function tests.sum()
   assert(21 == stats.sum{1,2,3,4,5,6})
end

--- Returns the sum of a list of numbers.
--@param t an ipairs indexable list of numbers
--@return number
function stats.sum(t)
   return fun.fold(
      function (x, accum)
         return x + accum
      end,
      t
   )
end

function tests.avg()
   local centroid = stats.avg{
      coord_t(36.599188,138.077070),
      coord_t(36.573143,138.137135),
      coord_t(36.716197,138.298105)
   }
   local expected_centroid = coord_t(36.629509, 138.170770)
   local close = 1
   assert((centroid - expected_centroid):length() < close)
   assert(stats.avg{1,2,3,4,5,6} - 3.5 < stats.epsilon)
   assert(stats.avg{1,'',2,3,{},4,5,6} - 3.5 < stats.epsilon)
   assert(stats.avg{1,2,3,'4.0',5,6} - 3.5 < stats.epsilon)
   assert(stats.avg{} == nil)
end

--- Averages an a list of numbers.
-- @param t An ipairs indexable list of numbers
-- @return number
function stats.avg(t)
   local sum
   local count = 0
   for i,v in ipairs(t) do
      v = helpers.addable(v) and helpers.dividable(v) and v or tonumber(v)
      if v then
         if not sum then
            -- we can't just initialize sum to zero because we may not be dealing
            -- with raw numbers
            sum = v
         else
            sum = sum + v
         end
         count = count + 1
      end
   end
   if sum then
      return sum / count
   end

   return nil
end

function tests.stddev()
   assert(stats.stddev{1,2,3,4,5,6} - 1.870828693387 < stats.epsilon)
   assert(stats.stddev{1,'',2,3,4,5,6} - 1.870828693387 < stats.epsilon)
end

--- Standard deviation for an ipairs indexable list of numbers.
-- @param t An ipairs indexable list of numbers
-- @return number
function stats.stddev(t)
   local accum = 0
   local avg = stats.avg(t)
   local count = 0
   for i,v in ipairs(t) do
      v = helpers.addable(v)
         and helpers.dividable(v)
         and helpers.exponentiatable(v)
         and v
         or tonumber(v)
      if v then
         accum = accum + (v - avg)^2
         count = count + 1
      end
   end
   return math.sqrt(accum / (count - 1))
end

function tests.index_of_min()
   assert(2 == stats.index_of_min{
      vector_t(45, 45),
      vector_t(35, 12),
      vector_t(55, 34),
   })
   assert(stats.index_of_min{1,2,3,4,5,6} == 1)
   assert(stats.index_of_min{1,2,{},3,'',4,5,6} == 1)
end

--- Find the index of the smallest numerical value.
-- @param t An ipairs indexable list of numbers
-- @return number
function stats.index_of_min(t)
   local idx = nil
   for i,v in ipairs(t) do
      v = helpers.lt_comparable(v) and v or tonumber(v)
      if v then
         if not idx or v < t[idx] then
            idx = i
         end
      end
   end
   return idx
end

function tests.index_of_max()
   assert(3 == stats.index_of_max{
      vector_t(45, 45),
      vector_t(35, 12),
      vector_t(55, 34),
   })
   assert(stats.index_of_max{1,2,3,4,5,6} == 6)
   assert(stats.index_of_max{1,2,3,'',4,{},5,6} == 8)
end

--- Find the index of the largest numerical value.
-- @param t An ipairs indexable list of numbers
-- @return number
function stats.index_of_max(t)
   local idx = nil
   for i,v in ipairs(t) do
      v = helpers.lt_comparable(v) and v or tonumber(v)
      if v then
         if not idx or v > t[idx] then
            idx = i
         end
      end
   end
   return idx
end

-- `lua stats.lua` to run unit tests.
if arg and arg[0]:match('.*stats.lua') then
   require('coord_t') -- a non-number that supports +,-,*,/
   require('vector_t') -- a non-number that supports <,>
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('stats')
