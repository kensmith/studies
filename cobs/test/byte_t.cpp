#include "byte_t.hpp"

#include <iostream>
#include <sstream>

#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>

BOOST_AUTO_TEST_CASE(print_basic)
{
   byte_t ten(10);
   std::stringstream ss;
   ss << ten;
   std::string truth("0a");
   BOOST_CHECK_EQUAL(truth, ss.str());

   byte_t onetwoseven(127);
   ss.str("");
   ss << onetwoseven;
   truth = "7f";
   BOOST_CHECK_EQUAL(truth, ss.str());

   byte_t twofivefive(255);
   ss.str("");
   ss << twofivefive;
   truth = "ff";
   BOOST_CHECK_EQUAL(truth, ss.str());

   BOOST_CHECK(sizeof(ten) == sizeof(std::uint8_t));
}

BOOST_AUTO_TEST_CASE(explict_logical)
{
   byte_t ten(10);
   byte_t eleven(11);
   byte_t ten_copy(ten);
   BOOST_CHECK_EQUAL(ten, ten_copy);
   BOOST_CHECK(ten != eleven);
}

BOOST_AUTO_TEST_CASE(implicit_logical)
{
   byte_t ten(10);
   BOOST_CHECK_EQUAL(ten, 10);
   BOOST_CHECK_EQUAL(10, ten);
   BOOST_CHECK(11 != ten);
   BOOST_CHECK(ten != 11);
}

BOOST_AUTO_TEST_CASE(assignment)
{
   byte_t byte;
   byte = 10;
   byte_t byte_copy;
   byte_copy = byte;
   BOOST_CHECK_EQUAL(byte, byte_copy);
}

BOOST_AUTO_TEST_CASE(relational)
{
}
