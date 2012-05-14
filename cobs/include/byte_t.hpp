#pragma once

#include <cstdint>
#include <iostream>

struct byte_t
{
   byte_t()
      : byte_(0)
   {
   }

   /* implicit conversion intended */ byte_t(std::uint8_t byte)
      : byte_(byte)
   {
   }

   byte_t operator++(int)
   {
      byte_t old_val = *this;
      ++byte_;
      return old_val;
   }

   byte_t & operator++()
   {
      ++byte_;
      return *this;
   }

   friend bool operator==(const byte_t lhs, const byte_t rhs);
   friend bool operator!=(const byte_t lhs, const byte_t rhs);
   friend bool operator<(const byte_t lhs, const byte_t rhs);
   friend std::ostream & operator<<(std::ostream & stream, byte_t byte);

private:
   std::uint8_t byte_;
};

inline bool operator==(const byte_t lhs, const byte_t rhs)
{
   return lhs.byte_ == rhs.byte_;
}

inline bool operator!=(const byte_t lhs, const byte_t rhs)
{
   return !(lhs == rhs);
}

inline bool operator<(const byte_t lhs, const byte_t rhs)
{
   return lhs.byte_ < rhs.byte_;
}

inline std::ostream & operator<<(std::ostream & stream, byte_t byte)
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
