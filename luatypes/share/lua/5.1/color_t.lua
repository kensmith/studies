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

color_t = {}

setmetatable(color_t, color_t)

local tests = {}

function tests.__call()
   local c = color_t(1, 1, 1, 0)
   assert(is.a(color_t, c))
end
---A color implementation to standardize color manipulation
--routines.
--@param red red intensity from 0 to 1
--@param green green intensity from 0 to 1
--@param blue blue intensity from 0 to 1
--@param alpha alpha channel value from 0 to 1
--@param mode display mode
--@see color_t:__tostring
function color_t:__call(red, green, blue, alpha, mode)
   assert(type(red) == 'number',
      "color_t:__call: red must be a number"
   )
   assert(0 <= red and red <= 1,
      "color_t:__call: red must be between 0 and 1 inclusive"
   )

   assert(type(blue) == 'number',
      "color_t:__call: blue must be a number"
   )
   assert(0 <= blue and blue <= 1,
      "color_t:__call: blue must be between 0 and 1 inclusive"
   )

   assert(type(green) == 'number',
      "color_t:__call: green must be a number"
   )
   assert(0 <= green and green <= 1,
      "color_t:__call: green must be between 0 and 1 inclusive"
   )

   assert(type(alpha) == 'number',
      "color_t:__call: alpha must be a number"
   )
   assert(0 <= alpha and alpha <= 1,
      "color_t:__call: alpha must be between 0 and 1 inclusive"
   )

   local o = {
      _ = {
         red = red,
         green = green,
         blue = blue,
         alpha = alpha,
         mode = nil,
      },
      mode = color_t.mode,
   }

   o:mode(mode or 'kml')

   setmetatable(o, color_t)

   return o
end


function tests.mode()
   local c = color_t(1,1,1,0)
   c:mode('kml')
   local success = pcall(c.mode, c, 'not defined')
   assert(not success)
end
local renderers = {
   kml = function(color)
      local b = {insert = table.insert, concat = table.concat}

      b:insert(string.format('%02X', color._.alpha*0xff))
      b:insert(string.format('%02X', color._.blue*0xff))
      b:insert(string.format('%02X', color._.green*0xff))
      b:insert(string.format('%02X', color._.red*0xff))

      return b:concat()
   end,
}
local renderers_reverse = {
   insert = table.insert,
   sort = table.sort,
   concat = table.concat
}
for k,v in pairs(renderers) do
   renderers_reverse:insert(k)
end
renderers_reverse:sort()
---Get or set the tostring mode for this color_t
--@param new_value new mode when supplied
--@return self when setting, current mode when getting
--@see color_t:__tostring
function color_t:mode(new_value)
   if new_value then
      assert(renderers[new_value],
         "color_t:mode: unrecognized mode, "
         .. tostring(new_value)
         .. ", acceptable values are, "
         .. renderers_reverse:concat(', ')
      )

      self._.mode = new_value

      return self
   else
      return self._.mode
   end
end

function tests.__tostring()
   local c = color_t(1/255, 20/255, 0xa0/255, 0xff/255)
   assert(tostring(c) == 'FFA01401')
end
---Render a color_t as a printable string according to the current
--mode.
--@return string
function color_t:__tostring()
   local result = renderers[self:mode()](self)
   return result
end


if arg and arg[0]:match('.*color_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('color_t')
