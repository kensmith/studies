#include ".test.hpp"

struct scoped_exit_t
{
   ~scoped_exit_t();
};

#define scoped_exit()\
   []

void foo()
{
   sentinel("");
   scoped_exit()
   {
      ooo(iii)
         << "scoped exit finished";
   };
}
   

TEST(basic)
{
}
