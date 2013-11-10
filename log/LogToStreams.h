#ifndef __LOG_TO_STREAM_H__
#define __LOG_TO_STREAM_H__

///@file

#include <cstdio>
#include <string>

#include "LogTo.h"

///Log destination which sends its output to one or two
///streams.
class LogToStreams : public LogTo
{
public:
   ///Allows LogToStreams user to change the destination stream.
   ///eg. LogToStreams::Primary() = fopen("log.txt", "a");
   static FILE*& Primary();

   ///The second stream, optionally disabled by setting to
   ///0.
   static FILE*& Secondary();

   ///Write a string to all open streams.
   ///Called by Log::~Log()
   ///@param[in] msg the message to send to the streams.
   void Output (const std::string& msg);
};


#endif // __LOG_TO_STREAM_H__
