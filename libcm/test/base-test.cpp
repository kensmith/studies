#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

TEST(_u)
{
   EQ(2, sizeof(15_u));
}

TEST(_s)
{
   EQ(2, sizeof(15_s));
}

TEST(array_len_test)
{
   u32_t a[] = {1,2,3,4,5,6,7};
   EQ(7, array_len(a));
}

TEST(ensure_test)
{
   THROW(ensure(false), ex_t);
   NO_THROW(ensure(true));
}

TEST(count_bits_test)
{
   u64_t bits = 0xffffffffffffffffULL;
   EQ(64, count_bits(bits));

   bits = 0x00000000a0000000ULL;
   EQ(2, count_bits(bits));

   const u64_t msb_lit = 0x8000000000000000ULL;
   bits = msb_lit;
   for (
      u32_t i = 1;
      bits != 0xffffffffffffffffULL;
      i++, bits >>= 1, bits |= msb_lit
   )
   {
      EQ(i, count_bits(bits));
   }
}
