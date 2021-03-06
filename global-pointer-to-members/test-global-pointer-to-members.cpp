#include ".test.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>

typedef std::pair<int, double> id_value;
int id_value::*id = &id_value::first;
double id_value::*value = &id_value::second;

TEST(basic)
{
   id_value i;
   i.*id = -5;
   i.*value = 3.14;
   // wacky
   EQ(-5, i.*id);
   CL(3.14, i.*value, 1e-5);

   id_value p;
   p.*id = -7;
   p.*value = 2.718;
   EQ(-5, i.*id);
   CL(3.14, i.*value, 1e-5);
   EQ(-7, p.*id);
   CL(2.718, p.*value, 1e-5);
}
