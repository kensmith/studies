#include "LogToStreams.h"

#include <cstdio>
#include <string>

FILE*& LogToStreams::Primary()
{
   static FILE* stream = stdout;
   return stream;
}

FILE*& LogToStreams::Secondary()
{
   static FILE* stream = 0;
   return stream;
}

void LogToStreams::Output (const std::string& msg)
{
   FILE* main = Primary();
   if (main)
   {
      fprintf (main, "%s", msg.c_str());
      fflush (main);
   }

   FILE* auxillary = Secondary();
   if (auxillary)
   {
      fprintf (auxillary, "%s", msg.c_str());
      fflush (auxillary);
   }
}

