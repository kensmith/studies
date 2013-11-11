#pragma once

#include "instruction_t.hpp"

struct matcher_t
{
   matcher_t(u32_t mask, u32_t pattern, sp_t<instruction_t> (*matcher)(u32_t))
      :hit_count(0)
      ,mask((pattern <= 0xffff) ? (mask | 0xffff0000) : mask)
      ,pattern(pattern)
      ,matcher(matcher)
   {
   }

   bool matches(u32_t word) const
   {
      return (mask & word) == pattern;
   }

   sp_t<instruction_t> match(u32_t word)
   {
      if (matches(word))
      {
         ++hit_count;
         return matcher(word);
      }
      return nullptr;
   }
   u64_t hit_count;
   u32_t mask;
   u32_t pattern;
   sp_t<instruction_t> (*matcher)(u32_t);
};
