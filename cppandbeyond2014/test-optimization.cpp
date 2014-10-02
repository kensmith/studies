#include ".test.hpp"

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
