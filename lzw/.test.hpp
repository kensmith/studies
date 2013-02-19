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
#define GT BOOST_REQUIRE_GT
#define GE BOOST_REQUIRE_GE
#define LT BOOST_REQUIRE_LT
#define LE BOOST_REQUIRE_LE
#define THROW BOOST_REQUIRE_THROW
#define NO_THROW BOOST_REQUIRE_NO_THROW

#include <iostream>
#include <string>
#include <vector>
#include <limits>
#include "stream_saver_t.hpp"
