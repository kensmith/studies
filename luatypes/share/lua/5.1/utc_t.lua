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

utc_t = {
   unix_epoch_time_precedes_gps_epoch_by_seconds=315964800,
}

setmetatable(utc_t, utc_t)

function utc_t.days_in_month(m)
   
end

function utc_t:__call(
   year, month, day, hour, min, sec
)
   local o = {
      _ = {},
      year = utc_t.year,
      month = utc_t.month,
      day = utc_t.day,
      hour = utc_t.hour,
      min = utc_t.min,
      sec = utc_t.sec,
      is_leap_year = utc_t.is_leap_year,
      days_in_month = utc_t.days_in_month,
      day_of_year = utc_t.day_of_year,
      seconds_into_year = utc_t.seconds_into_year,
      seconds_into_day = utc_t.seconds_into_day,
   }

   if is.a(gps_time_t, year) then
      local gps = year
      o._ = os.date('!*t', unix_epoch_time_t(gps):unix())
   elseif is.a(unix_epoch_time_t, year) then
      local unix_time = year
      o._ = os.date('!*t', unix_time:unix())
   elseif is.a(gps_epoch_time_t, year) then
      local gps_epoch = year
      o._ = os.date('!*t', unix_epoch_time_t(gps_epoch):unix())
   elseif
      type(year) == 'number'
      and type(month) == 'number'
      and type(day) == 'number'
      and type(hour) == 'number'
      and type(min) == 'number'
      and type(sec) == 'number'
   then
      o._.year = year
      o._.month = month
      o._.day = day
      o._.hour = hour
      o._.min = min
      o._.sec = sec
   end

   setmetatable(o, utc_t)

   assert(
      type(o:year()) == 'number'
      and type(o:month()) == 'number'
      and type(o:day()) == 'number'
      and type(o:hour()) == 'number'
      and type(o:min()) == 'number'
      and type(o:sec()) == 'number'
      and 1 <= o:month() and o:month() <= 12
      and 1 <= o:day() and o:day() <= o:days_in_month()
      and 0 <= o:hour() and o:hour() <= 23
      and 0 <= o:min() and o:min() <= 59
      and 0 <= o:sec() and o:sec() < 60
      ,
      'utc_t(): no conversion for '
      .. tostring(year)
      .. ','
      .. tostring(month)
      .. ','
      .. tostring(day)
      .. ','
      .. tostring(hour)
      .. ','
      .. tostring(min)
      .. ','
      .. tostring(sec)
   )

   local localtime = os.date('*t')
   localtime.isdst = false
   local utc = os.date('!*t')
   local localtime_seconds = os.time(localtime)
   local utc_seconds = os.time(utc)
   o._.offset_from_local_time_seconds =
      localtime_seconds - utc_seconds

   return o
end

function utc_t:year()
   return self._.year
end

function utc_t:month()
   return self._.month
end

function utc_t:day()
   return self._.day
end

function utc_t:hour()
   return self._.hour
end

function utc_t:min()
   return self._.min
end

function utc_t:sec()
   return self._.sec
end

function utc_t:is_leap_year()
   local _,remainder = math.modf(self:year() / 4)
   local _,century_remainder = math.modf(self:year() / 100)
   local _,four_century_remainder = math.modf(self:year() / 400)

   return
      is.zero(remainder)
      and (
         not is.zero(century_remainder)
         or is.zero(four_century_remainder)
      )
end

function utc_t:days_in_month()
   local days_in_month = ({
      [1] = 31,
      [2] = 28,
      [3] = 31,
      [4] = 30,
      [5] = 31,
      [6] = 30,
      [7] = 31,
      [8] = 31,
      [9] = 30,
      [10] = 31,
      [11] = 30,
      [12] = 31
   })[self:month()]

   if self:month() == 2 and self:is_leap_year() then
      days_in_month = days_in_month + 1
   end

   return days_in_month
end

function utc_t:day_of_year()
   local day_of_year = ({
      0,
      31,
      59,
      90,
      120,
      151,
      181,
      212,
      243,
      273,
      304,
      334
   })[self:month()] + self:day()

   if self:month() > 2 and self:is_leap_year() then
      day_of_year = day_of_year + 1
   end

   return day_of_year
end

function utc_t:seconds_into_day()
print(
      self:hour() * 3600
      + self:min() * 60
      + self:sec()
)
   return
      self:hour() * 3600
      + self:min() * 60
      + self:sec()
end

function utc_t:seconds_into_year()
   return
      (self:day_of_year() - 1) * 24 * 3600
      + self:seconds_into_day()
end

function utc_t:__add(rhs)
   assert(type(rhs) == 'number',
      tostring(self)
      .. ' + '
      .. tostring(rhs)
      .. ': not supported'
   )

   local u =
      os.date(
         '!*t',
         os.time(self._)
            + self._.offset_from_local_time_seconds
            + rhs
      )

   return utc_t(u.year, u.month, u.day, u.hour, u.min, u.sec)
end

--@return seconds between times
function utc_t:__sub(rhs)
   assert(is.a(utc_t, rhs),
      tostring(self)
      .. ' - '
      .. tostring(rhs)
      .. ': rhs must be a utc_t'
   )
   -- TODO make this more robust
   local extra_hour = 3600 -- don't know yet why this is necessary TODO fix
   local _,subsecs = math.modf(self:sec() + 60 - rhs:sec())
   return extra_hour + os.time(self._) - os.time(rhs._) + subsecs
--[[

   local lhs_sec_into_year = self:seconds_into_year()
print('lhs_sec_into_year = ' .. lhs_sec_into_year)
   local rhs_sec_into_year = rhs:seconds_into_year()
print('rhs_sec_into_year = ' .. rhs_sec_into_year)

   lesser = rhs
   greater = 
   if self:year() < rhs:year()
      or (
         self:year() == rhs:year()
         and lhs_sec_into_year < rhs_sec_into_year
      )
   then
      lesser = self
      
   end

   return 0
--]]
end

function utc_t:__tostring()
   return
      string.format(
         'utc_t(%04d.%02d.%02d %02d:%02d:%09.6f)',
         tostring(self:year()),
         tostring(self:month()),
         tostring(self:day()),
         tostring(self:hour()),
         tostring(self:min()),
         tostring(self:sec())
      )
end
