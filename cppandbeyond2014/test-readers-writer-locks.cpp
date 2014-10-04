#include ".test.hpp"

#include <thread>

TEST(doit)
{
#if 0 // maybe not yet in gcc
   std::shared_timed_mutex mutex;
   std::vector<std::thread> consumers(20);
#endif
}
