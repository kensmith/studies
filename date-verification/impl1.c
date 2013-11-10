#include "impl1.h"

const char days_per_month[] = {31,28,31,30,31,30,31,31,30,31,30,31};
int validate_time1(struct tm *ptm)
{
  char max_days;
  if ((ptm->tm_hour<0)||(ptm->tm_hour>23))           // return on any invalid data
    return(1);
  if ((ptm->tm_min<0)||(ptm->tm_min>59))
    return(1);
  if ((ptm->tm_sec<0)||(ptm->tm_sec>59))
    return(1);
  if (ptm->tm_mday<1)
    return(1);
  if ((ptm->tm_year<106)||(ptm->tm_year>200))
    return(1);

  max_days = days_per_month[ptm->tm_mon - 1];
  if (ptm->tm_mon == 2)
  {
      if (ptm->tm_year%4 == 0 && ptm->tm_year%100 != 0)
      {
        ++max_days;
      }
  }
  if (ptm->tm_mday > max_days)
  {
    return 1;
  }

  return 0;
}
