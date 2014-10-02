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

struct B {};

void foo(int x, B y) {std::cout << "foo" << std::endl;}

int a = 10;
B b;
auto capturing_closure = [=, b = std::move(B(b))]() {foo(a, b);};

TEST(capturing_closure_test)
{
   //generates an extra instruction at invocation...
   //auto&& closure = []{std::cout << "yo" << std::endl;};
   //...but is equivalent to this when optimizing.
   auto closure = []{ooo(iii) << "yo";};

   //
   closure();
}
