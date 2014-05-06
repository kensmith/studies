#include <vector>
#include <thread>
#include <memory>
#include <iostream>
#include <unistd.h>

int main()
{
   using thread_ptr_t = std::shared_ptr<std::thread>;
   using thread_ptrs_t = std::vector<thread_ptr_t>;
   thread_ptrs_t threads;
   for (int i = 0; i < 10000; ++i)
   {
      std::cout << i << ",";
      threads.push_back(thread_ptr_t(new std::thread(
         [i]()
         {
            int j = 0;
            while (true)
            {
               std::cout
                  << "thread "
                  << i
                  << " says "
                  << j
                  << std::endl;
               sleep(1);
               ++j;
            }
         }
      )));
   }

   std::cout
      << "threads spawned"
      << std::endl;

   for (auto t : threads)
   {
      t->join();
   }
}
