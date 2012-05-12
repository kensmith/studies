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

require('helpers')

---Functional programming extension for Lua.

fun = {}

local tests = {}

function tests.map()
   local squares =
      fun.map(
         function (x)
            return x^2
         end,
         {1,2,3,4,5}
      )

   for i=1,5 do
      assert(squares[i] == i^2)
   end
end
---Apply a unary function f to each element of a list and return a new
--list containing the results.  The original list is not modified.
--@param f the unary function
--@param list the list
function fun.map(f, list)
   local result = {}
   for i=1,#list do
      result[i] = f(list[i])
   end
   return result
end

function tests.fold()
   assert(
      1+2+3+4+5
      ==
      fun.fold(
         function (x, accum)
            return accum + x
         end,
         {1,2,3,4,5}
      )
   )

   assert(
      '((((1+2)+3)+4)+5)'
      ==
      fun.fold(
         function (x, accum)
            return '(' .. accum .. '+' .. tostring(x) .. ')'
         end,
         {1,2,3,4,5}
      )
   )

   assert(
      nil
      ==
      fun.fold(
         function (x, accum)
            return accum + x
         end,
         {}
      )
   )

   assert(
      1
      ==
      fun.fold(
         function (x, accum)
            return accum + x
         end,
         {1}
      )
   )
end
---Produce a single value by taking every element of a list and
--applying it to some function which takes the value as its first
--argument and the accumulator (the ultimate result) as its second
--starting from the lowest indexed element and working toward the
--highest.
--@param f a function taking two arguments
--@param list the list to operate on. the original list is not
--modified.
function fun.fold(f, list)
   local accum = list[1]
   for i=2,#list do
      accum = f(list[i], accum)
   end
   return accum
end

function tests.foldr()
   assert(
      1+2+3+4+5
      ==
      fun.foldr(
         function (x, accum)
            return accum + x
         end,
         {1,2,3,4,5}
      )
   )
   assert(
      '(1+(2+(3+(4+5))))'
      ==
      fun.foldr(
         function (x, accum)
            return '(' .. tostring(x) .. '+' .. accum .. ')'
         end,
         {1,2,3,4,5}
      )
   )
end
---Like fun.fold but start from the highest indexed element and
--move toward the lowest.
--@param f a function taking two arguments
--@param initval the starting value for the second argument to f
--@param list the list to operate on. the original list is not
--modified.
function fun.foldr(f, list)
   local len = #list
   local accum = list[len]
   for i=len-1,1,-1 do
      accum = f(list[i], accum)
   end
   return accum
end

if arg and arg[0]:match('.*fun.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('fun')
