#include <iostream>

struct B
{
};

void foo(int x, B y) {std::cout << "foo" << std::endl;}

int a = 10;
B b;
auto capturing_closure = [=, b = std::move(B(b))]() {foo(a, b);};

int main()
{
   //generates an extra instruction at invocation...
   //auto&& closure = []{std::cout << "yo" << std::endl;};
   //...but is equivalent to this when optimizing.
   auto closure = []{std::cout << "yo" << std::endl;};

   //
   closure();

   //
   return 0;
}
