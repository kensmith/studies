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

require('leap_seconds')
require('unix_epoch_time_t')
require('utc_t')
require('gps_epoch_time_t')
require('gps_time_t')

time = {}

local tests = {}

--[[
function tests.technocom_time_to_gps()
   assert(
      tostring(technocom_time_to_gps('2008-08-13T01:12:24-07:00'))
      ==
      tostring(gps_time_t(1492,288758))
   )
end
---Proprietary Technocom time format to local time object.
--@param s string containing Technocom timestamp
--@return equivalent gps_time_t
function time.technocom_time_to_gps(s)
   local timestamp_pattern = '(....)-(..)-(..)T(..):(..):(..)(.)(..):(..)'
   local y,mo,d,h,mn,s,z_dir,z_hr,z_min = s:match(timestamp_pattern)
   faux_utc =
      utc_t(
         tonumber(y),
         tonumber(mo),
         tonumber(d),
         tonumber(h),
         tonumber(mn),
         tonumber(s)
      )

   local zone_diff = tonumber(z_hr) * 3600 + tonumber(z_min) * 60

   if z_dir ~= '-' then
      zone_diff = -zone_diff
   end

   return gps_time_t(faux_utc + zone_diff)
end
--]]

-- GPS epoch time conversions
function tests.gps_epoch_time_t_from_unix_epoch_time_t()
   local g = gps_epoch_time_t(unix_epoch_time_t(1218595384))
   assert(g:gps() == 902630584+14)
end
function tests.gps_epoch_time_t_from_gps_time_t()
   local g = gps_epoch_time_t(gps_time_t(1492, 268984+14))
   assert(g:gps() == 902630584+14)
end
function tests.gps_epoch_time_t_from_utc_t()
   local g = gps_epoch_time_t(utc_t(2008,08,13,2,43,4))
   assert(g:gps() == 902630584+14)
end

-- Unix epoch time conversions
function tests.unix_epoch_time_t_from_gps_epoch_time_t()
   local u = unix_epoch_time_t(gps_epoch_time_t(902630584+14))
   assert(u:unix() == 1218595384)
end
function tests.unix_epoch_time_from_gps_time_t()
   local u = unix_epoch_time_t(gps_time_t(1492, 268984+14))
   assert(u:unix() == 1218595384)
end
function tests.unix_epoch_time_t_from_utc_t()
   local u = unix_epoch_time_t(utc_t(2008,08,13,2,43,4.5))
   assert(u:unix() == 1218595384.5)
end

-- GPS time conversions
function tests.gps_time_t_from_unix_epoch_time_t()
   local g = gps_time_t(unix_epoch_time_t(1218595384))
   assert(g:wno() == 1492 and g:tow() == 268984+14)
end
function tests.gps_time_t_from_utc_t()
   local g = gps_time_t(utc_t(2008,08,13,2,43,4))
   assert(g:wno() == 1492 and g:tow() == 268984+14)
end
function tests.gps_time_t_from_gps_epoch_time_t()
   local g = gps_time_t(gps_epoch_time_t(902630584+14))
   assert(g:wno() == 1492 and g:tow() == 268984+14)
end

-- UTC/Gregorian conversions
function tests.utc_t_from_unix_epoch_time_t()
   local u = utc_t(unix_epoch_time_t(1218595384))
   assert(u:year() == 2008 and u:month() == 8 and u:day() == 13
      and u:hour() == 2 and u:min() == 43 and u:sec() == 4)
end
function tests.utc_t_from_gps_epoch_time_t()
   local u = utc_t(gps_epoch_time_t(902630584+14))
   assert(u:year() == 2008 and u:month() == 8 and u:day() == 13
      and u:hour() == 2 and u:min() == 43 and u:sec() == 4)
end
function tests.utc_t_from_gps_time_t()
   local u = utc_t(gps_time_t(1492, 268984+14))
   assert(u:year() == 2008 and u:month() == 8 and u:day() == 13
      and u:hour() == 2 and u:min() == 43 and u:sec() == 4)
end

if arg and arg[0]:match('.*time.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('time')
