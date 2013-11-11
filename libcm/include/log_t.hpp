#pragma once

#include <cstdio>

enum log_levels_t
{
   all,
   info,
   warn,
   err,
   none,
};

struct log_t
{
   log_t(log_levels_t lvl)
      :lvl_(lvl)
   {
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
      static log_levels_t threshold = all;
      return threshold;
   }

   sstr_t & get()
   {
      return ss_;
   }
private:
   const log_levels_t lvl_;
   sstr_t ss_;
};

#define ooo(lvl)\
   if (log_t::threshold() > lvl)\
      ;\
   else\
      log_t(lvl).get()\
         << __func__\
         << ":"\
         << __LINE__\
         << ":"
