#include "chunk_t.hpp"

#include <iostream>

chunk_t & operator<<(chunk_t & chunk, std::uint8_t byte)
{
   if (chunk.finished())
   {
      chunk.reset();
   }

   if (byte != 0)
   {
      chunk.bytes_[chunk.next_i_] = byte;
   }

   ++chunk.next_i_;

   if (chunk.next_i_ >= chunk_t::size || byte == 0)
   {
      chunk.finished_ = true;
   }

   return chunk;
}

std::ostream & operator<<(std::ostream & stream, const chunk_t & chunk)
{
   stream << std::uint8_t(chunk.next_i_);
   return stream;
}
