#include ".test.hpp"
#include "shared_ptr2_t.hpp"

TEST(basic)
{
   auto p = shared_ptr2_t<int>(new int(10));
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
   auto m = std::move(p);
   ooo(iii)
      << p;
   ooo(iii)
      << m;
}
