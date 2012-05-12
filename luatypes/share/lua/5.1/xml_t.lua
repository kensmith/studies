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
require('stack_t')

xml_t = {default_indent = ' '}

setmetatable(xml_t, xml_t)

local tests = {}

function tests.escape()
   local s = '(AT&T > "Bell Labs") < \'Ma Bell\''
   assert(xml_t.escape(s)
      == '(AT&amp;T &gt; &quot;Bell Labs&quot;) &lt; &apos;Ma Bell&apos;')
end
---Escape the required characters for literal strings.
function xml_t.escape(str)
   local result =
      str:gsub('&','&amp;'
      ):gsub('<','&lt;'
      ):gsub('>','&gt;'
      ):gsub("'",'&apos;'
      ):gsub('"','&quot;')

   return result
end

function tests.__call()
   local html = xml_t('html', nil, nil, '    ')
   local img = html('img', {src='images/hi.gif', alt='An image'})
   assert(tostring(html) == [[
<html>
    <img alt="An image" src="images/hi.gif">
    </img>
</html>
]])

   local kml = xml_t('kml', {xmlns="http://earth.google.com/kml/2.2"}, nil, ' ')
   kml:include_declaration(true)
   local doc = kml('Document')
   doc('name','data/48thand6th-1.txt')
   doc('visibility',1)
   doc('open',1)
   local pm = doc('Placemark')
   pm('name', 'Actual Mobile Position')
   local style = pm('Style')
   local icon_style = style('IconStyle')
   icon_style('color', 'FF008000')
   icon = icon_style('Icon')
   icon('href', 'http://maps.google.com/mapfiles/kml/pal4/icon28.png')
   local point = pm('Point')
   point('altitudeMode','relativeToGround')
   point('coordinates','-73.98155, 40.758817, 0')

   assert(tostring(kml) == [[
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://earth.google.com/kml/2.2">
 <Document>
  <name>
   data/48thand6th-1.txt
  </name>
  <visibility>
   1
  </visibility>
  <open>
   1
  </open>
  <Placemark>
   <name>
    Actual Mobile Position
   </name>
   <Style>
    <IconStyle>
     <color>
      FF008000
     </color>
     <Icon>
      <href>
       http://maps.google.com/mapfiles/kml/pal4/icon28.png
      </href>
     </Icon>
    </IconStyle>
   </Style>
   <Point>
    <altitudeMode>
     relativeToGround
    </altitudeMode>
    <coordinates>
     -73.98155, 40.758817, 0
    </coordinates>
   </Point>
  </Placemark>
 </Document>
</kml>
]])

end
---The workhorse of this class, it both instantiates an xml_t and,
--when called on an instance, adds elements to an xml_t.  Here's how
--local html = xml_t('html', nil, nil, '    ')
--local img = html('img', {src='images/hi.gif', alt='An image'})
--print(html)
--For a more detailed example see the test for __call in the source.
function xml_t:__call(tag, attr_or_literal, opt_literal, indent)
--print('tag = "' .. tostring(tag) .. '", "' .. indent .. '"')
   assert(is.a(xml_t, self),
      "xml_t:__call: self must be an xml_t"
   )

   assert(not tag or type(tag) == 'string',
      "xml_t:__call: tag must be a string or nil, is "
      .. type(tag)
   )

   local attr
   local literal
   if attr_or_literal then
      if type(attr_or_literal) == 'table' then
         attr = attr_or_literal
      elseif type(attr_or_literal) == 'string' then
         literal = attr_or_literal
      elseif type(attr_or_literal) == 'number' then
         literal = tostring(attr_or_literal)
      else
         assert(false,
            "xml_t:__call: attr_or_literal must be a table of "
            .. "attributes or a literal string, is "
            .. type(attr_or_literal)
         )
      end
   end

   literal = literal or opt_literal

   assert(not literal or type(literal) == 'string',
      "xml_t:__call: literal must be nil or a string, is "
      .. type(literal)
   )

   indent = indent or xml_t.default_indent
   
   if self._ then
      if tag then
         local sub = xml_t(tag, attr, literal, self._.indent)
         sub._.up = self
         sub._.level = self._.level + 1
         self._.down:insert(sub)
         return sub
      else
         return self._.up or self
      end
   else
      local o = {
         _ = {
            tag = tag,
            attr = attr,
            down = {insert = table.insert},
            up = nil,
            level = 0,
            indent = indent,
            include_declaration = false,
            version = '1.0',
            encoding = 'UTF-8',
         },
         indent = xml_t.indent,
         version = xml_t.version,
         encoding = xml_t.encoding,
         include_declaration = xml_t.include_declaration,
      }

      if literal then
         o._.down:insert(literal)
      end

      setmetatable(o, xml_t)
      return o
   end
