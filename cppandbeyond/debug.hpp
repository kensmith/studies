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
