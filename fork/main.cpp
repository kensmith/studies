#include <iostream>
#include <unistd.h>
#include <sys/wait.h>

int main()
{
   pid_t pid = fork();
   if (pid == 0) //child
   {
      for (int i = 0; i < 3; i++)
      {
         std::cout << "child working" << std::endl;
         struct timespec one_second = {1, 0};
         sleep(1);
         //TODO continue
      }
      std::cout << "child done" << std::endl;
   }
   else
   {
      std::cout << "parent waiting" << std::endl;
      wait(NULL);
      std::cout << "parent done" << std::endl;
   }
   return 0;
}
