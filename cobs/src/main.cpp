#include <fstream>
#include <iostream>
#include <boost/function.hpp>

#include "chunk_t.hpp"

struct cobs_t
{
   explicit cobs_t(boost::function<void(const chunk_t &)> callback)
      : callback_(callback)
   {
   }

   friend cobs_t & operator<<(cobs_t & cobs, byte_t byte);
private:
   boost::function<void(const chunk_t &)> callback_;
   chunk_t chunk_;
};

cobs_t & operator<<(cobs_t & cobs, byte_t byte)
{
   if ((cobs.chunk_ << byte).finished())
   {
      cobs.callback_(cobs.chunk_);
      cobs.chunk_.reset();
   }
   
   return cobs;
}

struct chunktor_t
{
   void operator()(const chunk_t & chunk)
   {
      (void) chunk;
      std::cout << "got a chunk, " << chunk.length() << " bytes: " << chunk << std::endl;
   }
};

int main()
{
   std::ifstream in("/dev/urandom");

   chunktor_t chunktor;
   cobs_t cobs(chunktor);
   byte_t x;
   while (1)
   {
      in >> x;
      cobs << x;
   }
}
