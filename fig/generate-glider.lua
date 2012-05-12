#!/usr/bin/env lua

black = 0x00
white = 0x7f

glider1 =
{
   {white,black,white},
   {white,white,black},
   {black,black,black},
}

glider2 =
{
   {black,white,black},
   {white,black,black},
   {white,black,white},
}

glider3 =
{
   {white,white,black},
   {black,white,black},
   {white,black,black},
}

glider4 =
{
   {black,white,white},
   {white,black,black},
   {black,black,white},
}

-- set this to one of the above to generate the
-- scaled image for that glider
glider = glider4

scale = 42

count = 0
newline_every = 10
for i,row in ipairs(glider) do
   for m=1,scale do
      for j,cell in ipairs(row) do
         for k=1,scale do
            io.write(string.format('0x%02x,',cell))
            count = count + 1
            if count % newline_every == 0 then
               io.write('\n')
            end
         end
      end
   end
end
