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

--- A stack class.  The bottom of the stack is the lowest indexed
-- element following the natural operation of table.insert and
-- table.remove.
stack_t = {}

setmetatable(stack_t, stack_t)

local tests = {}

function tests.push()
   local s = stack_t()
   s:push('a')
   assert(s[1] == 'a')
   s:push('b')
   assert(s[2] == 'b')
end

--- Add val to the top of the stack
-- @param val any non-nil value
-- @return self
-- @return hi
function stack_t:push(val)
   assert(is.a(stack_t, self),
      'stack_t:push: self must be a stack_t (use : to call the method), '
      .. 'type(self) = ' .. type(self)
   )

   table.insert(self, val)

   return self
end

function tests.pop()
   local s = stack_t()
   s:push('a')
   s:push('b')
   s:push('c')
   s:pop()
   assert(#s == 2)
   s:pop(2)
   assert(#s == 0)
end

--- Pops 1 or n items from the stack
-- @param n number of items to pop
-- @return A value popped from the stack when n is nil or 1 but
-- returns a stack_t populated with the top n items in reversed
-- order when n exceeds 1.
function stack_t:pop(n)
   assert(is.a(stack_t, self),
      'stack_t:pop: self must be a stack_t (use : to call the method), '
      .. 'type(self) = ' .. type(self)
   )

   n = n or 1

   assert(type(n) == 'number' and n >= 1,
      'stack_t:pop: n must be a number >= 1, was ' .. tostring(n)
   )

   local results

   if n == 1 then
      results = table.remove(self)
   else
      results = stack_t()

      local thisval
      repeat
         thisval = table.remove(self)
         if thisval then
            table.insert(results, thisval)
         end
         n = n - 1
      until not thisval or n <= 0
   end

   return results
end

function tests.join()
   local s1 = stack_t{1,2,3,4,5}
   local s1_len = #s1
   local s2 = stack_t{6,7,8,9,10}
   local s2_len = #s2
   s1:join(s2)
   assert(#s1 == s1_len + s2_len)
end

--- Join two stacks such that the top of peer is the top of the
-- resultant stack and the top of self is adjacent to the element at
-- the bottom of peer and return s.
-- @param peer another stack_t instance
function stack_t:join(peer)
   assert(is.a(stack_t, self),
      'stack_t:join: self must be a stack_t (use : to call the method), is '
      .. type(self)
   )

   assert(is.a(stack_t, peer), 
      'stack_t:join: peer must be a stack_t, was ' .. type(peer)
   )

   assert(self ~= peer,
      'stack_t:join: self and peer must be different'
   )
   
   for i,v in ipairs(peer) do
      table.insert(self, v)
   end

   return self
end

function tests.copy()
   local s = stack_t{1,2,3,4,5}
   local copy = s:copy()
   assert(#s == #copy)
end

--- perform a deep copy of self and return the result
function stack_t:copy()
   assert(is.a(stack_t, self),
      'stack_t:copy: self must be a stack_t (use : to call the method), '
      .. 'type(self) = ' .. type(self)
   )

   local result = stack_t()

   for i,v in ipairs(self) do
      table.insert(result, v)
   end

   return result
end

function tests.top()
   local t = {}
   local s = stack_t{1,2,3,4,t}
   assert(t == s:top())
end
---Retrieve the value from the top of the stack but don't pop it.
--@return value or nil
function stack_t:top()
   assert(is.a(stack_t, self),
      "stack_t:top: self must be a stack_t, was "
      .. type(self)
   )

   return self[#self]
end

function tests.__call()
   local s = stack_t()
   assert(is.a(stack_t, s))
end

--- Instantiate a stack_t
-- @param existing_table a table to convert into a stack_t
function stack_t:__call(existing_table)
   local o = existing_table or {}

   o.push = stack_t.push
   o.pop = stack_t.pop
   o.join = stack_t.join
   o.copy = stack_t.copy
   o.top = stack_t.top
   o.index_of_min = stack_t.index_of_min
   o.index_of_max = stack_t.index_of_max

   setmetatable(o, stack_t)

   return o
end

function tests.index_of_min()
   local s = stack_t{5,4,3,2,1,0,1,2,3,4,5}
   assert(6 == s:index_of_min())
end
---Find the index of the least item in the stack.
function stack_t:index_of_min()
   local idx = nil
   for i,v in ipairs(self) do
      if not idx or v < self[idx] then
         idx = i
      end
   end
   return idx
end

function tests.index_of_max()
   local s = stack_t{1,2,3,4,5,4,3,2,1}
   assert(5 == s:index_of_max())
end
---Find the index of the greatest item in the stack.
function stack_t:index_of_max()
   local idx = nil
   for i,v in ipairs(self) do
      if not idx or v > self[idx] then
         idx = i
      end
   end
   return idx
end

function tests.__tostring()
   assert(type(tostring(stack_t())) == 'string')
end

--- Render a stack_t as a printable string
function stack_t:__tostring()
   local b = {insert = table.insert, concat = table.concat}

   local mt = getmetatable(self)
   setmetatable(self,{})
   b:insert('stack_t instance (' .. tostring(self) .. ')')
   setmetatable(self,mt)

   local depth = #self

   for i,v in ipairs(self) do
      b:insert(1,'\n')
      b:insert(1,tostring(v))
      b:insert(1,'=')
      if depth-i == 0 then
         b:insert(1,tostring('top'))
      else
         b:insert(1,string.format('%3d', depth-i))
      end
   end

   return b:concat()
end

-- `lua stack_t.lua` to run unit tests.
if arg and arg[0]:match('.*stack_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('stack_t')
