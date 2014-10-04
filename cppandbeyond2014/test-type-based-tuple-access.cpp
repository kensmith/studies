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
