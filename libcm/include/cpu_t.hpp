#pragma once

#include "rom_t.hpp"
#include "i_t.hpp"
#include "pipeline_t.hpp"
#include "instruction_t.hpp"
#include "stream_saver_t.hpp"
#include "ram_t.hpp"
#include "field_t.hpp"

#include <boost/utility.hpp>

#define unpredictable(i) \
do { \
   stream_saver_t saver(std::cout); \
   std::cout \
      << "unpredictable:" \
      << __FILE__ \
      << ":" \
      << __LINE__ \
      << ":" \
      << __func__ \
      << ":0x" \
      << std::hex \
      << i \
      << std::endl; \
} while (0)

#define undefined(i) \
do { \
   stream_saver_t saver(std::cout); \
   std::cout \
      << "undefined:" \
      << __FILE__ \
      << ":" \
      << __LINE__ \
      << ":" \
      << __func__ \
      << ":0x" \
      << std::hex \
      << i \
      << std::endl; \
} while (0)

#define unimplemented(i) \
do { \
   stream_saver_t saver(std::cout); \
   std::cout \
      << "unimplemented:" \
      << __FILE__ \
      << ":" \
      << __LINE__ \
      << ":" \
      << __func__ \
      << ":0x" \
      << std::hex \
      << i \
      << std::endl; \
} while (0)

struct imm_carry_t
{
   u32_t imm32;
   u32_t c;
};

std::ostream & operator<<(std::ostream & os, const imm_carry_t & immc)
{
   stream_saver_t saver(os);

   os << "imm_carry_t(0x"
      << std::hex
      << immc.imm32
      << ", "
      << immc.c
      << ")";

   return os;
}

bool operator==(const imm_carry_t & lhs, const imm_carry_t & rhs)
{
   return (lhs.imm32 == rhs.imm32) && (lhs.c == rhs.c);
}

struct cpu_t
{
   cpu_t(const char * filename)
      :r{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,}
      ,carry_flag(0)
      ,rom_(filename)
   {
      reset();
   }

   void reset()
   {
      sp() = initial_stack_pointer();
      pc() = reset_vector();
#if 0
      // TODO generalize this. this is from lpc17xx
      ram_.new_region(0x10000000, 0x1007ffff);
      ram_.new_region(0x2007ffff, 0x2007c000);
      ram_.new_region(0x20083fff, 0x20080000);
#endif
   }

   void stepi()
   {
   }

   imm_carry_t thumb_expand_imm_c(u32_t i, u32_t imm3, u32_t imm8, u32_t c)
   {
      imm_carry_t immc = {0, c};
      i &= 1;
      imm3 &= 7;
      imm8 &= 0xff;

      int32_t a = 1 & (imm8 >> 7);

      int32_t iimm3a = i << 4;
      iimm3a |= imm3 << 1;
      iimm3a |= a;

      int32_t imm12 = i << 11;
      imm12 |= imm3 << 8;
      imm12 |= imm8;

      u32_t imm12_high_two = imm12 >> 10;

      // Table A5-11
      if (0 == imm12_high_two)
      {
         if (0 == imm3)
         {
            // 00000000 00000000 00000000 abcdefgh
            immc.imm32 = imm8;
         }
         else if (1 == imm3)
         {
            // 00000000 abcdefgh 00000000 abcdefgh (b)
            if (0 == imm8)
            {
               unpredictable(imm12);
            }
            immc.imm32 = imm8 << 16;
            immc.imm32 |= imm8;
         }
         else if (2 == imm3)
         {
            // abcdefgh 00000000 abcdefgh 00000000 (b)
            if (0 == imm8)
            {
               unpredictable(imm12);
            }
            immc.imm32 = imm8 << 24;
            immc.imm32 |= imm8 << 8;
         }
         else if (3 == imm3)
         {
            // abcdefgh abcdefgh abcdefgh abcdefgh b
            if (0 == imm8)
            {
               unpredictable(imm12);
            }
            immc.imm32 = imm8 << 24;
            immc.imm32 |= imm8 << 16;
            immc.imm32 |= imm8 << 8;
            immc.imm32 |= imm8;
         }
      }
      else
      {
         // iimm3a   xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
         // 01000    1bcdefgh 00000000 00000000 00000000
         // 01001    01bcdefg h0000000 00000000 00000000
         // 01010    001bcdef gh000000 00000000 00000000
         // 01011    0001bcde fgh00000 00000000 00000000
         // ...
         // 11101    00000000 00000000 000001bc defgh000
         // 11110    00000000 00000000 0000001b cdefgh00
         // 11111    00000000 00000000 00000001 bcdefgh0
         immc.imm32 = 0x80 | imm8;
         immc.imm32 <<= 32 - iimm3a;
         if (0 != (immc.imm32 & 0x80000000))
         {
            // ror_c ARM A2.2.1
            carry_flag = 1;
            immc.c = 1;
         }
      }

      return immc;
   }

   u32_t r[16];
   u32_t & sp() { return r[13]; }
   u32_t & lr() { return r[14]; }
   u32_t & pc() { return r[15]; }
   u32_t carry_flag;

private:
   bool in_it_block() const
   {
      return false;
   }

   bool last_in_it_block() const
   {
      return false;
   }

   pipeline_t pipeline_;
   rom_t rom_;
   ram_t ram_;

   u32_t initial_stack_pointer() const
   {
      return rom_[0];
   }

   u32_t reset_vector() const
   {
      return rom_[4];
   }

   u32_t current_instruction_address()
   {
      return pc() &= ~1;
   }
};
