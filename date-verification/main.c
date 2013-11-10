#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include "impl0.h"
#include "impl1.h"

#if 0
   struct tm {
       int tm_sec;         /* seconds */
       int tm_min;         /* minutes */
       int tm_hour;        /* hours */
       int tm_mday;        /* day of the month */
       int tm_mon;         /* month */
       int tm_year;        /* year */
       int tm_wday;        /* day of the week */
       int tm_yday;        /* day in the year */
       int tm_isdst;       /* daylight saving time */
   };
#endif

void check(struct tm* sample)
{
    int original_implementation = validate_time0(sample);
    int new_implementation = validate_time1(sample);
    char* original_preference = original_implementation ? "doesn't like" : "likes";
    char* new_preference = new_implementation ? "doesn't like" : "likes";
    if (original_implementation != new_implementation)
    {
        printf("original implementation %s and new implementation %s %s\n",
            original_preference,
            new_preference,
            asctime(sample)
        );
        exit(1);
    }
    else
    {
        printf("%s %s", original_preference, asctime(sample));
    }
    fflush(stdout);
}

int main()
{
    struct tm known_good;
    known_good.tm_sec = 1;
    known_good.tm_min = 1;
    known_good.tm_hour = 1;
    known_good.tm_mday = 1;
    known_good.tm_mon = 1;
    known_good.tm_year = 110;
    known_good.tm_wday = 1;
    known_good.tm_yday = 1;
    known_good.tm_isdst = 1;

    struct tm sample = known_good;
    for (sample.tm_sec = -60; sample.tm_sec < 90; ++sample.tm_sec)
    {
        check(&sample);
    }

    printf("\n\n");
    sample = known_good;
    for (sample.tm_min = -60; sample.tm_min < 90; ++sample.tm_min)
    {
        check(&sample);
    }

    printf("\n\n");
    sample = known_good;
    for (sample.tm_hour = -60; sample.tm_hour < 90; ++sample.tm_hour)
    {
        check(&sample);
    }

    printf("\n\n");
    sample = known_good;
    for (sample.tm_mday = -15; sample.tm_mday < 35; ++sample.tm_mday)
    {
        check(&sample);
    }

    printf("\n\n");
    sample = known_good;
    sample.tm_year = 96;
    for (sample.tm_mday = -15; sample.tm_mday < 35; ++sample.tm_mday)
    {
        check(&sample);
    }

    return 0;
}
