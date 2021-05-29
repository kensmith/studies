#pragma once

#include <vector>
#include "log_t.hpp"

#define macro_join_impl(a, b) a ## b
#define macro_join(a, b) macro_join_impl(a, b)

#if defined(__COUNTER__)
#  define anonymous_variable macro_join(anonvar, __COUNTER__)
#else
#  define anonymous_variable macro_join(anonvar, __LINE__)
#endif

template<typename t>
struct showt_t;

#define showt(x) showt_t<decltype(x)> anonymous_variable

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

std::ostream& operator<<(std::ostream& lhs, const std::vector<int>& rhs)
{
    lhs << "{";
    for (std::size_t i = 0; i < rhs.size(); ++i)
    {
        lhs << rhs[i];
        if (i + 1 < rhs.size())
        {
            lhs << ",";
        }
    }
    lhs << "}";
    return lhs;
}
