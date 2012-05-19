#include <fstream>
#include <iostream>
#include <boost/function.hpp>
#include <boost/program_options.hpp>

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

int main(int argc, char ** argv)
{
   if (argc != 2)
   {
      std::cerr
         << "usage: "
         << argv[0]
         << " <file>"
         << std::endl;
      std::exit(1);
   }
   std::ifstream in(argv[1]);

   chunktor_t chunktor;
   cobs_t cobs(chunktor);
   byte_t x;
   while (1)
   {
      std::cout << "x = " << x << std::endl;
      in >> x;
      cobs << x;
   }
}
