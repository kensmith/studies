#include ".test.hpp"
#include <map>
#include <string>

TEST(basic)
{
#if 1
   //std::map<std::string, std::string> m0{{"a", 0}};
   //(void)m0;
   //std::map<std::string, std::string> m00{{"a", 1}};
   //(void)m0;
#else
   std::map<std::string, std::string> m0{{"a", "1"}};
   (void)m0;
#endif

   std::map<std::string, std::string> m1;
   m1["a"] = 1;
   for (const auto& p : m1)
   {
      ooo(iii)
         << "'" << p.first << "' = "
         << "'" << p.second << "'";
   }

   std::map<std::string, std::string> m2;
   m2["a"] = 0;
}
