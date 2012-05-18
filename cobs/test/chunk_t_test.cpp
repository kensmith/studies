#include "chunk_t.hpp"
#include "byte_t.hpp"

#include <iostream>
#include <sstream>

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE(single_zero)
{
   chunk_t chunk;
   BOOST_CHECK(!chunk.finished());
   byte_t byte = 0;
   chunk << byte;
   BOOST_CHECK(chunk.finished());

   std::stringstream ss;
   ss << chunk;
   BOOST_CHECK_EQUAL(std::string("01"), ss.str());
}

BOOST_AUTO_TEST_CASE(single_nonzero_followed_by_zero)
{
   chunk_t chunk;
   byte_t byte = 10;
   chunk << byte;
   BOOST_CHECK(!chunk.finished());
   byte = 0;
   chunk << byte;
   BOOST_CHECK(chunk.finished());

   std::stringstream ss;
   ss << chunk;
   std::string truth("020a");
   BOOST_CHECK_EQUAL(truth, ss.str());
}

BOOST_AUTO_TEST_CASE(max_packet_explicit_zero)
{
   chunk_t chunk;
   std::stringstream truth_ss;
   truth_ss << byte_t(0xff);
   for (byte_t byte = 1; byte < 255; byte++)
   {
      if (byte == 254)
      {
         std::cout << "here" << std::endl;
      }
      chunk << byte;
      truth_ss << byte;
   }
   std::stringstream ss;
   ss << chunk;
   BOOST_CHECK_EQUAL(truth_ss.str(), ss.str());
}
