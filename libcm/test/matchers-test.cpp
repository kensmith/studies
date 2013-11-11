#include "matcher_t.hpp"
#include "matchers.hpp"
#include "instructions.hpp"
#include <boost/utility.hpp>
#include <iostream>
#include "stream_saver_t.hpp"
#define BOOST_TEST_DYN_LINK
#define BOOST_TEST_MAIN
#include <boost/test/unit_test.hpp>
#include "test.hpp"

#if 0
// TODO next step, make pipeline do the work of converting
// code halfwords into runnable instructions.

sp_t<instruction_t> decode(u32_t word)
{
   sp_t<matcher_t> * matcher = matchers;
   bool first_pass = true;
   while ((*matcher).get() != nullptr)
   {
      sp_t<instruction_t> instruction = (*matcher)->match(word);
      if (
         !first_pass
            &&
         (*matcher)->hit_count > (*(matcher - 1))->hit_count
      )
      {
         // most frequently used instructions bubble up
         std::swap(*matcher, *(matcher-1));
      }
      if (instruction) return instruction;
      ++matcher;
      first_pass = false;
   }
   return nullptr;
}

sp_t<instruction_t> predecode(u16_t halfword)
{
   static u16_t high_halfword = 0;
   u16_t signature = halfword >> 11;
   if (high_halfword != 0)
   {
      u32_t word = halfword;
      word |= high_halfword << 16;
      high_halfword = 0;
      return decode(word);
   }
   else if (
      signature == 0x1d
         ||
      signature == 0x1e
         ||
      signature == 0x1f
   )
   {
      high_halfword = halfword;
      return sp_t<instruction_t>();
   }
   else
   {
      return decode(halfword);
   }
}
#endif

TEST(basic)
{
#if 0
   sp_t<instruction_t> i;
   //EQ((instruction_t*)(0), i);
   // 32 bits
   i = predecode(0xeb40_u);
   i = predecode(0x0000_u);
   sstr_t ss;
   ss << i->name();
   EQ("adc_register_t2_t", ss.str());

   // 16 bits
   i = predecode(0x0800_u);
   ss.str("");
   ss << i->name();
   EQ("lsr_immediate_t1_t", ss.str());

   i = predecode(0x0000_u);
   ss.str("");
   ss << i->name();
   EQ("lsl_immediate_t1_t", ss.str());

   i = predecode(0x0000_u);
   ss.str("");
   ss << i->name();
   EQ("lsl_immediate_t1_t", ss.str());

   i = predecode(0x1000_u);
   ss.str("");
   ss << i->name();
   EQ("asr_immediate_t1_t", ss.str());

   i = predecode(0x1800_u);
   ss.str("");
   ss << i->name();
   EQ("add_register_t1_t", ss.str());

   i = predecode(0x4400_u);
   ss.str("");
   ss << i->name();
   EQ("add_register_t2_t", ss.str());

   i = predecode(0x1a00_u);
   ss.str("");
   ss << i->name();
   EQ("sub_register_t1_t", ss.str());
#endif
}
