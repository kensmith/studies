#include ".test.hpp"

struct scoped_exit_t
{
   ~scoped_exit_t();
};

#define scoped_exit()\
   []

void foo()
{
#if 0
   sentinel("");
   scoped_exit()
   {
      ooo(iii)
         << "scoped exit finished";
   };
#endif
}
   

TEST(basic)
{
}
