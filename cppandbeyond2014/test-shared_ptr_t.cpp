#include ".test.hpp"
#include "shared_ptr_t.hpp"

TEST(shared_ptr_t_test)
{
   auto p = shared_ptr_t<int>(new int(10));
   ooo(iii)
      << p;
   {
      auto q = p;
      ooo(iii)
         << p;
      {
         auto r = q;
         ooo(iii)
            << p;
      }
   }
}

