local base = _G
local math = base.math
local table = base.table
local string = base.string

module('util')

-- set this to your system's path separator, if any
path_sep = '/'


-- recursively print a table
function print_table(t, name)
   if (t == nil) then
      t = {}
   end
   
   if (name == nil) then
      name = 't'
   end

   base.assert(base.type(t) == 'table')
   base.assert(base.type(name) == 'string')
   
   for k,v in base.pairs(t) do
      if (base.type(v) == 'table') then
         print_table(v, name .. '.' .. base.tostring(k))
      else
         base.print(name .. '.' .. base.tostring(k) .. ' = ' .. base.tostring(v))
      end
   end
end

-- nonrecursively print a module
function print_module(t, name)
   base.assert(base.type(t) == 'table')

   if not name then
      if t._NAME then
         name = t._NAME
      else
         name = 'module'
      end
   end
   
   for k,v in base.pairs(t) do
      base.print(name .. '.' .. base.tostring(k) .. ' = ' .. base.tostring(v))
   end
end

--[[   test print_table
t = {1,2,3,{4,5,6,{7,8,9}},hi='hello'}
print_table(t)
print_table(t, 'some_table')
--]]


-- true if left and right are dissimilar boolean values
function logical_xor(left, right)

   base.assert(base.type(left) == 'boolean')
   
   base.assert(base.type(right) == 'boolean')


   return (left and not right) or (right and not left)
   
end

--[[   test logical_xor
base.print(base.tostring(logical_xor(false, false)))
base.print(base.tostring(logical_xor(false, true)))
base.print(base.tostring(logical_xor(true, false)))
base.print(base.tostring(logical_xor(true, true)))
--]]


