#include ".test.hpp"

TEST(generic_lambdas)
{
   auto print_anything = [](const auto& var){ooo(iii) << var;};

   print_anything("a thing");
   print_anything(3.14);
   print_anything(10);
}

struct A{};

TEST(lambda_capture)
{
   sentinel("main entry");
   auto x = unique_sentinel("unique sentinel");
   auto lamb = [x = std::move(x)]
   {
      sentinel("lambda sentinel");
   };
   lamb();
}
