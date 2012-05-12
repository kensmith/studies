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
require('helpers')

---A simplistic implementation of the priority queue or heap queue concept.
--This impelementation can constrain the maximum size of the queue so that,
--when the queue is full, if the new element succeeds in getting into the
--queue, the largest element is removed.
--
--One requirement for this data structure is that it must be itself a list
--whose first element (leftmost) is the top of the queue and is sorted at all
--times.
--
--This data structure is intended to be used with relatively small values of
--maxsize.
--
--Implemented originally for brute-force-digest.

sieve_t = {}

setmetatable(sieve_t, sieve_t)

tests = {}

function tests.__call()
   local a = sieve_t{1,5,2,4,3, maxsize=5}
   assert(is.a(sieve_t, a))
end
function sieve_t:__call(list)
   assert(type(list) == 'table',
      'sieve_t:__call: expected list to be a table, is a '
      .. type(list)
      .. ' with value "'
      .. tostring(list)
      .. '"'
   )
   if list.maxsize then
      assert(type(list.maxsize) == 'number',
         'sieve_t:__call: expected list.maxsize to be a number, is a '
         .. type(list.maxsize)
         .. ' with value "'
         .. tostring(list.maxsize)
         .. '"'
      )
   end
   if list.comp then
      assert(type(list.comp) == 'function',
         'sieve_t:__call: expected list.comp to be a '
         .. 'function, is a '
         .. type(list.comp)
         .. ' with value "'
         .. tostring(list.comp)
         .. '"'
      )
   end

   list.insert = sieve_t.insert
   list.collapse = sieve_t.collapse
   setmetatable(list, sieve_t)
   table.sort(list, list.comp)

   return list
end

function tests.insert()
   local a = sieve_t{1,5,2,4,3, maxsize=5}
   local b = helpers.copy_table(a)
   a:insert(6)
   assert(helpers.tables_equal(a,b))
   assert(#a == 5)
   for i,v in ipairs(a) do
      assert(v ~= 6)
   end
   a:insert(0)
   assert(a[1] == 0)
   local success = pcall(a.insert, a, 'hi')
   assert(not(success))
end
function sieve_t:insert(val)
   assert(is.a(sieve_t,self),
      'sieve_t:next_record: expected self to be a sieve_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   table.insert(self, val)
   table.sort(self, self.comp)

   if self.maxsize then
      for i=self.maxsize+1,#self do
         self[i] = nil
      end
   end

   return self
end

function tests.collapse()
   local a = sieve_t{1,5,2,4,3, maxsize=5, reverse = {}}
   a:collapse()
   for _,key in ipairs{'reverse', 'insert', 'collapse', 'maxsize'} do
      assert(a[key] == nil)
   end
end
---Remove all non-ipairs-indexable entries.  Note, this finalizes the sieve_t
--and removes all methods handles as well.
function sieve_t:collapse()
   assert(is.a(sieve_t,self),
      'sieve_t:next_record: expected self to be a sieve_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   for k,v in pairs(self) do
      if not tonumber(k) then
         self[k] = nil
      end
   end

   return self
end

if arg and arg[0]:match('.*sieve_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest(tmpname)
      io.write('passed\n')
   end
end

module('sieve_t')
