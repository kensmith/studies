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
   BOOST_CHECK_EQUAL(std::string("01"), ss.str());
}

BOOST_AUTO_TEST_CASE(single_nonzero_followed_by_zero)
{
   chunk_t chunk;
   std::uint8_t byte = 10;
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
   truth_ss << std::uint8_t(0xff);
   for (std::uint8_t byte = 1; byte < 255; byte++)
   {
      chunk << byte;
      truth_ss << byte;
   }
   std::stringstream ss;
   ss << chunk;
   std::cout << "truth size = " << truth_ss.str().size() << std::endl;
   std::cout << "truth[0] = " << (0xff & std::uint32_t(truth_ss.str()[0])) << std::endl;
   std::cout << "actual size = " << ss.str().size() << std::endl;
   std::cout << "actual[0] = " << (0xff & std::uint32_t(ss.str()[0])) << std::endl;
   // TODO
   //BOOST_CHECK_EQUAL(truth_ss.str(), ss.str());
}
