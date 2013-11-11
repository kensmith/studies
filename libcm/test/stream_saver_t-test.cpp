#include "stream_saver_t.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

TEST(basic)
{
   std::ios_base::fmtflags flags_before = std::cout.flags();
   {
      stream_saver_t saver(std::cout);
      std::cout << std::hex;
      std::ios_base::fmtflags flags_after = std::cout.flags();
      NE(flags_before, flags_after);
   }
   std::ios_base::fmtflags flags_after_saver = std::cout.flags();
   EQ(flags_before, flags_after_saver);
}
