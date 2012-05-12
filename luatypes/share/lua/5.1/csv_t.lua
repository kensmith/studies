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

---Reads and optionally indexes comma separated value or tab separated value
--spreadsheets.
require('lpeg')
require('is')
require('helpers')

csv_t = {}

setmetatable(csv_t, csv_t)

local tests = {}

function tests.parse()
   local line

   line = csv_t.parse('a,b,c,d,e,,,,')
   assert(#line == 9)
   assert(line[1] == 'a')
   assert(line[2] == 'b')
   assert(line[3] == 'c')
   assert(line[4] == 'd')
   assert(line[5] == 'e')
   assert(line[6] == '')
   assert(line[7] == '')
   assert(line[8] == '')
   assert(line[9] == '')
   assert(line[10] == nil)

   line = csv_t.parse(
      '"Brooklyn - DIn Marriott Hotel, '
      .. 'Adams st E.on Adams, 75 ft into '
      .. 'bldg 2nd flr of high rise",BR04,'
      .. '40.693,-73.98845,'
   )
   assert(
      line[1]
      ==
      'Brooklyn - DIn Marriott Hotel, '
      .. 'Adams st E.on Adams, 75 ft into '
      .. 'bldg 2nd flr of high rise')

   line = csv_t.parse(
      'min	imsi	esn	'
      .. 'mobile_pos_cap	market_id	'
      .. 'switch_num	serving_cell_id	lat_ca	'
      .. 'lon_ca	uncert_ca	confidence_ca	'
      .. 'pos_avail_ca	pos_source_ca	num_meas	'
      .. 'lat_st	lon_st	uncert_st	'
      .. 'pos_avail_st	pos_source_st	pos_req	'
      .. 'gpos_ret_result	gpos_ret_time	'
      .. 'bsa_path	session_start	'
      .. 'session_end	iam_received_timestamp	'
      .. 'hostname')
   assert(line[1] == 'min')
   assert(line[27] == 'hostname')

   line = csv_t.parse(
      '1, "bens-100/0814/lxs.log-1492,397349-9083706024.cmd", 3, '
      .. '397359.0, 1492, 8, 4,'
      .. '378, 19.2, -19.2, 0.8,'
      .. ' -66.0,29, 40.749455, -73.988329, '
      .. '7.3,40.749664, -73.988612,40.749628, '
      .. '-73.988339,40.750220, -73.987365,1000.0, '
      .. '1000.00,378,929,22,'
      .. '3,8,5,1,'
      .. '-5.8,0.0,66.0, 0.0, '
      .. '-5.8,271.8,0.0,271.8,'
      .. '345.0,86.0,1,0,'
      .. '1,55,212.0,40.748991,'
      .. '-73.985972'
   )
   assert(line)
   assert(line[2] == 'bens-100/0814/lxs.log-1492,397349-9083706024.cmd')

   line = csv_t.parse('1,"hi""there",2,3')
   assert(line)
   assert(line[2] == 'hi"there')
end

-- From the LPeg documentation with a minor modification
-- A grammar for a CSV/TSV interpreter
local field =
   lpeg.P(' ')^0
   * '"'
   * lpeg.Cs(((lpeg.P(1) - '"') + lpeg.P('""') / '"')^0)
   * '"'
   * lpeg.P(' ')^0
   + lpeg.C((1 - lpeg.S(',\t\n"'))^0)
local record =
   lpeg.Ct(field * ((lpeg.P(',') + lpeg.P('\t')) * field)^0)
   * (lpeg.P('\n') + -1)

---Parse a CSV/TSV.
--@return an ipairs iteratable list of fields.
function csv_t.parse(line)
   return lpeg.match(record, line)
end

function tests.__call(tmpname)
   local a = csv_t(tmpname)
   assert(is.a(csv_t,a))
   --assert(a.select == nil)
   --assert(a.records ~= nil)

   local b = csv_t(tmpname, 'b')
   assert(is.a(csv_t,b))
   --assert(b.select ~= nil)
   --assert(b.records ~= nil)

   -- can't index on a non-existent column
   local success = pcall(csv_t.__call,csv_t,tmpname,'d')
   assert(not success)
end
---Instantiate a csv_t.  It can open a named file or read from an
--open file object.  Whether the file is read in completely is
--dependent on whether the caller requests indexing (index_column
--nonnil).  The select method is only enabled when the caller
--requests indexing.
--@param file_or_filename an open file, eg io.input(), io.stdin, or
--the name of a file to open.
--@param index_column (optional) a string which names the column or
--a list of strings which name multiple columns or the boolean,
--true, to select all columns to optimize searches for.  select{}ing
--on an indexed column with a constant is a constant time operation.
--select{}ing on an indexed column with a function is O(number of
--unique values in the column).
function csv_t:__call(file_or_filename, index_column)
   assert(
      type(file_or_filename) == 'string'
      or (
         type(file_or_filename) == 'userdata'
         and tostring(file_or_filename):match('^file')
      ),
      'csv_t:__call: file_or_filename is not a string or a file, type is '
      .. type(file_or_filename)
      .. ', value is "'
      .. tostring(file_or_filename)
      .. '"'
   )

   if index_column then
      assert(
         type(index_column) == 'string',
         'csv_t:__call: index_column must be a string, type is '
         .. type(index_column)
         .. ', value is "'
         .. tostring(index_column)
         .. '"'
      )
      index_column = helpers.strip(index_column)
   end

   -- prepare the file handle
   local f
   if type(file_or_filename) == 'string' then
      f = assert(
         io.open(file_or_filename),
         "csv_t:new: can't open .csv file " .. file_or_filename
      )
   else
      f = file_or_filename
   end

   -- prime the data structure
   local o = {
      column = index_column and csv_t.column,
      column_labels = csv_t.column_labels,
      next_record = csv_t.next_record_for_non_indexed,
      num_rows = index_column and csv_t.num_rows,
      render = csv_t.render,
      records = csv_t.records,
      select = index_column and csv_t.select,
      unique = index_column and csv_t.unique,
      _ = {
         file = f,
         columns = {
            reverse = {
               concat = table.concat,
               insert = table.insert,
            },
         },
         index_column = index_column,
         num_rows = 0,
         all_rows = {insert = table.insert},
      },
   }

   -- read the header row
   local line = o._.file:read()
   local found_index_column = false
   if line then
      local labels = csv_t.parse(line)
      for i,label in ipairs(labels) do
         label = helpers.strip(label)
         found_index_column = found_index_column or label == index_column
         o._.columns.reverse:insert(label)
         o._.columns.reverse[label] = true
         o._.columns[label] = {insert = table.insert}
      end
   end

   setmetatable(o, csv_t)

   if index_column then
      assert(found_index_column,
         'csv_t:__call: the chosen index label, "'
         .. index_column
         .. '", does not appear in the header row of this CSV file."'
      )
      -- read and index the .csv
      while o:next_record() do end
      o.next_record = csv_t.next_record_for_indexed
   end

   return o
end

function tests.next_record_for_non_indexed(tmpname)
   local a = csv_t(tmpname)

   local row = a:next_record()
   assert(row.a == 1)
   assert(row.b == 2)
   assert(row.c == 3)

   row = a:next_record()
   assert(row.a == 4)
   assert(row.b == 5)
   assert(row.c == 6)

   row = a:next_record()
   assert(row.a == 7)
   assert(row.b == 8)
   assert(row.c == 9)
end
---Read the next record from the file and return to the caller
--@return a record whose keys are the column headings and whose values
--are the values at the current row for the given column
function csv_t:next_record_for_non_indexed()
   assert(is.a(csv_t,self),
      'csv_t:next_record_for_non_indexed: expected self to be a csv_t, '
      .. 'is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   local line = self._.file:read()
   if not line then
      return nil
   end

   local numbered = csv_t.parse(line)

   if not numbered or #numbered < 1 then
      return nil
   end

   self._.num_rows = self._.num_rows + 1

   local row = {}
   for i,f in ipairs(self._.columns.reverse) do
      row[f] = numbered[i]
      local asnumber = tonumber(row[f])
      if asnumber then
         row[f] = asnumber
      elseif type(row[f]) == 'string' then
         row[f] = helpers.strip(row[f])
      end

      local field = row[f]
      if self._.index_column then
         local column = self._.columns[f]
         column:insert(field)
         if self._.index_column == f then
            column.reverse = column.reverse or {}
            local reverse = column.reverse
            reverse.unique = reverse.unique or {insert = table.insert}
            if not reverse[field] then
               reverse[field] = {insert = table.insert}
               reverse.unique:insert(field)
            end
            reverse[field]:insert(self._.num_rows)
         end
      end
   end

   return row
end

function tests.next_record_for_indexed(tmpname)
   local a = csv_t(tmpname,'b')

   local row = a:next_record()
   assert(row.a == 1)
   assert(row.b == 2)
   assert(row.c == 3)

   row = a:next_record()
   assert(row.a == 4)
   assert(row.b == 5)
   assert(row.c == 6)

   row = a:next_record()
   assert(row.a == 7)
   assert(row.b == 8)
   assert(row.c == 9)

   row = a:next_record()
   assert(row.a == 2)
   assert(row.b == 2)
   assert(row.c == 3)

   row = a:next_record()
   assert(row.a == 4)
   assert(row.b == 5)
   assert(row.c == 6)

   row = a:next_record()
   assert(row.a == 7)
   assert(row.b == 8)
   assert(row.c == 9)

   row = a:next_record()
   assert(row.a == 1)
   assert(row.b == 2)
   assert(row.c == 3)

   row = a:next_record()
   assert(row.a == 4)
   assert(row.b == 5)
   assert(row.c == 6)

   row = a:next_record()
   assert(row.a == 7)
   assert(row.b == 8)
   assert(row.c == 9)

   assert(a:next_record() == nil)

   row = a:next_record()
   assert(row.a == 1)
   assert(row.b == 2)
   assert(row.c == 3)

   row = a:next_record()
   assert(row.a == 4)
   assert(row.b == 5)
   assert(row.c == 6)

   row = a:next_record()
   assert(row.a == 7)
   assert(row.b == 8)
   assert(row.c == 9)
end
function csv_t:next_record_for_indexed()
   assert(is.a(csv_t,self),
      'csv_t:next_record: expected self to be a csv_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   self._.row_cursor = self._.row_cursor or 1

   if self._.row_cursor > self._.num_rows then
      self._.row_cursor = nil -- reset to beginning
      return nil -- signal end
   end

   local record = {}
   for _,label in ipairs(self._.columns.reverse) do
      record[label] = self._.columns[label][self._.row_cursor]
   end
   self._.row_cursor = self._.row_cursor + 1

   return record
end

function tests.records(tmpname)
   local records = {
      {1,2,3},
      {4,5,6},
      {7,8,9},
      {2,2,3},
      {4,5,6},
      {7,8,9},
      {1,2,3},
      {4,5,6},
      {7,8,9}
   }
   local a = csv_t(tmpname)
   local i = 1
   for row in a:records() do
      assert(records[i][1] == row.a, records[i][1] .. ' ~= ' .. row.a)
      assert(records[i][2] == row.b, records[i][2] .. ' ~= ' .. row.b)
      assert(records[i][3] == row.c, records[i][2] .. ' ~= ' .. row.c)
      i = i + 1
   end
   assert(i == 10,'i = ' .. i)
end
---@return an iterator that returns each record in row order
function csv_t:records()
   local function row_iterator()
      return self:next_record()
   end

   return row_iterator
end

function tests.unique(tmpname)
   local a = csv_t(tmpname,'b')
   local uniquea = a:unique('a ')
   local expected_value = {1,4,7,2}
   for i,v in ipairs(uniquea) do
      assert(v == expected_value[i])
   end
   local uniqueb = a:unique('b')
   local expected_value = {2,5,8}
   for i,v in ipairs(uniqueb) do
      assert(v == expected_value[i])
   end

   local success = pcall(a.unique, a, 'd')
   assert(not success)
end
---Only available for indexed csv_t's.  This operation is much faster for the
--index column.
---@return a list of the unique values for the given column.
function csv_t:unique(column_label)
   assert(is.a(csv_t,self),
      'csv_t:next_record: expected self to be a csv_t, is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   assert(type(column_label) == 'string',
      'csv_t:unique: expected column_label to be a string, is a '
      .. type(column_label)
      .. ' with value "'
      .. tostring(column_label)
      .. '"'
   )

   column_label = helpers.strip(column_label)
   assert(self._.columns[column_label],
      'csv_t:unique: the column label, "'
      .. column_label
      .. '", doesn\'t appear in this csv_t. Available column labels: '
      .. self:column_labels():concat(',')
   )

   local unique
   if column_label == self._.index_column then
      local index_column = self._.columns[self._.index_column]
      unique = helpers.copy_table(index_column.reverse.unique)
   else
      unique = {insert = table.insert}
      local reverse = {}
      for i,val in ipairs(self._.columns[column_label]) do
         if not reverse[val] then
            reverse[val] = true
            unique:insert(val)
         end
      end
   end

   unique.insert = nil
   return unique
end

function tests.select(tmpname)
   local a = csv_t(tmpname,'b')
   local results = a:select{a = 1, b = 2}
   local expected_results = {{a=1,b=2,c=3},{a=1,b=2,c=3}}
   for i,record in ipairs(results) do
      for k,v in pairs(record) do
         assert(v == expected_results[i][k])
      end
   end
end
---Retrieve a subset of the rows in the csv_t whose columns
--all satisfy the constraints given in the table where_t.
--@param where_t a table mapping column names to treatments.
--A treatment can be a literal string, literal number or a
--function which takes a the column value and returns true
--if the row is to be included in the result set.  A row is
--included in the result set only if all of the criteria in
--where_t are satisfied.  Including the index column in this
--operation will greatly enhance the performance of the
--search.  Eg. (from our base station almanac csv's) bsa =
--csv_t(bsa_filename, 'CDMATRANSMITPN'); matching_pns =
--bsa:select{CDMATRANSMITPN = 11, SECTORNAME = function(x)
--return not x:match('^LOGICAL') end,};
function csv_t:select(where_t)
   assert(is.a(csv_t,self),
      'csv_t:select: expected self to be a csv_t, it is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )
   assert(type(where_t) == 'table',
      'csv_t:select: expected where_t to be a table, it is a '
      .. type(where_t)
      .. ' with value '
      .. tostring(where_t)
      .. '"'
   )
   local where_t = helpers.copy_table(where_t)

   local index_column_label = self._.index_column
   local rows
   local index_criterion = where_t[index_column_label]
   if index_criterion
      and (
         type(index_criterion) == 'string'
         or type(index_criterion) == 'number'
      )
   then
      -- we have an index and an appropriate criterion, fetch the matching rows
      local index_column = self._.columns[index_column_label]
      rows = helpers.copy_table(index_column.reverse[index_criterion])
      where_t[index_column_label] = nil
   else
      -- grab a list of all the rows
      rows = helpers.copy_table(self._.all_rows)
   end

   for column_label,criterion in pairs(where_t) do
      column_label = helpers.strip(column_label)
      local column = self._.columns[column_label]
      assert(column,
         'csv_t:select: attempted to select on column, "'
         .. column_label
         .. '", which doesn\'t appear in this csv_t.  Available '
         .. 'column labels: '
         .. self:column_labels():concat(',')
      )
      for i,row_num in ipairs(rows) do
         -- eliminate rows when the criterion does not match
         local field = self._.columns[column_label][row_num]
         if type(criterion) == 'string'
            or type(criterion) == 'number'
         then
            if not (field == criterion) then
               rows[i] = nil
            end
         elseif type(criterion) == 'function' then
            if not criterion(field) then
               rows[row_num] = nil
            end
         else
            error('csv_t:select: expected criterion to be a string, number, '
               .. 'or function, is a '
               .. type(criterion)
               .. ' with value, "'
               .. tostring(criterion)
               .. '"'
            )
         end
      end
   end

   -- retrieve and return the matching rows
   local records = {insert = table.insert}
   for _,row in ipairs(rows) do
      local record = {}
      for __,label in ipairs(self._.columns.reverse) do
         record[label] = self._.columns[label][row]
      end
      records:insert(record)
   end
   records.insert = nil

   if #records < 1 then
      return nil
   end

   return records
end

function tests.column_labels(tmpname)
   local a = csv_t(tmpname)
   local column_labels = a:column_labels()
   assert(column_labels:concat(',') == 'a,b,c')

   local expected_column_labels = {'a','b','c'}
   for i,column_label in ipairs(column_labels) do
      assert(column_label == expected_column_labels[i])
   end

   assert(column_labels.a and column_labels.b and column_labels.c)
end
---@return a table containing the column labels.  This table is ipairs
--iteratable and supports random access.  Typical usage is
--csv:column_labels():concat(',') to regenerate the original header row (assuming no
--special characters).
function csv_t:column_labels()
   assert(is.a(csv_t,self),
      'csv_t:select: expected self to be a csv_t, it is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   return helpers.copy_table(self._.columns.reverse)
end

function tests.column(tmpname)
   local a = csv_t(tmpname,'a')
   local column = a:column('a')
   local answer = {1,4,7,2,4,7,1,4,7}
   assert(helpers.tables_equal(answer,column))
end
function csv_t:column(column_name)
   assert(is.a(csv_t,self),
      'csv_t:select: expected self to be a csv_t, it is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )

   column_name = helpers.strip(column_name)
   if not self._.columns[column_name] then
      return nil
   end

   local column = helpers.copy_table(self._.columns[column_name])
   column.insert = nil
   column.reverse = nil
   return column
end

function tests.num_rows(tmpname)
   local a = csv_t(tmpname, 'a')
   assert(a:num_rows() == 9)
end
function csv_t:num_rows()
   assert(is.a(csv_t,self),
      'csv_t:select: expected self to be a csv_t, it is a '
      .. type(self)
      .. ' with value "'
      .. tostring(self)
      .. '"'
   )
   
   return self._.num_rows
end

function tests.escape()
   assert(csv_t.escape('hi') == 'hi')
   assert(csv_t.escape('hi there') == 'hi there')
   assert(csv_t.escape('hi"there') == '"hi""there"')
   assert(csv_t.escape('well, then') == '"well, then"')
end
function csv_t.escape(s)
   if type(s) ~= 'string' then  
      return s
   end
   local smod = s:gsub('"','""')

   if smod:match('.*[,\n\r"].*') then
      return '"' .. smod .. '"'
   end
   return smod
end

function tests.render(tmpname)
   local a = csv_t(tmpname,'a')
   local answer = [[
a,b,c,
1,2,3,
4,5,6,
7,8,9,
2,2,3,
4,5,6,
7,8,9,
1,2,3,
4,5,6,
7,8,9,
]]
   assert(a:render() == answer)
end
---Render the internal representation back to a CSV file.
--If the csv_t object has a member sorted set to true, eg.
--csv = csv_t(f, 'key'); csv.sorted = true, and if the csv is
--index, like in the example, then the rendered CSV file
--will be sorted by the index column.
function csv_t:render()
   if not self._.index_column then
      return 'unindexed csv_t instance'
   end

   local b = {insert = table.insert, concat = table.concat}
   local column_labels = self:column_labels()

   for _,column_label in ipairs(column_labels) do
      b:insert(csv_t.escape(column_label))
      b:insert(',')
   end
   b:insert('\n')
   for i=1,self:num_rows() do
      for _,column_label in ipairs(column_labels) do
         b:insert(csv_t.escape(self._.columns[column_label][i]))
         b:insert(',')
      end
      b:insert('\n')
   end

   return b:concat()
end
--TODO insert a row
--TODO delete a row

if arg and arg[0]:match('.*csv_t.lua') then
   local tmpname = os.tmpname()
   local tmpfile = io.open(tmpname,'w')
   tmpfile:write(
      'a, b,c\n',
      '1,2,3\n',
      '4,5,6\n',
      '7,8,9\n',
      '2,2,3\n',
      '4,5,6\n',
      '7,8,9\n',
      '1,2,3\n',
      '4,5,6\n',
      '7,8,9\n'
   )
   tmpfile:close()

   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest(tmpname)
      io.write('passed\n')
   end

   os.remove(tmpname)
end

module('csv_t')
