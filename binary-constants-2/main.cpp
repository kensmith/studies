#include <iostream>

template <int x>
struct binary
{
    static const int value = 2*binary<x/10>::value + (x&1);
};

template <>
struct binary<0>
{
    static const int value = 0;
};

int main()
{
    std::cout << "binary<101010>::value = " << binary<101010>::value << std::endl;
    return 0;
}
