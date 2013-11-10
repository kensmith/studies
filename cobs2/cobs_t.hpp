#pragma once

#include <vector>

struct cobs_t
{
   template <typename elem_t>
   static void encode(std::vector<elem_t>& elements)
   {
      const int original_length = elements.size();

      elem_t tmp = 0;
      int code_idx = 0;
      for (int i = 0; i < original_length; i++)
      {
         std::swap(tmp, elements[i]);
         ++elements[code_idx];
         if (tmp == 0)
         {
            code_idx = i + 1;
         }
         else
         {
            if (i == original_length - 1)
            {
               ++elements[code_idx];
               elements.push_back(tmp);
            }
            else if (i >= 254 && (((i - code_idx) % 254) == 0))
            {
               code_idx = i;
               elements[code_idx] = 1;
            }
         }
      }
   }
};
