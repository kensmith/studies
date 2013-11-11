#include "ram_t.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

TEST(basic)
{
#if 0
   ram_t ram;
   ram.new_region(0x10000000, 0x1007ffff);
   ram.new_region(0x2007ffff, 0x2007c000);
   ram.new_region(0x20083fff, 0x20080000);
   ram.write_word(0x10000000, 0xffffffff);
   EQ(0xffffffff, ram.read_word(0x10000000));
#endif
}
