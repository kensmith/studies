#pragma once

#include <cstdint>
#include <iosfwd>

struct chunk_t
{
   static const int size = 254;

   chunk_t()
      : next_i_(0)
      , finished_(false)
   {
   }

   friend chunk_t & operator<<(chunk_t & chunk, std::uint8_t byte);
   friend std::ostream & operator<<(std::ostream & stream, const chunk_t & chunk);

   bool finished() const
   {
      return finished_;
   }

   void reset()
   {
      next_i_ = 0;
   }
private:
   std::uint8_t bytes_[size];
   int next_i_;
   bool finished_;
};
