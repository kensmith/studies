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

--- A higher level type()-like function for custom classes.

is = {epsilon = 1e-9}

local tests = {}

function tests.a()
   local mt1 = {}
   local mt2 = {}
   local class = {}
   setmetatable(class, mt1)
   local instance = {}
   setmetatable(instance, mt1)
   assert(is.a(class, instance))
   local notinstance = {}
   setmetatable(notinstance, mt2)
   assert(not is.a(class, notinstance))
end

---Returns true if the metatables for class and instance match.
--Similar in spirit to instanceof() in other languages.
--@param class a metatable
--@param instance an instance of some object
--@return boolean
function is.a(class, instance)
   local class_mt = getmetatable(class)
   local instance_mt = getmetatable(instance)
   if class_mt == nil then
      if type(class) == 'table' then
         class_mt = class.mt
      end
   end
   if instance_mt == nil then
      if type(instance) == 'table' then
         instance_mt = instance.mt
      end
   end
   if class_mt == nil or instance_mt == nil then
      return false
   end
   return class_mt == instance_mt
end

function tests.zero()
   local n1 = math.cos(math.rad(45))
   local n2 = 2^0.5/2
   local n3 = math.cos(math.rad(46))

   assert(is.zero(n1 - n2))
   assert(is.zero(n2 - n1))
   assert(not is.zero(n1 - n3))
   assert(not is.zero(n3 - n1))

   assert(is.zero{value = function() return 0 end})
   assert(not is.zero{value = function() return 15 end})
end
---Returns true if number is within is.epsilon of zero.
--@param number number or dnum_t
--@return boolean
function is.zero(number)
   local result = false
   if type(number) == 'number' then
      result = math.abs(number) < is.epsilon
   elseif type(number) == 'table' then
      if type(number.value) == 'function' then
         result = math.abs(number:value()) < is.epsilon
      end
   else
      error('is.zero: can\'t compare ' .. type(number) .. ' to 0')
   end
   return result
end

is.x_or_bail_pattern = 'expected a %s, is a %s with value "%s"'

function is.whatever_or_bail(val, expected_type, opt_valname, opt_funcname)
   assert(type(val) == expected_type,
      string.format('%s%sexpected %s to be a %s, is a %s with value "%s"',
         opt_funcname and tostring(opt_funcname) or '',
         opt_funcname and ': ' or '',
         opt_valname or '?',
         tostring(expected_type),
         type(val),
         tostring(val)
      )
   )
end

function is.table_or_bail(val, opt_varname, opt_funcname)
   local attr = 'hi'
   is.whatever_or_bail(val, 'table', opt_varname, opt_funcname)
end

function is.nil_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'nil', opt_varname, opt_funcname)
end

function is.boolean_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'boolean', opt_varname, opt_funcname)
end

function is.number_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'number', opt_varname, opt_funcname)
end

function is.string_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'string', opt_varname, opt_funcname)
end

function is.function_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'function', opt_varname, opt_funcname)
end

function is.userdata_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'userdata', opt_varname, opt_funcname)
end

function is.thread_or_bail(val, opt_varname, opt_funcname)
   is.whatever_or_bail(val, 'thread', opt_varname, opt_funcname)
end

-- `lua is.lua` to run unit tests.
if arg and arg[0]:match('.*is.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('is')
