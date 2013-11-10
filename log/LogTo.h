#ifndef __LOG_TO_H__
#define __LOG_TO_H__

///@file

#include <string>

///Interface for a log file destination.
class LogTo
{
public:
   virtual ~LogTo() = 0;
   virtual void Output (const std::string& msg) = 0;
};

#endif // __LOG_TO_H__
