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

unix_epoch_time_t = {
   seconds_per_week=7*24*3600,
   unix_epoch_time_precedes_gps_epoch_by_seconds=315964800,
}

setmetatable(unix_epoch_time_t, unix_epoch_time_t)

-- The tests are implemented in time_t.lua.  The various time classes are
-- mutually dependent and 'require' doesn't allow mutual inclusion so we
-- need a third party that can 'require' all the classes to test their
-- interactions.

---Instantiate a unix_epoch_time_t.
--@param epoch seconds since the unix epoch.
--@return a unix_epoch_time_t instance.
function unix_epoch_time_t:__call(val)
   local o = {
      _ = {},
      unix = unix_epoch_time_t.unix,
   }

   if is.a(gps_time_t, val) then
      local gps_time = val
      o._.epoch =
         gps_time:wno() * self.seconds_per_week
         + gps_time:tow()
         + self.unix_epoch_time_precedes_gps_epoch_by_seconds

      local leap_seconds = leap_seconds_for(o._.epoch)
      o._.epoch = o._.epoch - leap_seconds
      local confirm_leap_seconds = leap_seconds_for(o._.epoch)
      if leap_seconds ~= confirm_leap_seconds then
         o._.epoch = o._.epoch + 1
      end
   elseif is.a(gps_epoch_time_t, val) then
      local gps_epoch = val
      o._.epoch =
         gps_epoch:gps()
         + unix_epoch_time_t.unix_epoch_time_precedes_gps_epoch_by_seconds

      local leap_seconds = leap_seconds_for(o._.epoch)
      o._.epoch = o._.epoch - leap_seconds
      local confirm_leap_seconds = leap_seconds_for(o._.epoch)
      if leap_seconds ~= confirm_leap_seconds then
         o._.epoch = o._.epoch + 1
      end
   elseif is.a(utc_t, val) then
      local utc = val
      o._.epoch = utc - utc_t(1970,1,1,0,0,0)
   elseif is.a(unix_epoch_time_t, val) then
      return val
   elseif type(val) == 'number' then
      o._.epoch = val
   end

   assert(
      o._.epoch,
      'unix_epoch_time_t('
      .. tostring(val)
      .. '): no conversion'
   )

   setmetatable(o, unix_epoch_time_t)

   return o
end

function unix_epoch_time_t:unix()
   return self._.epoch
end

function unix_epoch_time_t:__tostring()
   return
      string.format(
         'unix_epoch_time_t(%09.6f)',
         self:unix()
      )
end

module('unix_epoch_time_t')
