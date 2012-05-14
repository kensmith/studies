#include "chunk_t.hpp"

#include <iostream>
#include <sstream>

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE(single_zero)
{
   chunk_t chunk;
   BOOST_CHECK(!chunk.finished());
   std::uint8_t byte = 0;
   chunk << byte;
   BOOST_CHECK(chunk.finished());

   std::stringstream ss;
   ss << chunk;
   BOOST_CHECK_EQUAL(std::string("\x01"), ss.str());
}
