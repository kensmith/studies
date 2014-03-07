#include <time.h>
#include <iostream>
#include <boost/lexical_cast.hpp>

int main(int argc, char* const * argv)
{
   if (argc != 2) return 1;
   const time_t epoch = boost::lexical_cast<time_t>(argv[1]);
   std::cout << ctime(&epoch) << std::endl;
   return 0;
}
