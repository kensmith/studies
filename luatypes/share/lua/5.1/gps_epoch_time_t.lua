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

gps_epoch_time_t = {
   unix_epoch_time_precedes_gps_epoch_by_seconds=315964800,
}

setmetatable(gps_epoch_time_t, gps_epoch_time_t)

function gps_epoch_time_t:__call(val)
   local o = {
      _ = {},
      gps = gps_epoch_time_t.gps,
   }

   if is.a(unix_epoch_time_t, val) then
      local unix_epoch = val
      o._.epoch =
         unix_epoch:unix()
         - gps_epoch_time_t.unix_epoch_time_precedes_gps_epoch_by_seconds
         + leap_seconds_for(unix_epoch)
   elseif is.a(gps_time_t, val) then
      local gps_time = val
      o._.epoch = gps_time:wno() * (7*24*3600) + gps_time:tow()
   elseif is.a(utc_t, val) then
      local utc = val
      o._.epoch = utc - utc(1980,1,6,0,0,0) + leap_seconds_for(utc)
   elseif type(val) == 'number' then
      o._.epoch = val
   end

   setmetatable(o, gps_epoch_time_t)

   assert(
      o._.epoch,
      'gps_epoch_time_t('
      .. tostring(val)
      .. '): no conversion'
   )

   return o
end

function gps_epoch_time_t:gps()
   return self._.epoch
end

function gps_epoch_time_t:__tostring()
   return
      'gps_epoch_time_t('
      .. tostring(self:gps())
      .. ')'
end

function gps_epoch_time_t:__add(rhs)
   assert(type(rhs) == 'number',
      tostring(self)
      .. ' + '
      .. tostring(rhs)
      .. ': not supported'
   )
   
   return gps_epoch_time_t(self:gps() + rhs)
end

function gps_epoch_time_t:__sub(rhs)
   if type(rhs) == 'number' then
      return gps_epoch_time_t(self:gps() - rhs)
   elseif is.a(gps_epoch_time_t, rhs) then
      return self:gps() - rhs:gps()
   else
      error(
         tostring(self)
         .. ' - '
         .. tostring(rhs)
         .. ': not supported'
      )
   end
end

function gps_epoch_time_t:__eq(rhs)
   return is.zero(self:gps() - rhs:gps())
end

function gps_epoch_time_t:__lt(rhs)
   assert(is.a(gps_epoch_time_t, rhs),
      'gps_epoch_time_t:__lt(rhs): expected a gps_epoch_time_t for rhs, '
      .. 'rhs is a "' .. type(rhs) .. '"'
   )

   return self:gps() < rhs:gps()
end

module('gps_epoch_time_t')
