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

require('unix_epoch_time_t')
require('utc_t')

local leap_second_events = {
   unix_epoch_time_t(utc_t(1981,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1982,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1983,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1985,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1987,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1989,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1990,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1992,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1993,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1994,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1995,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1997,6,30,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(1998,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(2005,12,31,23,59,59)):unix(),
   unix_epoch_time_t(utc_t(2008,12,31,23,59,59)):unix(),
}

function leap_seconds_for(date)
   local unix_date = unix_epoch_time_t(date):unix()
   local leap_seconds = 0

   for _,leap_event_unix_time in ipairs(leap_second_events) do
      if unix_date <= leap_event_unix_time then
         break
      end

      leap_seconds = leap_seconds + 1
   end

   return leap_seconds
end
