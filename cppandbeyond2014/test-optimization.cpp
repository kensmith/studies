#include ".test.hpp"
#include "shared_ptr_t.hpp"
#include "unique_ptr_t.hpp"

TEST(basic)
{
   void *p = reinterpret_cast<void*>(0x1234);
   if (!p)
   {
      ooo(iii) << "case 1";
   }
   if (p != NULL)
   {
      ooo(iii) << "case 2";
   }
   if (p != nullptr)
   {
      ooo(iii) << "case 3";
   }
}

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

TEST(unique_ptr_t_test)
{
   auto p = unique_ptr_t<int>(new int(10));
   ooo(iii)
      << p;

   auto r = std::move(p);
   ooo(iii)
      << p;
}
