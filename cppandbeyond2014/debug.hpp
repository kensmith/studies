#pragma once

#include "log_t.hpp"

#define ensure(pred, msg)\
   do\
   {\
      if (!(pred))\
      {\
         ooo(eee)\
            << "ensure,"\
            << #pred\
            << ","\
            << msg;\
         throw std::exception();\
      }\
   } while (0)

#define show(x)\
   ooo(iii)\
      << #x\
      << " = "\
      << x

#define pp_concatenate_impl(s1, s2) s1##s2
#define pp_concatenate(s1, s2) pp_concatenate_impl(s1, s2)

#define av_uniquifier __LINE__
#ifdef __COUNTER__
#  undef av_uniquifier
#  define av_uniquifier __COUNTER__
#endif

#define anonymous_variable(prefix) pp_concatenate(prefix, av_uniquifier)

struct sentinel_t
{
   sentinel_t(const char* file, int line, const char* function, const char* name = "")
   :file_(file)
   ,function_(function)
   ,name_(name)
   {
      ooo(iii)
         << "entering "
         << file_
         << ":"
         << line
         << ":"
         << function_
         << ":"
         << name_;
   }

   ~sentinel_t()
   {
      ooo(iii)
         << "leaving "
         << file_
         << ":"
         << function_
         << ":"
         << name_;
   }
private:
   const char* const file_;
   const char* const function_;
   const char* const name_;
};

#define sentinel(name)\
   volatile sentinel_t\
   anonymous_variable(anonymous_sentinel)(\
      __FILE__,\
      __LINE__,\
      __PRETTY_FUNCTION__,\
      name\
   )

#define unique_sentinel(name)\
   std::make_unique<sentinel_t>(\
      __FILE__,\
      __LINE__,\
      __PRETTY_FUNCTION__,\
      name\
   )
