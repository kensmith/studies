#include <time.h>
#include <iostream>
#include <boost/lexical_cast.hpp>

namespace
{
   const std::size_t MAX_BUF = 2048;
}

int main(int argc, char* const * argv)
{
   char buf[MAX_BUF];

   if (argc != 2) return 1;

   // default
   const time_t epoch = boost::lexical_cast<time_t>(argv[1]);
   std::cout << ctime(&epoch) << std::endl;

   struct tm ts;

   ts = *localtime(&epoch);

   // MM-DD-YYYY HH:MM:SS
   (void) strftime(buf, MAX_BUF, "%m-%d-%Y %H:%M:%S", &ts);
   std::cout << buf << std::endl;

   std::cout << std::endl;

   (void) strftime(buf, MAX_BUF, "%Y.%d.%m-%H.%M.%S", &ts);
   std::cout << buf << std::endl;

   return 0;
}
