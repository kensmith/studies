#pragma once

#include <cstdint>
#include <memory>
#include <string>
#include <sstream>
#include <deque>
#include <vector>
#include <exception>
#include <boost/utility.hpp>

using u8_t = std::uint8_t;
using u16_t = std::uint16_t;
using u32_t = std::uint32_t;
using u64_t = std::uint64_t;

using s8_t = std::int8_t;
using s16_t = std::int16_t;
using s32_t = std::int32_t;
using s64_t = std::int64_t;

using sz_t = std::size_t;
template <typename T> using sp_t = std::shared_ptr<T>;
template <typename T> using dq_t = std::deque<T>;
template <typename T> using vec_t = std::vector<T>;
using ex_t = std::exception;
using str_t = std::string;
using sstr_t = std::stringstream;

inline u16_t operator "" _u(unsigned long long value)
{
   return static_cast<u16_t>(value);
}

inline s16_t operator "" _s(unsigned long long value)
{
   return static_cast<s16_t>(value);
}

#define array_len(a) (sizeof(a)/sizeof((a)[0]))
#define ensure(pred) if (!(pred)) throw std::exception()
#define bb(x) BOOST_BINARY(x)

// from hakmem. parallel bit counting
inline u32_t count_bits(u64_t x)
{
   const u64_t tmp =
      x - ((x >> 1) & 0x7777777777777777ULL)
      - ((x >> 2) & 0x3333333333333333ULL)
      - ((x >> 3) & 0x1111111111111111ULL);

   const u64_t value =
      ((tmp + (tmp >> 4)) & 0x0f0f0f0f0f0f0f0fULL) % 0xff;

   return value;
}

