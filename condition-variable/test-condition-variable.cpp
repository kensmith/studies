#include ".test.hpp"
#include <boost/thread.hpp>

boost::condition_variable cond;
boost::mutex mut;
bool startup_complete = false;

void startup_task()
{
   cond.notify_all();
   ooo(iii)
      << "starting up";
   {
      boost::unique_lock<boost::mutex> lock(mut);
      startup_complete = true;
      ooo(iii)
         << "startup finished";
   }
   cond.notify_all();
}

template <int id>
struct task_t
{
   void operator()()
   {
      ooo(iii)
         << "thread "
         << id
         << " waiting for startup to complete";
      boost::unique_lock<boost::mutex> lock(mut);
      while (!startup_complete)
      {
         cond.wait(lock);
         if (!startup_complete)
         {
            ooo(iii)
               << "spurious wakeup on " 
               << id;
         }
      }
      EQ(true, startup_complete);
      ooo(iii)
         << "thread "
         << id
         << " started";
   }
};

template <int id>
struct thread_t
{
   thread_t()
      :thread_(task_)
   {
   }
   ~thread_t()
   {
      thread_.join();
   }
private:
   task_t<id> task_;
   boost::thread thread_;
};

template <int count>
struct thread_launcher_t : thread_launcher_t<count - 1>, thread_t<count>
{
   static_assert(1 <= count, "count must be positive");
};

template <>
struct thread_launcher_t<1> : thread_t<1>
{
};

TEST(basic)
{
   thread_launcher_t<10> threads;
   startup_task();
}
