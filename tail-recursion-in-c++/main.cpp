#include <iostream>

void recurse(int x);
void tail(int x)
{
   std::cout
      << x
      << ", tail ";
   recurse(x+1);
}

void recurse(int x)
{
   std::cout
      << "recurse"
      << std::endl;
   tail(x+1);
}

int main()
{
   tail(0);
   return 0;
}
