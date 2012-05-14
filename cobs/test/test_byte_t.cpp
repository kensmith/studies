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
}
