#include <iostream>

typedef int hi(int);

int foo(int val)
{
    std::cout << "hi" << val << std::endl;
}

void wacky(int (&funp)(int))
{
    std::cout << "whatthe" << std::endl;
}

int main(void)
{
    hi* yo = foo;
    (*yo)(10);
    wacky(*yo);
    return 0;
}
