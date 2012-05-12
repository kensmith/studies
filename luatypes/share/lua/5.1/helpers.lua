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

helpers = {}

local tests = {}

---Recursively print a table.  Idiomatic usage:
--helpers.print_table(my_table, 'my_table')
--@param t table
--@param name string
function helpers.print_table(t, name)
   if (name == nil) then
      name = 't'
   end

   if type(t) ~= 'table' then
      print(name .. ' = ' .. type(t))
      return
   end

   for k,v in pairs(t) do
      if (type(v) == 'table' or type(v) == 'pddm_t') then
         local newname = name .. '|' .. tostring(k)
         print(newname)
         helpers.print_table(v, newname)
      else
         print(name .. '|' .. tostring(k) .. ' = ' .. tostring(v))
      end
   end
end

function tests.tables_equal()
   local function f() print('hi') end
   local a = {
      subt = {
         a = 1,
         'b',
         f
      },
      1,2,3,4,5,
      a = 'b',
      c = 'd',
      e = {1,2,3,4,5},
   }
   local b = {
      subt = {
         a = 2,
         'c',
         f
      },
      1,2,3,4,5,
      a = 'b',
      c = 'd',
      e = {1,2,3,4,5},
   }
   local c = {
      subt = {
         a = 1,
         'b',
         f
      },
      1,2,3,4,5,
      a = 'b',
      c = 'd',
      e = {1,2,3,4,5},
   }
   assert(helpers.tables_equal(a,c))
   assert(not helpers.tables_equal(a,b))

   local f = {}
   local g = {1,2,3}
   assert(not helpers.tables_equal(f,g))
end
---Deep comparison of two tables for equality.
--@param lhs a table
--@param rhs a table
--@return true of tables have identical contents.
function helpers.tables_equal(lhs,rhs)
   if type(lhs) ~= type(rhs) then
      return false
   end

   if type(lhs) ~= 'table' then
      return lhs == rhs
   end

   if #lhs ~= #rhs then
      return false
   end

   for k,v in pairs(lhs) do
      if not helpers.tables_equal(v,rhs[k]) then
         return false
      end
   end

   return true
end

function tests.copy_table()
   local t = {
      subt = {
         a = 1,
         'b',
         function () print('hi') end,
      },
      1,2,3,4,5,
      a = 'b',
      c = 'd',
      e = {1,2,3,4,5},
   }
   assert(helpers.tables_equal(t,helpers.copy_table(t)))
end
---Table deep copy.
--@param t the table to copy
--@param copy a private variable containing the intermediate
--table.  Don't give this parameter a value.
--@return a copy of t
function helpers.copy_table(t)
   if type(t) ~= 'table' then
      return(t)
   end

   local copy = {}
   for k,v in pairs(t) do
      copy[k] = helpers.copy_table(v)
   end

   return copy
end

---Just like helpers.print_table but render the table to a
--string rather that to the console.
--@param t table
--@param name string
--@param stringbuf private recursion variable
function helpers.table_to_string(t, name, stringbuf)
   local top = not stringbuf

   stringbuf = stringbuf or {insert = table.insert, concat = table.concat}

   if (name == nil) then
      name = 't'
   end

   if type(t) ~= 'table' then
      stringbuf:insert(name)
      stringbuf:insert(' = ')
      stringbuf:insert(type(t))
      stringbuf:insert('\n')
      return
   end

   for k,v in pairs(t) do
      if (type(v) == 'table' or type(v) == 'pddm_t') then
         local newname = name .. '|' .. tostring(k)
         stringbuf:insert(newname)
         stringbuf:insert('\n')
         helpers.table_to_string(v, newname, stringbuf)
      else
         stringbuf:insert(name)
         stringbuf:insert('|')
         stringbuf:insert(tostring(k))
         stringbuf:insert(' = ')
         stringbuf:insert(tostring(v))
         stringbuf:insert('\n')
      end
   end

   if top then
      return stringbuf:concat()
   end
end

function tests.serialize_table()
   local t = {
      z = true,
      a = 1,
      b = 2,
      c = 3,
      4,5,6,
      d = {
         subd = {
            'a','b','c',
         }
      },
      e = math.pi,
      ['wacky label'] = 'wacky\'value',
      ['at&t'] = 'ma bell',
   }

   local answer = [[
t = {
   [1] = 4,
   [2] = 5,
   [3] = 6,
   a = 1,
   ['wacky label'] = 'wacky\'value',
   c = 3,
   z = true,
   e = 3.141592653589793116,
   d = {
      subd = {
         [1] = 'a',
         [2] = 'b',
         [3] = 'c',
      },
   },
   ['at&t'] = 'ma bell',
   b = 2,
}
]]
   local serialized_sb = {insert = table.insert, concat = table.concat}
   helpers.serialize_table(function (s) serialized_sb:insert(s) end, t, nil)
   local serialized = serialized_sb:concat()
   assert(serialized == answer)
