#include <iostream>

int main()
{
   std::string buf;
   while (!std::getline(std::cin, buf).eof())
   {
      std::cout << buf << std::endl;
   }
}
