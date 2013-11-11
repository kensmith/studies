#include <string>
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

TEST(example)
{
   std::string is = "is";
   EQ("is", is);
}
