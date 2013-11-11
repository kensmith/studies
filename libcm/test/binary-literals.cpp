#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include <boost/utility.hpp>
#include "test.hpp"

u32_t gnu_style()
{
   u32_t result = 0b10101010101010101010101010101010;
   return result;
}

u32_t operator "" _b(unsigned long long x)
{
   u32_t result = 0;
   u32_t mask = 1;
   while (x)
   {
      if (x & 1)
      {
         result |= mask;
      }
      x /= 10;
      mask <<= 1;
   }
   return result;
}

u32_t user_defined_literally()
{
   // y u no work? (Actually, I think I know. Boost.Binary
   // it is.)
   u32_t result = 10101010101010101010_b;
   return result;
}

u32_t boost_binarily()
{
   u32_t result = bb(10101010 10101010 10101010 10101010);
   return result;
}

TEST(all)
{
   EQ(0xaaaaaaaa, gnu_style());
   EQ(0xaaaaa, user_defined_literally());
   EQ(0xaaaaaaaa, boost_binarily());
}
