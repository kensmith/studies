/**
 * @file
 * @copyright Ken Smith kgsmith at gmail.com, 2013.
 * @license This software is released under the Boost
 * Software License, version 1.0.
 * See LICENSE_1_0.txt or
 * http://www.boost.org/LICENSE_1_0.txt
 */

#pragma once

#include <iostream>
#include <iomanip>

struct stream_saver_t
{
   stream_saver_t(std::ostream & os)
      :os_(os)
      ,saved_flags_(os.flags())
   {
   }

   ~stream_saver_t()
   {
      os_.flags(saved_flags_);
   }
private:
   std::ostream & os_;
   std::ios_base::fmtflags saved_flags_;
};

