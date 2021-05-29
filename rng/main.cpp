#include <linux/random.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>

#include "stream_saver_t.hpp"
#include "log_t.hpp"
#include "debug.hpp"

int main()
{
  int r = open("/dev/random", O_RDWR);
  int c = ioctl(r, RNDCLEARPOOL, 0);
  ooo(iii) << "ioctl -> " << c;
  return 0;
}
