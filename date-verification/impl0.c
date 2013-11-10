#include "impl0.h"

int validate_time0(struct tm *ptm)
{
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

  switch(ptm->tm_mon)
  {
    case (1):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (2):
      if (ptm->tm_year%4)
      {
        if (ptm->tm_mday>28)
	       return(1);
	     break;
      }
      if (ptm->tm_mday>29)
	     return(1);
      break;
    case (3):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (4):
      if (ptm->tm_mday>30)
        return(1);
      break;
    case (5):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (6):
      if (ptm->tm_mday>30)
        return(1);
      break;
    case (7):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (8):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (9):
      if (ptm->tm_mday>30)
        return(1);
      break;
    case (10):
      if (ptm->tm_mday>31)
        return(1);
      break;
    case (11):
      if (ptm->tm_mday>30)
        return(1);
      break;
    case (12):
      if (ptm->tm_mday>31)
        return(1);
      break;
    default:
      return(1);
  }
  return 0;

}
