#include <iostream>

template <unsigned long x>
struct num_bits_hakmem
{
    static const unsigned long tmp = 
        x - ((x >> 1) & 0x7777777777777777ULL)
          - ((x >> 2) & 0x3333333333333333ULL)
          - ((x >> 3) & 0x1111111111111111ULL);
    static const int value =
        ((tmp + (tmp >> 4)) & 0x0f0f0f0f0f0f0f0fULL) % 0xff;
};

template <unsigned long x>
struct num_bits_slow
{
    static const int lsb_on = x % 2;
    static const int value = lsb_on + num_bits_slow<(x >> 1)>::value;
};

template <>
struct num_bits_slow<0>
{
    static const int value = 0;
};

int main()
{
    int value = num_bits_hakmem<0xffffffffffffffffULL>::value;
    std::cout
        << value
        << " = 0x"
        << std::hex
        << value
        << std::dec
        << std::endl;

    int slow_value = num_bits_slow<0xffffffffffffffffULL>::value;
    std::cout
        << slow_value
        << " = 0x"
        << std::hex
        << slow_value
        << std::dec
        << std::endl;
    return 0;
}
