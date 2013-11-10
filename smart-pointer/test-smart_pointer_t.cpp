#include ".test.hpp"
#include "smart_pointer_t.hpp"

bool thing_destructed = false;

struct thing_t
{
   thing_t(int x)
      :x_(x)
   {}

   ~thing_t()
   {
      thing_destructed = true;
   }

   int x() const
   {
      return x_;
   }
private:
   int x_;
};

TEST(basic)
{
   thing_destructed = false;
   {
      smart_pointer_t<thing_t> thing(new thing_t(10));
      EQ(10, thing->x());
      EQ(false, thing_destructed);
   }

   EQ(true, thing_destructed);
}

TEST(copying)
{
   thing_destructed = false;
   {
      smart_pointer_t<thing_t> first_thing(new thing_t(12));
      {
         smart_pointer_t<thing_t> thing = first_thing;
         EQ(12, thing->x());
         EQ(false, thing_destructed);
      }

      EQ(false, thing_destructed);
   }
   EQ(true, thing_destructed);
}

TEST(assignment)
{
   thing_destructed = false;
   {
      smart_pointer_t<thing_t> first_thing(new thing_t(12));
      {
         smart_pointer_t<thing_t> thing(nullptr);
         thing = first_thing;
         EQ(12, thing->x());
         EQ(false, thing_destructed);
      }

      EQ(false, thing_destructed);
   }
   EQ(true, thing_destructed);
}

TEST(copy_tree)
{
   smart_pointer_t<thing_t> a(new thing_t(12));
   {
      smart_pointer_t<thing_t> b(a);
      smart_pointer_t<thing_t> c(a);
      smart_pointer_t<thing_t> d(a);
      EQ(4, a.reference_count());
      EQ(4, b.reference_count());
      EQ(4, c.reference_count());
      EQ(4, d.reference_count());
   }
   EQ(1, a.reference_count());
}

TEST(copy_chain)
{
   smart_pointer_t<thing_t> a(new thing_t(12));
   {
      smart_pointer_t<thing_t> b(a);
      smart_pointer_t<thing_t> c(b);
      smart_pointer_t<thing_t> d(c);
      EQ(4, a.reference_count());
      EQ(4, b.reference_count());
      EQ(4, c.reference_count());
      EQ(4, d.reference_count());
   }
   EQ(1, a.reference_count());
}
