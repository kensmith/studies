#ifndef __TIME_THREE_WAYS_H__
#define __TIME_THREE_WAYS_H__

///@file

#include "GPS_Time.h"
#include "CoreTime.h"

#include <math.h>
#include <time.h>
#ifndef WIN32
#  include <sys/time.h>
#endif

#include <string>
#include <sstream>

///This function is inlined and defined in the header file
///in order to allow end users to manipulate its compile
///time behavior with the following macros.
///
///Set DONT_LOG_GPS_TIME to avoid including the GPS week and
///seconds into week.  Set DONT_LOG_UNIX_TIME to avoid
///including Unix epoch time.
///
///It always writes the time delimiters even when not
///logging Unix epoch time or GPS time to make automated
///postprocessing of the log files easier.
///
///For postprocessing examples, see Log.h.
///
///@return a fixed width string showing time in up to three
///reckonings, Gregorian, Unix epoch, and GPS epoch.
#ifndef WIN32
inline std::string TimeThreeWays()
{
   struct timeval tv;
   gettimeofday (&tv, NULL);

   time_t now_tt = (time_t) tv.tv_sec;
   struct tm tm;
   localtime_r (&now_tt, &tm);

   std::ostringstream os;
   os.fill ('0');

   switch (tm.tm_mon)
   {
      case 0:
         os << "Jan";
         break;
      case 1:
         os << "Feb";
         break;
      case 2:
         os << "Mar";
         break;
      case 3:
         os << "Apr";
         break;
      case 4:
         os << "May";
         break;
      case 5:
         os << "Jun";
         break;
      case 6:
         os << "Jul";
         break;
      case 7:
         os << "Aug";
         break;
      case 8:
         os << "Sep";
         break;
      case 9:
         os << "Oct";
         break;
      case 10:
         os << "Nov";
         break;
      case 11:
         os << "Dec";
         break;
      default:
         os.width (3);
         os << tm.tm_mon;
         break;
   }
   os << " ";

   os.width (2);
   os << tm.tm_mday;
   os << " ";

   os.width (2);
   os << tm.tm_hour;
   os << ":";

   os.width (2);
   os << tm.tm_min;
   os << ":";

   os.width (2);
   os << tm.tm_sec;
   os << " ";

   double now = tv.tv_sec + tv.tv_usec / 1.0e6;

   os << std::fixed;

   os << "<";
   os << now;

   os << ">";
   os << " ";
   os << "[";

   CGpsTime converter;
   converter.UnixTime(now);

   os << converter.Week();
   os << ",";
   os << (int) converter.Seconds();

   os << "]";

   return os.str();
}
#else
inline std::string TimeThreeWays()
{
   return "";
}
#endif

#endif // __TIME_THREE_WAYS_H__
