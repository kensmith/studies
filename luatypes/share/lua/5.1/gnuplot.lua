--[[
Lua interface to Gnuplot inspired deeply by N. Devillard's C interface
to gnuplot, 'gnuplot_i.c'.
Copyright Ken Smith 2006
--]]

local base = _G

module('gnuplot')

Gnuplot = {

   --
   -- constructors
   --

   new = function (self)
      local instance = {}
      base.setmetatable(instance, self)
      self.__index = self

      instance:init(plot_title, debug)

      return instance
   end,

   --
   -- startup and shutdown
   --

   -- open the gnuplot executable via a pipe and set defaults
   init = function (self)
      self.gp = base.io.popen("/usr/bin/gnuplot", "w")
      self.style = self.valid_styles.default
      self.nplots = 0
      if (self.tmpfiles and base.type(self.tmpfiles) == "table") then
         for i,v in base.ipairs(self.tmpfiles) do
            base.os.remove(v)
         end
      end
      self.tmpfiles = {}
   end,

   -- shut down the pipe if necessary
   stop = function (self)
      if (self.gp) then
         self.gp:close()
         self.gp = nil
      end
      if (self.tmpfiles and base.type(self.tmpfiles) == "table") then
         for i,v in base.ipairs(self.tmpfiles) do
            base.os.remove(v)
         end
      end
   end,

   --
   -- state manipulation
   --

   -- set the style for plot
   set_style = function (self, s)
      local new_style = nil
      for i,v in base.ipairs(self.valid_styles) do
         if (v == s) then
            new_style = s
            break
         end
      end
      if (new_style) then
         self.style = new_style
      else
         local all_valid_styles = ""
         for i,v in base.ipairs(self.valid_styles) do
            all_valid_styles = all_valid_styles .. v .. " "
         end
         self:my_assert(false,": Unrecognized style, \"" .. base.tostring(s)
               .. "\". Valid values are " .. all_valid_styles)
      end
   end,


   --
   -- Gnuplot wrappers
   --

   -- set grid
   set_grid = function (self, attributes)
      local grid_cmd = 'set grid'

      if (base.type(attributes) == 'table') then
         for i,v in base.ipairs(attributes) do
            grid_cmd = grid_cmd .. ' ' .. base.tostring(v)
         end
      end

      self:run(grid_cmd)
   end,

   set_title = function (self, title)
     self:run('set title "' .. base.tostring(title) .. '"')
   end,

   -- set term
   set_term = function (self, term_type, attributes)
      local term_cmd = 'set terminal ' .. base.tostring(term_type)

      if (base.type(attributes)) then

         for i,v in base.ipairs(attributes) do

            term_cmd = term_cmd .. ' ' .. base.tostring(v)

         end

      end

      self:run(term_cmd)
   end,

   -- set xlabel
   set_xlabel = function (self, label)
      self:run("set xlabel \"" .. base.tostring(label) .. "\"")
   end,


   -- set ylabel
   set_ylabel = function (self, label)
      self:run("set ylabel \"" .. base.tostring(label) .. "\"")
   end,


   -- set zlabel
   set_zlabel = function (self, label)
      self:run("set zlabel \"" .. base.tostring(label) .. "\"")
   end,


   -- plot 2d graph from a table of indexed doubles
   plot_x = function (self, d, label)
      -- write data to tmpfile
      local tmpfname, tmpf = self:mktemp()
      for i,v in base.ipairs(d) do
         tmpf:write(base.tostring(v) .. "\n")
      end
      tmpf:close()

      local tmpcmd =
         self:plot_or_replot()
         .. "\"" .. tmpfname .. "\" "
         .. self:affix_label(label)
         .. "with " .. self.style

      self:run(tmpcmd)

      self.nplots = self.nplots + 1
   end,


   -- plot 2d graph from a table of (x,y) pairs
   plot_xy = function (self, d, label)
      local tmpfname, tmpf = self:mktemp()
      for i,point in base.ipairs(d) do
         tmpf:write(base.tostring(point[1]) .. " "
            .. base.tostring(point[2]) .. "\n")
      end
      tmpf:close()

      local tmpcmd =
         self:plot_or_replot()
         .. "\"" .. tmpfname .. "\" "
         .. self:affix_label(label)
         .. "with " .. self.style

      self:run(tmpcmd)

      self.nplots = self.nplots + 1
   end,


   -- plot 3d graph from a table of (x,y,z) triplets
   plot_xyz = function (self, d, label)
      local tmpfname, tmpf = self:mktemp()

      local is_grid = false
      local grid_cnt = 0
      if (d.grid and base.type(d.grid) == "number") then
         is_grid = true
      end

      for i,point in base.ipairs(d) do
         tmpf:write(base.tostring(point[1]) .. " "
            .. base.tostring(point[2]) .. " "
            .. base.tostring(point[3]) .. "\n")
         if (is_grid) then
            grid_cnt = grid_cnt + 1
            if (grid_cnt >= d.grid) then
               tmpf:write("\n")
               grid_cnt = 0
            end
         end
      end

      tmpf:close()

      local tmpcmd =
         "splot \"" .. tmpfname .. "\" "
         .. self:affix_label(label)
         .. "with " .. self.style

      self:run(tmpcmd)

      self.nplots = self.nplots + 1
   end,
      

   -- plot an equation
   plot_eq = function (self, f, label)
      local tmpcmd =
         self:plot_or_replot()
         .. " " .. f .. " "
         .. self:affix_label(label)
         .. "with " .. self.style

      self:run(tmpcmd)

      self.nplots = self.nplots + 1
   end,


   -- tries to determine the type of plot from examination of the input d
   plot = function (self, d, label)
      if (base.type(d) == "string") then
         self:plot_eq(d, label)
      elseif (base.type(d) == "table") then
         if (base.table.maxn(d) > 0) then
            if (base.type(d[1]) == "string") then
               -- table of functions
               for i,v in base.ipairs(d) do
                  self:my_assert(base.type(v) == "string", "Input function table "
                                 .. "must contain only functions.")
                  self:plot_eq(v, label)
               end
            elseif (base.type(d[1]) == "number") then
               -- table of values
               for i,v in base.ipairs(d) do
                  self:my_assert(base.type(v) == "number", "Input data must "
                                 .. "be uniform.  The first entry is a number "
                                 .. "so all entries must be numbers.")
               end
               self:plot_x(d, label)
            elseif (base.type(d[1]) == "table") then
               -- table of points, most likely
               local dim = base.table.maxn(d[1])
               self:my_assert(dim >= 1, "Input points must all have "
                              .. "values.")
               self:my_assert(dim <= 3, "Input points must be plottable in "
                              .. "at most 3 dimensions.")
               for i,v in base.ipairs(d) do
                  self:my_assert(base.type(v) == "table", "Input data must be "
                                 .. "uniform.  The first entry was a table "
                                 .. "so all entries must be tables.")
                  self:my_assert(base.table.maxn(v) == dim, "Input data must be "
                                 .. "uniform.  The first entry defines values "
                                 .. "for " .. base.tostring(dim) .. " axes so all "
                                 .. "entries must do likewise.  "
                                 .. "Bad data defined values for "
                                 .. base.table.maxn(v)
                                 .. " axes.")
               end
               if (dim == 1) then
                  local collapsed_d = {}
                  for i,v in base.ipairs(d) do
                     base.table.insert(collapsed_d, v)
                  end
                  self:plot_x(collapsed_d, label)
               elseif (dim == 2) then
                  self:plot_xy(d, label)
               elseif (dim == 3) then
                  self:plot_xyz(d, label)
               else
                  self:my_assert(false, "How did that happen? dim = "
                                 .. tostring(dim))
               end
            else
               self:my_assert(false, "Can't plot tables of " .. base.type(d[1]))
            end
         else
            self:my_assert(false, "Can't plot tables of empty tables")
         end
      else
         self:my_assert(false, "Can't plot " .. base.type(d))
      end
   end,

   --
   -- Utility methods
   --

   affix_label = function (self, label)
      local labelcmd = ""
      if (label and base.type(label) == "string" and label ~= "") then
         labelcmd = "title \"" .. label .. "\" "
      end
      return labelcmd
   end,

   -- to plot or to replot
   plot_or_replot = function (self)
      local tmpcmd = ""
      if (self.nplots > 0) then
         tmpcmd = "replot "
      else
         tmpcmd = "plot "
      end
      return tmpcmd
   end,

   -- create a temporary file
   mktemp = function (self)
      self:my_assert(self.gp, "Call init() method first.")
      local tmpfname = base.os.tmpname()
      base.assert(tmpfname and tmpfname ~= "", "Couldn't name temporary file.")
      local tmpf = base.io.open(tmpfname, "w")

      -- record filename for future deletion
      base.table.insert(self.tmpfiles, tmpfname)
      return tmpfname, tmpf
   end,

   -- sends a raw command to gnuplot
   run = function (self, c)
      self:my_assert(self.gp, "Call init() method first.")
      self.gp:write(base.tostring(c) .. "\n")
   end,

   -- print this instance
   print = function (self, name)
      local function print_helper(label, t)
         for k,v in base.pairs(t) do
            if (base.type(v) == "table") then
               print_helper(label .. "." .. base.tostring(k), t[k])
            else
               print(label .. "." .. base.tostring(k), base.tostring(v))
            end
         end
      end
      if (not name) then
         name = base.tostring(self)
      end
      print_helper(name, self)
   end,

   -- wraps assert with our own brand
   my_assert = function (self, cond, msg)
      base.assert(cond, "\n\n" .. self.banner .. ": " .. msg .. "\n\n"
             .. base.debug.traceback())
   end,


   --
   -- basic state variables
   --

   -- precedes all errors to plainly identify the source
   banner = "Gnuplot",

   -- update this with 
   valid_styles = {
      default = "lines",
      "lines",
      "points",
      "linespoints",
      "impulses",
      "dots",
      "steps",
      "errorbars",
      "boxes",
      "boxeserrorbars",
   },
}

