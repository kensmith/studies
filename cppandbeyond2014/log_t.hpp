/**
 * @file
 * Logging for C++. Heavily inspired by Petru Marginean's
 * article.
 *
 * http://www.drdobbs.com/cpp/logging-in-c/201804215.
 *
 * @copyright Ken Smith kgsmith at gmail.com, 2013.
 * @license This software is released under the Boost
 * Software License, version 1.0.
 * See LICENSE_1_0.txt or
 * http://www.boost.org/LICENSE_1_0.txt
 */

#pragma once

#include <cstdio>
#include <sstream>
#include <ctime>
#include <algorithm>

enum log_levels_t
{
   iii,
   eee
};

struct log_t
{
   log_t(log_levels_t lvl)
      :lvl_(lvl)
   {
      struct timespec ts = {0, 0};
      clock_gettime(CLOCK_MONOTONIC, &ts);
      time_t now = std::time(NULL);
      
      ss_
         << ((lvl) == log_levels_t::eee ? "eee" : "iii")
         << ","
         << now
         << ","
         << ts.tv_sec
         << ","
         << ts.tv_nsec
         << ",";
   }

   ~log_t()
   {
      if (threshold() <= lvl_)
      {
         fprintf(stdout, "%s\n", ss_.str().c_str());
         fflush(stdout);
      }
   }

   static log_levels_t & threshold()
   {
      static log_levels_t threshold = iii;
      return threshold;
   }

   std::stringstream & get()
   {
      return ss_;
   }
private:
   const log_levels_t lvl_;
   std::stringstream ss_;
};

#define ooo(lvl)\
   if (log_t::threshold() > (lvl))\
      ;\
   else\
      log_t(lvl).get()\
         << __FILE__\
         << ","\
         << __LINE__\
         << ","\
         << __func__\
         << ","
