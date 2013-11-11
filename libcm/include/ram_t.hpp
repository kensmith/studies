#pragma once

#include <vector>
#include <cstring>

struct region_t
{
   region_t(u32_t start, u32_t end)
      :start_(start)
      ,end_(end)
      ,size_(end - start + 1)
      ,memory_(/*new u8_t[size_]*/)
   {
      //std::memset(memory_, 0, size_);
   }
   ~region_t()
   {
      //delete [] memory_;
   }
   void write_word(u32_t address, u32_t word)
   {
      ensure(contains(address));
      address -= start_;
      ensure(0 <= address && address < size_);
      for (int i = 0; i < 4; i++, address++, word >>= 8)
      {
         // TODO this is hard coded for little endian
         //memory_[address] = word & 0xff;
      }
   }
   u32_t read_word(u32_t address)
   {
      ensure(contains(address));
      address -= start_;
      ensure(0 <= address && address < size_);
      u32_t result = 0;
      for (int i = 0; i < 4; i++, address++, result <<= 8)
      {
         //result |= memory_[address];
      }
   }
   bool contains(u32_t address) const
   {
      return start_ <= address && address <= end_;
   }
private:
   u32_t start_;
   u32_t end_;
   u32_t size_;
   u8_t * memory_;
};

struct ram_t
{
   ram_t()
   {
   }

   void new_region(u32_t start, u32_t end)
   {
      sp_t<region_t> region = sp_t<region_t>(new region_t(start, end));
      regions_.push_back(region);
   }

   void write_word(u32_t address, u32_t word)
   {
      for (sp_t<region_t> region : regions_)
      {
         if (region->contains(address))
         {
            region->write_word(address, word);
         }
      }
   }

   u32_t read_word(u32_t address)
   {
      for (sp_t<region_t> region : regions_)
      {
         if (region->contains(address))
         {
            region->read_word(address);
         }
      }
   }

private:
   std::vector<sp_t<region_t>> regions_;
};
