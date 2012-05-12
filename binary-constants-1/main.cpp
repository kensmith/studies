#if 0
template <int x> struct binary {
    enum {value = 2*binary<x/10>
};
#endif

#include <iostream>

template <int x> struct binary_template
{
    enum {value = (binary_template<x/10>::value << 1) + (x&1)};
};

template <> struct binary_template<0>
{
    enum {value = 0};
};

int binary(int x)
{
    if (x)
    {
        int recursive_result = binary(x/10);
        std::cout << "recursive_result for " << x << " = " << recursive_result << std::endl;
        int semi_result = x&1;
        std::cout << "semi_result for " << x << " = " << semi_result << std::endl;
        int result = (recursive_result<<1) + semi_result;
        std::cout << "result for " << x << " = " << result << std::endl;
        return result;
    }
    else
    {
        return 0;
    }
}

int main()
{
    std::cout << std::hex << "binary(101010) = " << binary(101010) << std::endl;
    int alternative = binary_template<101010>::value;
    std::cout << std::hex << "binary_template<101010>::value = " << alternative << std::endl;
    return 0;
}