end
---Emits a string that can be read in by Lua to reproduce the table.  Doesn't
--handle function, userdata or thread instances.  The callback is called for
--every chunk of text that is ready for the stream.  Pass io.write as the
--callback to print your table to the console.
--TODO allow methods for callback
function helpers.serialize_table(callback, t, name, indent, --[[ private ]]lvl)
   assert(helpers.callable(callback),
      'helpers.serialize_table: expected callback to be callable, is a '
      .. type(callback)
      .. ' with value '
      .. tostring(callback)
   )
   assert(type(t) == 'table',
      'helpers.serialize_table: expected t to be a table, is a '
      .. type(t)
      .. ' with value "'
      .. tostring(t)
      .. '"'
   )
   local top = not lvl
   name = name or 't'
   indent = indent or 3
   lvl = lvl or 0

   function condition_key(key)
      local underscores_removed = tostring(key):gsub('_','UUU')
      if type(key) == 'string'
         and (
            key:match('%s')
            or underscores_removed:match('%p')
         )
      then
         return '[\'' .. key .. '\']'
      elseif type(key) == 'number' then
         return '[' .. tostring(key) .. ']'
      end
      return key
   end

   function condition_value(v)
      if type(v) == 'string' then
         return "'" .. v:gsub("'","\\'") .. "'"
      elseif type(v) == 'boolean' then
         return tostring(v)
      elseif type(v) == 'number' then
         if v ~= math.floor(v) then
            local string_as_number = string.format('%.19f',v)
            local trailing_zeroes_removed = string_as_number:gsub('0*$','')
            return trailing_zeroes_removed
         else
            return tostring(v)
         end
      end
      return "'" .. tostring(v) .. "'"
   end

   if top then
      callback(condition_key(name) .. ' = {\n')
      lvl = lvl + 1
   end

   local indent_string = string.rep(' ', lvl * indent)
   for k,v in pairs(t) do
      callback(indent_string .. condition_key(k) .. ' = ')
      if type(v) == 'table' then
         callback('{\n')
         helpers.serialize_table(callback, v, k, indent, lvl + 1)
         callback(indent_string .. '},\n')
      else
         callback(condition_value(v) .. ',\n')
      end
   end

   if top then
      callback('}\n')
   end
end

---Return the non-path component of a filesystem path.
--@param fullname string
--@return string
function helpers.basename(fullname)
   assert(type(fullname) == 'string')
   local result, dummy = fullname:gsub('.*/','')
   return result
end

---Return the non-filename component of a filesystem path.
--@param fullname string
--@return string
function helpers.dirname(fullname)
   assert(type(fullname) == 'string')
   local result, dummy = fullname:gsub('/[^/]*$','')
   return result
end

function helpers.exponentiatable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__pow)
end

function helpers.addable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__add)
end

function helpers.dividable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__div)
end

function helpers.lt_comparable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__lt)
end

function helpers.le_comparable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__le)
end

function helpers.eq_comparable(v)
   local mt = getmetatable(v)
   return tonumber(v) or (mt and mt.__eq)
end

---Returns true if the argument is a function or supports a __call
--metamethod.
--@param f any value (usually a function or table)
--@return boolean
function helpers.callable(f)
   local mt = getmetatable(f)
   local result = 
      (f and type(f) == 'function')
      or
      (mt and type(mt.__call) == 'function')
   if result == nil then
      return false
   end
   return result
end

---Remove leading and trailing whitespace from a string.
--@param s string
--@return string
function helpers.strip(s)
   if type(s) ~= 'string' then
      return s
   end
   local result, dummy = s:gsub('^%s*',''):gsub('%s*$','')
   return result
end

if arg and arg[0]:match('^.*helpers.lua') then
   print('basename = ' .. helpers.basename('a/ab/f/c/af/hello.txt'))
   print('dirname = ' .. helpers.dirname('a/ab/f/c/af/hello.txt'))
   print('dirname = ' .. helpers.dirname('a/ab/f/c/af/'))
   mt = {__call = function() end}
   t = {}
   setmetatable(t,mt)
   print('callable(t) = ' .. tostring(helpers.callable(t)))
   print('callable(f) = ' .. tostring(helpers.callable(function () end)))
   print('callable(nil) = ' .. tostring(helpers.callable(nil)))
   print('callable(10) = ' .. tostring(helpers.callable(10)))

   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('helpers')
