#include <iostream>

using caller_handle_t = int;
using callee_handle_t = short;

callee_handle_t getSrc() { return 10; }
caller_handle_t getDst() { return 20; }

void foo()
{
   caller_handle_t handle = 1;
   callee_handle_t peer = getSrc();
   std::cout << "handle = " << handle << std::endl;
   std::cout << "peer = " << peer << std::endl;
}

void bar()
{
   callee_handle_t handle = 2;
   caller_handle_t peer = getDst();
   std::cout << "handle = " << handle << std::endl;
   std::cout << "peer = " << peer << std::endl;
}

template <typename peer_handle_t>
struct peer_getter_t
{
   static peer_handle_t getPeer()
   {
      return -1;
   }
};

template <>
struct peer_getter_t<callee_handle_t>
{
   static callee_handle_t getPeer()
   {
      return getSrc();
   }
};

template <>
struct peer_getter_t<caller_handle_t>
{
   static caller_handle_t getPeer()
   {
      return getDst();
   }
};

template <typename handle_t, typename peer_handle_t>
void refactor()
{
   handle_t handle = 3;
   peer_handle_t peer = peer_getter_t<peer_handle_t>::getPeer();
   std::cout << "handle = " << handle << std::endl;
   std::cout << "peer = " << peer << std::endl;
}

int main()
{
   foo();
   bar();

   refactor<caller_handle_t, callee_handle_t>();
   refactor<callee_handle_t, caller_handle_t>();

   return 0;
}
