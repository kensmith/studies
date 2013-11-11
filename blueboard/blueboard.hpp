#pragma once

/**
 * Blueboard
 *
 * https://www.sparkfun.com/products/9931
 * http://shop.ngxtechnologies.com/product_info.php?cPath=21&products_id=65
 *
 * is an lpc1768-based minimal microcontroller platform.
 * This file is based on V2 of the board from Summer `12.
 *
 * These must remain in a header file in order for
 * optimization to inline away the function calls into field_t
 * types.
 */
namespace blueboard
{
   /**
    * Test LED D8 is connected to p1.29 and is lit when that
    * line is high.
    */
   struct test_led_t
   {
      typedef lpc17xx::fio<1, 29> user_led_reg;

      /**
       * Initialize the LED. To avoid redundant
       * reinitialization, pass a handle to this object
       * around to its users.
       */
      test_led_t()
      {
         user_led_reg::dir::write(1);
      }

      void on()
      {
         user_led_reg::set::write(1);
      }

      void off()
      {
         user_led_reg::clr::write(1);
      }
   };
}
