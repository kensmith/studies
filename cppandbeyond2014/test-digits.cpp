#include ".test.hpp"

TEST(binary_literals)
{
   uint32_t a = 0b01011010;
   EQ(0x5a,a);
}

TEST(digit_separator)
{
   uint64_t a = 0b0000'0001'0010'0011'0100'0101'0110'0111'1000'1001'1010'1011'1100'1101'1110'1111;
   EQ(0x123456789abcdef, a);
}
