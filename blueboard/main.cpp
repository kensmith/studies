#include "main.hpp"
#include "lpc17xx.hpp"
#include "blueboard.hpp"
#include "os.hpp"

template <typename car, typename... cdr>
struct sum_t
{
};

template <typename last>
struct sum_t<last>
{
};

struct task_functor
{
   static void run()
   {
      blueboard::test_led_t led;
      led.on();

      while (1)
      {
         for (int i = 10000; i > 0; --i) led.on();
         for (int i = 10000; i > 0; --i) led.off();
      }
   }
};

int main(void)
{
}
