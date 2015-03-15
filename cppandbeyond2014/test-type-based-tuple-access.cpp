#include ".test.hpp"
#include <tuple>

TEST(basic)
{
   using tup_t = std::tuple<std::string, int, double>;
   tup_t tup = tup_t("hi", 1, 1.25);
   EQ("hi", std::get<std::string>(tup));
   EQ(1, std::get<int>(tup));
   EQ(1.25, std::get<double>(tup));
}

using first_int_t = int;
using second_int_t = int;
TEST(interesting)
{
   using tup_t = std::tuple<std::string, first_int_t, second_int_t>;
   tup_t tup = tup_t("hi", 1, 10);
   EQ("hi", std::get<std::string>(tup));
#if 0
   // Won't work because using aliases are just aliases and
   // don't change the meaning of the type.
   EQ(1, std::get<first_int_t>(tup));
   EQ(10, std::get<second_int_t>(tup));
#endif
}
