/**
 * @file
 * @copyright Ken Smith kgsmith at gmail.com, 2013.
 * @license This software is released under the Boost
 * Software License, version 1.0.
 * See LICENSE_1_0.txt or
 * http://www.boost.org/LICENSE_1_0.txt
 */

#pragma once

#define TEST BOOST_AUTO_TEST_CASE
#define FTST BOOST_FIXTURE_TEST_CASE
#define EQ BOOST_REQUIRE_EQUAL
#define NE BOOST_REQUIRE_NE
#define THROW BOOST_REQUIRE_THROW
#define NO_THROW BOOST_REQUIRE_NO_THROW

#include <iostream>
#include <string>
#include <vector>
#include "stream_saver_t.hpp"

inline std::string vecstr(const std::vector<char>& rhs)
{
   std::string s(rhs.begin(), rhs.end());
   return s;
}

inline std::vector<char> vecstr(const std::string& rhs)
{
   std::vector<char> v(rhs.begin(), rhs.end());
   return v;
}

inline std::ostream& operator<<(std::ostream& os, const std::vector<char>& rhs)
{
   stream_saver_t saver(os);

   os
      << "["
      << rhs.size()
      << "]"
      << std::hex << "{";
   for (char byte : rhs)
   {
      os << "0x" << uint32_t(uint8_t(byte)) << ",";
   }
   os << "}";

   return os;
}
