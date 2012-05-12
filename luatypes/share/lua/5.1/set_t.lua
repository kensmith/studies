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

---mathematical set class
require('helpers')
require('is')

set_t = {}

setmetatable(set_t, set_t)

local tests = {}

function tests.__call()
   local a = set_t{1,2,3,4,5}
end
---Instantiate a set_t.
function set_t:__call(t)
   local o = {
      raw = set_t.raw,
      insert = set_t.insert,
      has = set_t.has,
      unite = set_t.unite,
      copy = set_t.copy,
      intersect = set_t.intersect,
      _ = {
         set = {},
      },
   }

   if t and type(t) == 'table' then
      for i,v in ipairs(t) do
         o._.set[v] = true
      end
   end

   setmetatable(o, set_t)

   return o
end

function tests.unite()
   local a = {1,2,3,4,5}
   local b = {6,7,8,9,10}
   local aset = set_t(a)
   local bset = set_t(b)
   aset:unite(bset)
   
   for _,val in ipairs(a) do
      assert(aset:has(val), 'aset doesn\'t have "' .. val .. '"')
   end
end
---Union
function set_t:unite(rhs)
   assert(is.a(set_t, self),
      'set_t:__add: expected self to be a set_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )
   assert(is.a(set_t,rhs),
      'set_t:__add: expected rhs to be a set_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   for val,_ in pairs(rhs:raw()) do
      self:insert(val)
   end

   -- allow chaining operations
   return self
end

function tests.intersect()
   local a = {1,2,3,4,5,6,7,8}
   local b = {6,7,8,9,10}
   local aset = set_t(a)
   local bset = set_t(b)
   aset:intersect(bset)
   
   local ahas = {6,7,8}
   local ahasnt = {1,2,3,4,5,9,10}
   for _,val in ipairs(ahas) do
      assert(aset:has(val), 'aset doesn\'t have "' .. val .. '"')
   end
   for _,val in ipairs(ahasnt) do
      assert(not aset:has(val), 'aset has "' .. val .. '" but shouldn\'t')
   end
--]]
end
---Intersection
function set_t:intersect(rhs)
   assert(is.a(set_t, self),
      'set_t:__add: expected self to be a set_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )
   assert(is.a(set_t,rhs),
      'set_t:__add: expected rhs to be a set_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   for val,_ in pairs(self:raw()) do
      if not rhs:has(val) then
         self._.set[val] = nil
      end
   end

   -- allow chaining operations
   return self
end

function tests.has()
   local vals = {'a','b','c','d','e'}
   local a = set_t(vals)
   
   for _,val in ipairs(vals) do
      assert(a:has(val), 'a doesn\'t have "' .. val .. '"')
   end
end
---Check if an item has membership
function set_t:has(val)
   return self._.set[val] ~= nil
end

function tests.insert()
   local a = set_t{'a','b','c','d','e'}
   a:insert('f')
end
---Add an element to the set
function set_t:insert(val)
   self._.set[val] = true
end

function tests.raw()
   local a = set_t{'a','b','c','d','e'}
   local raw = a:raw()
   assert(raw.a and raw.b and raw.b and raw.d and raw.e)
end
---Return the actual set
function set_t:raw()
   return helpers.copy_table(self._.set)
end

function tests.__eq()
   local set = set_t{1,2,3,4,5}
   local copy = set:copy()
   assert(set == copy)
end
function set_t:__eq(rhs)
   assert(is.a(set_t, self),
      'set_t:__eq: expected self to be a set_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )
   for val,_ in pairs(self._.set) do
      if not rhs:has(val) then
         return false
      end
   end

   for val,_ in pairs(rhs._.set) do
      if not self:has(val) then
         return false
      end
   end

   return true
end

function tests.copy()
   local set = set_t{1,2,3,4,5}
   local copy = set:copy()
   assert(is.a(set_t, copy))
end
function set_t:copy()
   local copy = helpers.copy_table(self)
   setmetatable(copy, set_t)
   return copy
end

if arg and arg[0]:match('.*set_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest(tmpname)
      io.write('passed\n')
   end
end

module('set_t')
