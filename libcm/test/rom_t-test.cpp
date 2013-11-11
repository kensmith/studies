#include "rom_t.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

struct fixture_t
{
   fixture_t()
      :rom("data/app.bin")
   {
   }

   rom_t rom;
};

FTST(next_word, fixture_t)
{
   EQ(0x10007ff0, rom.next_word());
   EQ(0x000005b3, rom.next_word());
}

FTST(checksum_valid, fixture_t)
{
   BOOST_CHECK(rom.checksum_valid());
}

FTST(stack_top, fixture_t)
{
   EQ(0x10007ff0, rom.stack_top());
}

FTST(reset_vector, fixture_t)
{
   EQ(0x000005b3, rom.reset_vector());
}

FTST(next_halfword, fixture_t)
{
   EQ(0x7ff0, rom.next_halfword());
   EQ(0x1000, rom.next_halfword());
}

FTST(halfword_at, fixture_t)
{
   EQ(0x4668, rom.halfword_at(0x000005b2));
}

FTST(i_at, fixture_t)
{
   //EQ(0xf0200107, rom.i_at(0x000005b4));
}