end

function tests.include_declaration()
   local xml = xml_t()
   assert(not xml:include_declaration())
   xml:include_declaration(true)
   assert(xml:include_declaration())
end
---Cause the rendered XML output to containg a <?xml...?>
--declaration.
function xml_t:include_declaration(new_value)
   if new_value then
      assert(type(new_value) == 'boolean',
         "xml_t:include_declaration: new_value must be nil or a boolean"
      )
      self._.include_declaration = new_value
      return self
   else
      return self._.include_declaration
   end
end

function tests.encoding()
   local xml = xml_t()
   assert(xml:encoding() == 'UTF-8')
   xml:encoding('something else')
   assert(xml:encoding() == 'something else')
end
---Set the encoding string for the XML declaration.
function xml_t:encoding(encoding)
   if encoding then
      assert(type(encoding) == 'string')
      self._.encoding = encoding
      return self
   else
      return self._.encoding
   end
end

function tests.version()
   local xml = xml_t()
   assert(xml:version() == '1.0')
   xml:version('something else')
   assert(xml:version() == 'something else')
end
---Set the encoding version for the XML declaration.
function xml_t:version(version)
   if version then
      assert(type(version) == 'string')
      self._.version = version
      return self
   else
      return self._.version
   end
end

function tests.indent()
   xmla = xml_t('hi')
   assert(xmla:indent() == '')
   suba = xmla('hello')
   assert(suba:indent() == xml_t.default_indent)
   subsuba = suba('bye')
   assert(subsuba:indent() == (xml_t.default_indent):rep(2))

   local myindent = '   '
   xmlb = xml_t('hello', nil, nil, myindent)
   subb = xmlb('hey')
   subsubb = subb('later')
   assert(subsubb:indent() == myindent:rep(2))
   assert(subsubb:indent(1) == myindent:rep(3))
   assert(subsubb:indent(-1) == myindent:rep(1))
end
---Return the appropriate indentation for this level.  If n is
--supplied, add it to the indentation level before returning the
--indentation string.
--@param n fudge factor
--@return indentation string, usually all spaces.
function xml_t:indent(n)
   assert(is.a(xml_t, self),
      "xml_t:indent: self must be an xml_t"
   )

   return self._.indent:rep(self._.level + (tonumber(n) or 0))
end

function tests.__tostring()
end
---Render the document as a printable string.
function xml_t:__tostring()
   local b = {insert = table.insert, concat = table.concat}

   if self:include_declaration() then
      if self._.level == 0 then
         b:insert('<?xml version="')
         b:insert(self:version())
         b:insert('" encoding="')
         b:insert(self:encoding())
         b:insert('"?>\n')
      end
   end

   b:insert(self:indent())
   b:insert('<')
   b:insert(self._.tag)
   for k,v in pairs(self._.attr or {}) do
      b:insert(' ')
      b:insert(tostring(k))
      b:insert('="')
      b:insert(tostring(v))
      b:insert('"')
   end
   b:insert('>\n')
   for i,v in ipairs(self._.down) do
      if type(v) == 'string' then
         b:insert(self:indent(1))
         b:insert(xml_t.escape(tostring(v)))
         b:insert('\n')
      else
         b:insert(tostring(v))
      end
   end
   b:insert(self:indent())
   b:insert('</')
   b:insert(self._.tag)
   b:insert('>\n')
   return b:concat()
end

if arg and arg[0]:match('.*xml_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('xml_t')
