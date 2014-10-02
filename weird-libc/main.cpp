#include <unistd.h>
#include <iostream>

int main()
{
   std::cout
      << "page size = "
      << sysconf(_SC_PAGESIZE)
      << std::endl;
   return 0;
}
