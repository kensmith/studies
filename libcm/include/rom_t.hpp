#pragma once

#include <cstdio>
#include <exception>

struct rom_t
{
   rom_t(const char * filename)
      :f_(fopen(filename, "r"))
   {
   }

   void rewind()
   {
      std::fseek(f_, 0, 0);
   }

   u32_t next_word() const
   {
      char b[4];
      sz_t read_length = std::fread(b, 1, array_len(b), f_);
      ensure(read_length == array_len(b));
      u32_t word = *reinterpret_cast<u32_t*>(b); // TODO endian
      return word;
   }

   u32_t operator[](u32_t address) const
   {
      return word_at(address);
   }

   u16_t next_halfword() const
   {
      char b[2];
      sz_t read_length = std::fread(b, 1, array_len(b), f_);
      ensure(read_length == array_len(b));
      u16_t word = *reinterpret_cast<u16_t*>(b); // TODO endian
      return word;
   }

   u16_t halfword_at(u32_t address) const
   {
      ensure((address & 1) == 0);
      int result = std::fseek(f_, address, 0);
      ensure(result == 0);
      return next_halfword();
   }

   u32_t word_at(u32_t address) const
   {
      ensure((address & 3) == 0);
      int result = std::fseek(f_, address, 0);
      ensure(result == 0);
      return next_word();
   }

   u32_t stack_top() const
   {
      return word_at(0);
   }

   u32_t reset_vector() const
   {
      return word_at(4);
   }

   bool checksum_valid() const
   {
      u32_t sum = word_at(0);
      for (int i = 0; i < 6; i++)
      {
         sum += next_word();
      }
      u32_t checksum = next_word();
      u32_t result = sum + checksum;
      return result == 0;
   }

   ~rom_t()
   {
      fclose(f_);
   }
private:
   FILE * f_;
};
