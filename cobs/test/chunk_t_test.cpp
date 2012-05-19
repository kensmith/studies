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
      chunk << byte;
      truth_ss << byte;
   }
   std::stringstream ss;
   ss << chunk;
   BOOST_CHECK_EQUAL(truth_ss.str(), ss.str());
}

BOOST_AUTO_TEST_CASE(back_to_back_chunk_use)
{
   chunk_t chunk;
   const byte_t first_chunk[] =
   {
      1,2,3,4,
      5,6,7,8,
      9,0xa,0xb,0xc,
      0xd,0xe,0xf,0,
   };

   const byte_t second_chunk[] =
   {
      101,102,103,104,
      105,106,107,108,
      109,110,111,112,
      113,114,115,0,
   };

   const byte_t * b = first_chunk;
   do
   {
      chunk << *b;
   }
   while (*b++ != 0);

   std::stringstream ss;
   ss << chunk;
   BOOST_CHECK_EQUAL("100102030405060708090a0b0c0d0e0f", ss.str());

   b = second_chunk;
   do
   {
      chunk << *b;
   }
   while (*b++ != 0);

   ss.str("");
   ss << chunk;
   BOOST_CHECK_EQUAL("1065666768696a6b6c6d6e6f70717273", ss.str());
}
