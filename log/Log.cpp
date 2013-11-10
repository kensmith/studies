#include "Log.h"
#include "LogToStreams.h"
#include "TimeThreeWays.h"

#include <string>
#include <sstream>

// Implementation

Log::Log()
{
}

// Flushes the accumulated string to the destination(s).
Log::~Log()
{
   if (level >= Level())
   {
      os << std::endl;

      LogTo* logto = To();

      if (logto)
      {
         logto->Output (os.str());
      }
   }
}

LogTo* Log::To()
{
   // Allow this LogToStreams instance to leak in the event
   // that the end users changes it.  It'll be ok.
   static LogTo* logto = new LogToStreams();
   return logto;
}

bool& Log::PrintLevel()
{
   static bool printlevel = true;
   return printlevel;
}

// Returns the accumulator for end user manipulation.
std::ostringstream& Log::Get (LogLevel lvl)
{
   std::string (*tfunc) () = Log::TimeFunc();

   os << Prefix()
   << (tfunc ? tfunc() : "");

   if (Log::PrintLevel())
   {
      os
      << " "
      << ( (lvl == info || lvl == warn) ? " " : "")
      << Log::Level (lvl)
      << ": "
      << (lvl == warn ? "`` " : "")
      << (lvl == error ? "```` " : "")
      << (lvl == fatal ? "```````` " : "");
   }

   // Adds backtick characters for easier grepping of the more serious
   // log messages.

   this->level = lvl;

   return os;
}

// Returns the static log level whose setting affects
// all logging in a given binary image.
LogLevel& Log::Level()
{
   static LogLevel CurrentLogLevel = trace;
   return CurrentLogLevel;
}

// Returns the textual name for a log level.
std::string Log::Level (LogLevel lvl)
{
   if (lvl <= lowest)
   {
      Log().Get (warn)
      << "Logging lvl, '"
      << lvl
      << "', too low. Raising to trace."
      << std::endl;
   }

   if (lvl >= highest)
   {
      Log().Get (warn)
      << "Logging lvl, '"
      << lvl
      << "', too high. Lowering to fatal."
      << std::endl;
   }

   return LogLevelStrings[lvl];
}

// Returns the log level for a given string.
LogLevel Log::Level (const std::string& level)
{
   if (level == "trace") return trace;
   if (level == "debug") return debug;
   if (level == "info") return info;
   if (level == "warn") return warn;
   if (level == "error") return error;
   if (level == "fatal") return fatal;

   Log().Get (warn)
   << "Unknown logging level, '"
   << level
   << "'. Using trace.";

   return trace;
}

// Allows the end user to provide a function to format time.
std::string (*&Log::TimeFunc()) ()
{
   static std::string (*MyTimeFunc) () = TimeThreeWays;
   return MyTimeFunc;
}

std::string& Log::Prefix()
{
   static std::string prefix = "- ";
   return prefix;
}
