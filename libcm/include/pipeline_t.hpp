#pragma once

#include "instruction_t.hpp"
#include "stream_saver_t.hpp"
#include "matchers.hpp"
#include "log_t.hpp"

#include <algorithm>

struct pipeline_t
{
   pipeline_t(int size, vec_t<sp_t<matcher_t>> & matchers_vec)
      :size_(size)
      ,matchers_(matchers_vec)
   {
      ensure(size > 0);

      // decreasing order of significant bits in the mask
      std::sort(
         matchers_.begin(),
         matchers_.end(),
         [](const sp_t<matcher_t> & lhs, const sp_t<matcher_t> & rhs)
         {
            return count_bits(lhs->mask) > count_bits(rhs->mask);
         }
      );
   }

   sp_t<instruction_t> insert(u16_t halfword)
   {
      static u16_t high_halfword = 0;

      u16_t opcode_signature = halfword >> 11;
      sp_t<instruction_t> new_i;
      if (high_halfword != 0)
      {
         new_i = decode(high_halfword, halfword);
         ensure(new_i.get() != nullptr);
         high_halfword = 0;
      }
      else if (
         opcode_signature == 0x1d
         ||
         opcode_signature == 0x1e
         ||
         opcode_signature == 0x1f
      )
      {
         high_halfword = halfword;
      }
      else
      {
         new_i = decode(halfword);
         ensure(new_i.get() != nullptr);
      }

      sp_t<instruction_t> result;
      if (new_i.get() != nullptr)
      {
         q_.push_back(new_i);
         if (q_.size() >= size_)
         {
            result = q_.front();
            q_.pop_front();
         }
      }

      return result;
   }
   friend std::ostream & operator<<(std::ostream & os, const pipeline_t & p);
private:
   sp_t<instruction_t> decode(u16_t most, u16_t least)
   {
      u32_t word = (most << 16) | least;
      return decode(word);
   }

   sp_t<instruction_t> decode(u32_t word)
   {
      auto match_iter = std::find_if(
         matchers_.begin(),
         matchers_.end(),
         [=](const sp_t<matcher_t> & matcher)
         {
            return matcher->matches(word);
         }
      );
      sp_t<instruction_t> instruction = (*match_iter)->match(word);
      return instruction;
   }

   // deque rather than queue because I want to be able to
   // iterate over the contents for printing, etc.
   dq_t<sp_t<instruction_t>> q_;
   int size_;
   vec_t<sp_t<matcher_t>> & matchers_;
};

std::ostream & operator<<(std::ostream & os, const pipeline_t & p)
{
   stream_saver_t saver(os);

   os << "pipeline_t<"
      << p.size_
      << ">{";
   for (const auto &i : p.q_)
   {
      os << i << ", ";
   }
   os << "}";

   return os;
}

