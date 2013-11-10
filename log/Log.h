#ifndef __LOG_H__
#define __LOG_H__

#include <sstream>
#include <string>

#include "LogTo.h"

///@file
///Heavily inspired by Petru Marginean's Sept 5, 2007
///article in DDJ, http://www.ddj.com/cpp/201804215?pgno=1,
///and by log4j.  At the time of implementation, Dec 2007,
///log4cxx was not mature and had not had an official
///release in three years.  It appeared to be maintained by
///a lone developer at the Apache foundation.  log4cpp was
///out of date and they have had no activity in five years.
///log4cplus is also out of date and hasn't released in
///three years.  A final contestant, dlib, appears to be a
///Boost wannabe and was condemned when, in order to build
///its simplest logging example, I could not link the
///example without also linking in libX11 as well as the
///entirety of dlib's source.o, a 1.9MB object.  At the time
///of this writing, that would more than double the linked
///size of a debug build of libcalxs.
///
///Usage:
///@code
///##include "Log.h"
///##include "LogToStreams.h"
///##include "TimeThreeWays.h"
///
///LogToStreams::Primary() = fopen("log.txt","a");
///Log::TimeFunc() = TimeThreeWays // this is the default actually
///ooo_level(debug);    // or: ooo_level_from_string("debug");
///ooo(debug) << "hello number " << 1.1;
///ooo(debug) << "that's interesting";
///@endcode
///
///Postprocessing examples:
///
///@code hello.txt
///- Dec 12 12:13:03 <1197490383.613148> [1457,262688]  info: /Users/ksmith/svn/ca/LogTest/trunk/src/main.cpp:43: hello
///- Dec 12 12:13:03 <1197490383.613829> [1457,262688] fatal: ```````` /Users/ksmith/svn/ca/LogTest/trunk/src/main.cpp:44: good bye
///@endcode
///
///Postprocessing to remove Unix epoch time
///@code
///cat hello.txt | sed -e 's/<.*> \[/[/'
///@endcode
///
///Postprocessing to remove GPS time
///@code
///cat hello.txt | sed -e 's/> \[.*\]/>/'
///@endcode
///
///Postprocessing to remove all time indicators
///
///@code
///cat hello.txt|sed -e 's/.* <.*> \[.*\] //'
///@endcode
///
///This one in particular can help when diffing two log files from different
///runs.  Without eliminating the timestamps, every line will be different
///because the timestamps will be different and non-trivial differences will be
///obscured.
///
///If you're directly postprocessing terminal output, remember that the default
///behavior of Log is to send its output to stderr.  You may have to do
///something like this to filter output directly from a program.
///
///@code
///./prog 2>&1 | sed ...
///@endcode
///
///The 2>&1 redirects stderr to stdout allowing the log data to flow into the
///sed pipe.
///
///Postprocessing to extract only log lines from mixed output
///
///@code
///cat hello.txt | grep ^-
///@endcode
///
///Performance will be better when using these macros.  Beware not to stream
///items with side effects because their side effects will not happen if the
///log level is below the threshold.
///The main logging interface.
///Note,
///
///@code
///ooo(level) "Message";
///@endcode
///
///is legal but not recommended.  Prefer
///
///@code
///ooo(level) << "Message";
///@endcode
///
///@author Ken Smith <ksmith@norbelle.com>

#if defined(__GNUC__) && !defined(LOG_OMIT_FUNC_LINE)
///Stream text to the log.
///@param[in] level log level.
#  define ooo(level) \
   if (Log::Level() > level) \
      ; \
   else \
      Log().Get(level) \
      << __func__ \
      << ":" \
      << __LINE__ \
      << ": "
#else
///Stream text to the log.
///@param[in] level log level.
#  define ooo(level) \
   if (Log::Level() > level) \
      ; \
   else \
      Log().Get(level) \
      << ""
#endif

///Set the threshold over which to show messages.  Messages
///logged below this level are suppressed.
///@param[in] level the threshold level.
#define ooo_level(level) \
   do \
   { \
      Log::Level() = level; \
      ooo(debug) \
      << "Showing log messages at or above " \
      << Log::Level(level); \
   } while(0)

///Same as log_level but takes a string instead of the enum.
///Set the threshold over which to show messages.  Messages
///logged below this level are suppressed.
///@param[in] level the threshold level as a string.
#define ooo_level_from_string(level) \
   do \
   { \
      Log::Level() = \
         Log::Level(std::string(level)); \
      ooo(debug) \
      << "Showing log messages at or above " \
      << Log::Level( \
                     Log::Level() \
                   ); \
   } while (0)

///Valid log levels.
enum LogLevel
{
   lowest,///<Sentinel value, not a valid log level.
   trace,///<Lowest priority.
   debug,///<Next highest priority.
   info,///<Next highest priority.
   warn,///<Next highest priority.
   error,///<Next highest priority.
   fatal,///<Highest priority.
   highest///<Sentinel value, not a valid log level.
};

///Names of the log levels.  All values are matched to those
///in LogLevel.
static const std::string LogLevelStrings[] =
{
   "lowest",
   "trace",
   "debug",
   "info",
   "warn",
   "error",
   "fatal",
   "highest"
};

///The Log class itself.  Instances are short lived.  State
///is maintained in static variables.  Thread safe.
class Log
{
public:
   ///Instantiate.
   Log();

   ///Destroy and flush buffered contents to the log.
   virtual ~Log();

   ///@return a handle to the log stream.
   ///@param[in] set the priority of this log instance.
   std::ostringstream& Get (LogLevel level = info);
public:
   ///Get or set the current log level.
   ///@return handle to static log level.
   static LogLevel& Level();

   ///Get the string version of any log level.
   ///@param[in] level log level.
   ///@return the textual name.
   static std::string Level (LogLevel level);

   ///Get the log level from its textual name.
   ///@param[in] level the textual name.
   ///@return the log level.
   static LogLevel Level (const std::string& level);

   ///Get or set the function that will be called to render
   ///the current time for each log line.
   ///@return a reference to the function pointer.
   static std::string (*&TimeFunc()) ();

   ///Get or set the prefix that will be written before each
   ///log line.
   ///@return a reference to the static string.
   static std::string& Prefix();

   ///Get or set a flag that chooses whether to display the
   ///level on each line in the log.
   static bool& PrintLevel();

   ///Get or set the desination for log messages.
   ///@return a reference to the desination class, a
   ///subclass of LogTo.
   static LogTo* To();
protected:
   std::ostringstream os;
   LogLevel level;
private:
   Log (const Log&);
   Log& operator= (const Log&);
};
#endif // __LOG_H__
