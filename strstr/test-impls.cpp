#include ".test.hpp"

#include <cstring>

const char* naive(const char* haystack, const char* needle)
{
   size_t len = strlen(needle);
   while (*haystack)
   {
      if (strncmp(haystack, needle, len) == 0)
      {
         return haystack;
      }
      ++haystack;
   }
   return nullptr;
}

TEST(test_naive)
{
   const char* haystack = "a quick brown fox jumped over the lazy dog";
   const char* needle = "fox";
   EQ(haystack + 14, naive(haystack, needle));
}

const char* with_feeling(const char* haystack, const char* needle)
{
   for (;*haystack; ++haystack)
   {
      int i = 0;
      for (int i = 0; needle[i] == haystack[i] && needle[i]; ++i)
      {
      }
      if (!needle[i]) return haystack;
   }
   return nullptr;
}

TEST(test_with_feeling)
{
   const char* haystack = "a quick brown fox jumped over the lazy dog";
   const char* needle = "fox";
   EQ(haystack + 14, with_feeling(haystack, needle));
}
