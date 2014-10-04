#include ".test.hpp"
#include "unique_ptr_t.hpp"

TEST(unique_ptr_t_test)
{
   auto p = unique_ptr_t<int>(new int(10));
   ooo(iii)
      << p;

   auto r = std::move(p);
   ooo(iii)
      << p;
}
