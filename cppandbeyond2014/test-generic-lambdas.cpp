#include ".test.hpp"

TEST(basic)
{
   auto print_anything = [](const auto& var){ooo(iii) << var;};

   print_anything("a thing");
   print_anything(3.14);
   print_anything(10);
}