--[[
gp = Gnuplot:new()

-- Rudimentary unit test framework for Gnuplot class
function gp:test ()
   local must_fail =
   {
      function ()
         base.print("Attempting gnuplot:my_assert test.")
         self:stop()
         self:my_assert(false, "self:my_assert test")
      end,
      function ()
         base.print("Attempting gnuplot:set_style test.")
         self:set_style("this is definitely invalid")
      end,
   }

   local must_succeed =
   {
      function ()
         base.print("Attempting gnuplot:stop test.")
         self:stop()
      end,
      function ()
         base.print("Attempting gnuplot:init test.")
         self:stop()
         self:init()
      end,
      function ()
         base.print("Attempting gnuplot:affix_label test.")
         local res1 = self:affix_label("hi")
         if (not res1 or res1 == "") then
            error("self:affix_label failed to add label.")
         end

         local res2 = self:affix_label("")
         if (not res2 or res2 ~= "") then
            error("self:affix_label added superfluous text. Test 1.")
         end

         local res3 = self:affix_label()
         if (not res3 or res3 ~= "") then
            error("self:affix_label added superfluous text. Test 2.")
         end
      end,
      function ()
         base.print("Attempting gnuplot:set_style test.")
         for i,v in base.ipairs(self.valid_styles) do
            self:set_style(v)
         end
      end,
      function ()
         base.print("Attempting gnuplot:set_grid test.")
         self:set_grid()
      end,
      function ()
         base.print("Attempting gnuplot:plot test.")
         self:stop()
         self:init()
         self:plot({1,2,3,4,5},"eensy weensy spider")
         self:plot({.1,.2,.3,.2,.5},"something altogether different")
         self:plot({{.5,.5},{.6,.6},{.55,.4},{.8,.8},{.9,.9}}, "zig zag")

         self:stop()
         self:init()
         self:set_grid()
         gp:plot({grid=5,
                 {1,1,5},{1,2,5},{1,3,5},{1,4,5},{1,5,5},
                 {2,1,5},{2,2,5},{2,3,5},{2,4,5},{2,5,5},
                 {3,1,5},{3,2,5},{3,3,5},{3,4,5},{3,5,5},
                 {4,1,5},{4,2,5},{4,3,5},{4,4,5},{4,5,5},
                 {5,1,5},{5,2,5},{5,3,5},{5,4,5},{5,5,5}},"grid")
      end,
   }

   for i,v in base.ipairs(must_fail) do
      success_flag, err_msg = base.pcall(v)
      base.assert(success_flag == false, "\n\n" .. base.tostring(err_msg) .. "\n\n"
             .. base.debug.traceback())
      base.print("Success.")
   end

   for i,v in base.ipairs(must_succeed) do
      success_flag, err_msg = base.pcall(v)
      --base.print('err_msg = ' .. base.tostring(err_msg) .. base.debug.traceback())
      base.assert(success_flag == true, "\n\n" .. base.tostring(err_msg) .. "\n\n"
             .. base.debug.traceback())
      base.print("Success.")
   end
end

-- run tests
gp:test()
--]]