-- returns a list of numbers (timestamps) from sorted list left
-- which are inclusively bracketed in sorted list right
--
-- eg. find_time_overlap({1,2,3,4,5,6,8,9,10,11,12},{3,4,5,6,7,8,9,10})
--     -> {3,4,5,6,8,9,10}
--
-- eg. find_time_overlap({1,2,3,4,5,6,8,9},{3,4,5,6,7,8,9,10})
--     -> {3,4,5,6,8,9}
--
-- eg. find_time_overlap({3,4,5,6,8,9,10,11,12},{1,2,3,4,5,6,7,8,10,11,12,13})
--     -> {3,4,5,6,7,8,10,11,12}
function find_time_overlap(left, right)

   base.assert(base.type(left) == 'table')

   base.assert(base.type(right) == 'table')


   min_right = right[1]

   max_right = right[#right]


   retval_list = {}

   retval_count = 0


   for i,v in base.ipairs(left) do

      if min_right == nil then return {}, 0 end

      if max_right == nil then return {}, 0 end

      if (min_right <= v and v <= max_right) then

         table.insert(retval_list,v)

         retval_count = retval_count + 1

      end

   end


   return retval_list, retval_count

end

--[[ test find_time_overlap
times1 = {1,2,3,4,5,6,8}
times2 = {3,4,5,6,7,8,9,10}
base.print(base.unpack(find_time_overlap(times1, times2)))
--]]



-- Adapted from similarly named function from runca.
--
-- Returns y for x where (x1,y1) and (x2,y2) are points on a line.
function interpolate(x1, y1, x2, y2, x)

   base.assert(base.type(x1) == 'number')
   base.assert(base.type(y1) == 'number')
   base.assert(base.type(x2) == 'number')
   base.assert(base.type(y2) == 'number')
   base.assert(base.type(x) == 'number')

   base.assert(x2 ~= x1)

   local y = y1 + (y2 - y1) * (x - x1) / ( x2 - x1)

   return y

end

--[[
for i=0,1,0.1 do
   base.print(interpolate(1,1,2,2,i))
end

base.print('')

for i=0,1,0.1 do
   base.print(interpolate(0,0,2,4,i))
end
--]]



function delta_velocity(v1, v0)

   local dv = {}


   dv.delta_north = v1.north - v0.north

   dv.delta_east = v1.east - v0.east

   dv.delta_magnitude = v1.magnitude - v0.magnitude

   dv.valid = v1.valid and v0.valid

   dv.truth = v0.magnitude


   return dv

end

--[[
v1 =              
{                       
   north = 0.899102,    
   east = -0.142404,    
   magnitude = 0.910310,
   valid = true,        
}

v0 =
{
   north = 0.123456,
   east = 0.123456,
   magnitude = (2*0.123456^2)^0.5,
   valid = true,
}

print_table(delta_velocity(v1,v0))
--]]


-- Adapted from similarly named function from runca.
--
-- Translated to Lua from CmpNMEA::main.cpp::DeltaPosition.
--
-- Latitude and longitude are expected in degrees and converted to radians.
--[[
function delta_position(p1, p0)

   rad_lat1 = math.rad(p1.lat)

   rad_lon1 = math.rad(p1.lon)

   rad_lat0 = math.rad(p0.lat)

   rad_lon0 = math.rad(p0.lon)

   local ro = (native.SEMI_MAJOR_AXIS^2 * math.cos(rad_lat0)^2 +
      native.SEMI_MINOR_AXIS^2 * math.sin(rad_lat0)^2)^0.5

   local r = ro * math.cos(rad_lat0)


   local dp = {}

   dp.delta_north = (rad_lat1 - rad_lat0)*ro;

   dp.delta_east = (rad_lon1 - rad_lon0)*r;


   if (p1.alt_valid and p0.alt_valid) then

      dp.delta_alt = p1.alt - p0.alt

   end


   dp.delta_horiz = (dp.delta_north^2 + dp.delta_east^2)^0.5

   if dp.delta_alt then
   
      dp.delta = (dp.delta_north^2 + dp.delta_east^2 + dp.delta_alt^2)^0.5

   else

      dp.delta = (dp.delta_north^2 + dp.delta_east^2)^0.5

   end

   return dp

end
--]]

--[[
p1 = -- from data file
{                    
   lat = 33.824648,  
   lon = -118.103462,
   valid = true,     
   alt = 8.843269,   
   alt_valid = true, 
   hepe = 53.186642, 
}

p0 = -- from truth file
{
   lat = 33.824537,
   lon = -118.103432,
   alt = -15.100000,
   alt_valid = true,
   valid = true,
}

print_table(delta_position(p1,p0),'delta_position')
--]]


-- convert a time from unix epoch based to gps based
function unix_to_gps(unixtime)

   local seconds_per_day = 86400

   local days_between_unix_gps_start = 10 * 365 + 5 + 2

   local total_days = unixtime / seconds_per_day - days_between_unix_gps_start

   local seconds_into_day = unixtime % seconds_per_day

   local gps_week = math.floor(total_days / 7)

   local day_of_week = math.floor(total_days - 7*gps_week)

   local gps_seconds = day_of_week * seconds_per_day + seconds_into_day


   return gps_week, gps_seconds

end

--[[
base.print(unix_to_gps(1118430653.5))
--]]



-- Returns true if left and right are very close to equal.  By default,
--
-- numbers  in Lua are double precision floating point and cannot be
function numbers_equal(left, right)

   base.assert(base.type(left) == 'number')

   base.assert(base.type(right) == 'number')


   local epsilon = 0.0000000001


   if (math.abs(left - right) < epsilon) then

      return true

   end

   return false

end


-- General purpose binary search of sorted numbers in a list (traversable with
--
-- ipairs).  Call without setting left, center, or right to search the whole
--
-- list.  As a bonus, the second argument, which can be ignored, is the second
--
-- nearest index.  Sort this list to get a pair which brackets the value.
function binary_find_nearest(val, list, left, center, right)


   base.assert(base.type(list) == 'table')

   base.assert(#list > 0)

   base.assert(base.type(list[1]) == 'number')

   base.assert(base.type(val) == 'number')

   base.assert(base.type(left) == 'nil' or base.type(left) == 'number')

   base.assert(base.type(center) == 'nil' or base.type(center) == 'number')

   base.assert(base.type(right) == 'nil' or base.type(right) == 'number')



   if (left == nil) then   left = 1   end

   if (right == nil) then   right = #list   end

   if (center == nil) then   center = math.floor( (right - left) / 2 )   end


   if (val < list[left]) then   return left   end


   if ( (right - left) == 1) then

      local delta_right = math.abs(list[right]-val)

      local delta_left = math.abs(list[left]-val)

      if (delta_left <= delta_right) then

         return left, right

      else

         return right, left

      end
   end


   if (list[right] < val) then   return right   end


   if ( numbers_equal(val, list[center])) then

      return center

   end


   local new_left = left

   local new_right = right


   if (val > list[center]) then

      new_left = center

   end


   if (val < list[center]) then

      new_right = center

   end


   local new_center = math.floor((new_right + new_left) / 2)

   return binary_find_nearest(val, list, new_left, new_center, new_right)

end



-- Find the three closest timestamps for a given unix time.
function bracket_timestamp3(timestamp, times)


   base.assert(base.type(timestamp) == 'number')

   base.assert(base.type(times) == 'table')


   local nearest = binary_find_nearest(timestamp, times)


   local t1, t2, t3 = nil, nil, nil

   if (times[nearest] ~= nil) then   t2 = times[nearest]   end

   if (nearest > 1 and times[nearest-1]) then   t1 = times[nearest-1]   end

   if (nearest < #times and times[nearest+1]) then   t3 = times[nearest+1]   end


   return t1, t2, t3

end

--[[
base.print(bracket_timestamp3(9.5, {7,8,9,10,11}))
--]]



-- Find the two closest timestamps for a given unix time.
function bracket_timestamp2(timestamp, times)

   base.assert(base.type(timestamp) == 'number')

   base.assert(base.type(times) == 'table')


   local t_idxs = {binary_find_nearest(timestamp, times)}


   if (#t_idxs ~= 2) then

      return nil

   end


   table.sort(t_idxs)


   return times[t_idxs[1]], times[t_idxs[2]]

end



-- Given a timestamp and truth table, find the truth which most closely matches
--
-- timestamp, interpolating if necessary.
function interpolate_truth(timestamp, truth_data)

   
   local t_left, t_right = bracket_timestamp2(timestamp, truth_data.timestamps)


   if (t_left == nil or t_right == nil) then

      return nil

   end


   local truth_left = truth_data[t_left]
   local truth_right = truth_data[t_right]


   local truth_interp = {}


   truth_interp.time = {}

   truth_interp.time.unix = timestamp


   local gps_week, gps_seconds = unix_to_gps(timestamp)



   truth_interp.time.gps_week = gps_week

   truth_interp.time.gps_seconds = gps_seconds



   truth_interp.position = {}

   for i,v in base.ipairs({'lat', 'lon', 'alt'}) do

      truth_interp.position[v] =
         interpolate(
            t_left, truth_left.position[v],
            t_right, truth_right.position[v],
            timestamp
         )

   end

   truth_interp.position.valid =
      truth_left.position.valid or truth_right.position.valid
      
   truth_interp.position.alt_valid =
      truth_left.position.alt_valid or truth_right.position.alt_valid



   truth_interp.velocity = {}

   for i,v in base.ipairs({'north','east','magnitude'}) do

      truth_interp.velocity[v] =
         interpolate(
            t_left, truth_left.velocity[v],
            t_right, truth_right.velocity[v],
            timestamp
         )

   end

   truth_interp.valid = truth_left.valid or truth_right.valid


   return truth_interp

end

--[[
truth =
{  
   timestamps = {1118430653.000000,1118430654.000000},
   [1118430653.000000] =
   {  
      time =
      {  
         gps_week = 1326,
         gps_seconds = 501053.000000,
         unix = 1118430653.000000,
      },
      lat = 33.825392,
      lon = -118.103215,
      alt = -17.900000,
      alt_valid = true,
      vN = 1.256217,
      vE = 0.965672,
      speed = 1.584489,
      valid = true,
   },
   [1118430654.000000] =
   {  
      time =
      {  
         gps_week = 1326,
         gps_seconds = 501054.000000,
         unix = 1118430654.000000,
      },
      lat = 33.825402,
      lon = -118.103205,
      alt = -18.300000,
      alt_valid = true,
      vN = 1.017977,
      vE = 0.843641,
      speed = 1.322122,
      valid = true,
   },
}

for t=1118430653,1118430654,0.125 do
   print_table(truth[1118430653])
   base.print('')
   print_table(interpolate_truth(t, truth))
   base.print('')
   print_table(truth[1118430654])
base.print('')
base.print('')
base.print('')
end

--]]


-- Given a data point from a successful nav from Kevin's filter, generate a
--
-- table whose elements describe the physical distance to an observed truth.
function delta_truth(data_point, truth_data)

   base.assert(base.type(data_point) == 'table')

   base.assert(base.type(truth_data) == 'table')


   interpolated_truth = interpolate_truth(data_point.time.unix, truth_data)

   if (interpolated_truth == nil) then

      return nil

   end


   local dp = {}

   dp.position =
      delta_position(
         data_point.position,
         interpolated_truth.position
      )

   dp.velocity =
      delta_velocity(
         data_point.velocity,
         interpolated_truth.velocity
      )

   return dp, interpolated_truth
end



-- helper function for exported path_sep function
local function path_join_for_path_sep(sep)
   local local_path_sep = sep
   local final_path_sep_pattern = local_path_sep .. '$'
   local initial_path_sep_pattern = '^' .. local_path_sep
   return function (lhs, rhs)
      base.assert(lhs or rhs)
      base.assert(base.type(lhs) == 'string' or base.type(rhs) == 'string')
      if not lhs or lhs == '' then return rhs end
      if not rhs or rhs == '' then return lhs end
      return string.gsub(lhs, final_path_sep_pattern, '')
         .. local_path_sep .. string.gsub(rhs, initial_path_sep_pattern, '')
   end
end

-- Joins two paths together using the system path separator as defined
--
-- by the global (to this module) variable path_sep
path_join = path_join_for_path_sep(path_sep)


-- Average the numeric arguments
--
-- Also accepts a single ipairs traversable list of numbers
function avg(...)
   local args = {...}


   if base.type(args[1]) == 'table' then

      args = args[1]

   end


   local sum = 0
   local total = 0

   for i,v in base.ipairs(args) do
   
      if base.type(v) ~= 'number' then

         base.error('Expected a list of numbers or strictly numeric arguments',
            2)

      end

      sum = sum + v

      total = total + 1

   end

   return sum / total

end

-- Compute the standard deviation for the numeric arguments
--
-- Also accepts a single ipairs traversable list of numbers
--
-- avg is the arithmetic mean as computed by util.avg()
function stddev(avg, ...)

   base.assert(base.type(avg) == 'number')

   local args = {...}


   if base.type(args[1]) == 'table' then

      args = args[1]

   end


   local sum = 0
   local total = 0

   for i,v in base.ipairs(args) do
   
      if base.type(v) ~= 'number' then

         base.error('Expected a list of numbers or strictly numeric arguments',
            2)

      end

      sum = sum + (v - avg)^2

      total = total + 1

   end

   return (sum / (total - 1))^0.5

end

-- Drop-in replacement for the builtin math.max but can handle a single
--
-- ipairs traversable table as well.
function max(...)

   local args = {...}


   if base.type(args[1]) == 'table' then

      args = args[1]

   end


   local max = -math.huge

   for i,v in base.ipairs(args) do
   
      if base.type(v) ~= 'number' then

         base.error('Expected a list of numbers or strictly numeric arguments',
            2)

      end

      if v > max then max = v end

   end

   return max

end
