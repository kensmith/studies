#include ".test.hpp"
#include <sstream>
#include <string>

TEST(without_quoting)
{
   std::stringstream ss;
   std::string original = "foolish me";
   std::string round_trip;
   ss << original;
   ss >> round_trip;
   NE(original, round_trip);
}

TEST(with_quoting)
{
   std::stringstream ss;
   std::string original = "foolish me";
   std::string round_trip;
   ss << std::quoted(original);
   ss >> std::quoted(round_trip);
   EQ(original, round_trip);
}
