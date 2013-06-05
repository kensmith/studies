#include <iostream>

template <typename T>
struct singleton_t
{
   T& get()
   {
      static T t_;
      return t_;
   }
};

struct foo_t;

using foosing_t = singleton_t<foo_t>;

struct foo_t
{
   void rock_out()
   {
      std::cout << "x = " << ++x << std::endl;
   }
private:
   friend foosing_t;
   foo_t() {}

   int x = 0;
};

int do_stuff()
{
   std::cout << "in do_stuff" << std::endl;
   foosing_t fs;
   foo_t& f = fs.get();
   f.rock_out();
}

int main()
{
#if 0
   foo_t f; // error. foo_t() is private. only foosing_t can instantiate a foo_t.
#endif
   foosing_t fs;
   fs.get().rock_out();
   fs.get().rock_out();
   fs.get().rock_out();
   do_stuff();
   return 0;
}
