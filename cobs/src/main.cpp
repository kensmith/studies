#include <fstream>
#include <iostream>
#include <boost/function.hpp>

struct chunk_t
{
};

struct cobs_t
{
   explicit cobs_t(boost::function<void(const chunk_t &)> & callback)
      : callback_(callback)
   {
   }

   friend cobs_t & operator<<(cobs_t & cobs, std::uint8_t byte);
private:
   boost::function<void(const chunk_t &)> callback_;
};

cobs_t & operator<<(cobs_t & cobs, std::uint8_t byte)
{
   cobs.callback_(chunk_t());
   std::cout << int(byte) << std::endl;
   return cobs;
}

struct chunktor_t
{
   void operator()(const chunk_t & chunk)
   {
      (void) chunk;
      std::cout << "got a chunk" << std::endl;
   }
};

int main()
{
   std::ifstream in("/dev/urandom");

   chunktor_t chunktor;
   cobs_t cobs(chunktor);
   std::uint8_t x;
   while (1)
   {
      in >> x;
      cobs << x;
   }
}
