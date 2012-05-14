#pragma once

#include <cstdint>
#include <iostream>

struct byte_t
{
   explicit byte_t(std::uint8_t byte)
      : byte_(byte)
   {
   }

   friend std::ostream & operator<<(std::ostream & stream, byte_t byte);
private:
   std::uint8_t byte_;
};

std::ostream & operator<<(std::ostream & stream, byte_t byte)
{
   static const char * conversions[] =
   {
      "0", "1", "2", "3",
      "4", "5", "6", "7",
      "8", "9", "a", "b",
      "c", "d", "e", "f",
   };

   stream << conversions[(byte.byte_ >> 4) & 0xf];
   stream << conversions[byte.byte_ & 0xf];

   return stream;
}
