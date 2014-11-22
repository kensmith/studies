#include ".test.hpp"

TEST(basic)
{
   EQ(8, 0x1111'1111 % 15);
   EQ(12, 0x2222'1111 % 15);
   EQ(14, 0x2222'2211 % 15);
}
