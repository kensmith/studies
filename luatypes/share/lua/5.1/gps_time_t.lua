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

gps_time_t = {}

setmetatable(gps_time_t, gps_time_t)

function gps_time_t:__call(wno, tow)
   local o = {
      _ = {},
      wno = gps_time_t.wno,
      tow = gps_time_t.tow,
   }

   if is.a(unix_epoch_time_t, wno) then
      local unix_epoch = wno
      local gps_epoch =
         gps_epoch_time_t(unix_epoch)
      local gps = gps_epoch:gps()
      o._.wno = math.floor(gps / (7*24*3600))
      o._.tow = gps - (o._.wno * 7*24*3600)
   elseif is.a(utc_t, wno) then
      local utc = wno
      assert(utc:year() >= 1980,
         'gps_time_t: year "'
         .. utc:year()
         .. '" not supported'
      )
      local seconds_since_gps_epoch =
         utc - utc_t(1980,1,6,0,0,0)
         + leap_seconds_for(utc)
      o._.wno = math.floor(seconds_since_gps_epoch / (7*24*3600))
      o._.tow = seconds_since_gps_epoch - (o._.wno * 7*24*3600)
   elseif is.a(gps_epoch_time_t, wno) then
      local gps_epoch = wno
      local seconds_since_gps_epoch = gps_epoch:gps()
      o._.wno = math.floor(seconds_since_gps_epoch / (7*24*3600))
      o._.tow = seconds_since_gps_epoch - (o._.wno * 7*24*3600)
   elseif
      type(tonumber(wno)) == 'number' and
      type(tonumber(tow)) == 'number'
   then
      o._.wno = tonumber(wno)
      o._.tow = tonumber(tow)
   end

   assert(
      type(o:wno()) == 'number'
      and type(o:tow()) == 'number',
      'gps_time_t('
      .. tostring(wno)
      .. ','
      .. tostring(tow)
      .. '): no conversion'
   )

   setmetatable(o, gps_time_t)

   return o
end

function gps_time_t:wno()
   return self._.wno
end

function gps_time_t:tow()
   return self._.tow
end

function gps_time_t:__add(rhs)
   return gps_time_t(gps_epoch_time_t(self) + rhs)
end

function gps_time_t:__sub(rhs)
   if type(rhs) == 'number' then
      return gps_time_t(gps_epoch_time_t(self) - rhs)
   elseif is.a(gps_time_t, rhs) then
      return gps_epoch_time_t(self) - gps_epoch_time_t(rhs)
   else
      error(
         tostring(self)
         .. ' - '
         .. tostring(rhs)
         .. ': not supported'
      )
   end
end

function gps_time_t:__eq(rhs)
   return is.zero(self:wno() - rhs:wno()) and is.zero(self:tow() - rhs:tow())
end

function gps_time_t:__lt(rhs)
   return gps_epoch_time_t(self) < gps_epoch_time_t(rhs)
end

function gps_time_t:__tostring()
   return
      'gps_time_t('
      .. self:wno()
      .. ','
      .. self:tow()
      .. ')'
end

module('gps_time_t')
