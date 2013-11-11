#include "reg.hpp"

/**
 * Based on "UM10360: LPC17xx User Manual, Rev. 2 - 19
 * August 2010". NXP Semiconductors.
 */
namespace lpc17xx
{
   using namespace reg::policy;
   using namespace reg;
#if 0
   /**
    * Chapter 4: Clocking and Power Control
    */
   struct pconp
   {
      typedef field_t<0x400fc0c4,0x1,1,rw_t> tim0;
      typedef field_t<0x400fc0c4,0x1,2,rw_t> tim1;
      typedef field_t<0x400fc0c4,0x1,3,rw_t> uart0;
      typedef field_t<0x400fc0c4,0x1,4,rw_t> uart1;

      typedef field_t<0x400fc0c4,0x1,6,rw_t> pwm1;
      typedef field_t<0x400fc0c4,0x1,7,rw_t> i2c0;
      typedef field_t<0x400fc0c4,0x1,8,rw_t> spi;
      typedef field_t<0x400fc0c4,0x1,9,rw_t> rtc;
      typedef field_t<0x400fc0c4,0x1,10,rw_t> ssp1;

      typedef field_t<0x400fc0c4,0x1,12,rw_t> adc;

      typedef field_t<0x400fc0c4,0x1,13,rw_t> can1;
      typedef field_t<0x400fc0c4,0x1,14,rw_t> can2;
      typedef field_t<0x400fc0c4,0x1,15,rw_t> gpio;
      typedef field_t<0x400fc0c4,0x1,16,rw_t> rit;
      typedef field_t<0x400fc0c4,0x1,17,rw_t> mcppwm;
      typedef field_t<0x400fc0c4,0x1,18,rw_t> qei;
      typedef field_t<0x400fc0c4,0x1,19,rw_t> i2c1;

      typedef field_t<0x400fc0c4,0x1,21,rw_t> ssp0;
      typedef field_t<0x400fc0c4,0x1,22,rw_t> tim2;
      typedef field_t<0x400fc0c4,0x1,23,rw_t> tim3;
      typedef field_t<0x400fc0c4,0x1,24,rw_t> uart2;
      typedef field_t<0x400fc0c4,0x1,25,rw_t> uart3;
      typedef field_t<0x400fc0c4,0x1,26,rw_t> i2c2;
      typedef field_t<0x400fc0c4,0x1,27,rw_t> i2s;

      typedef field_t<0x400fc0c4,0x1,29,rw_t> gpdma;
      typedef field_t<0x400fc0c4,0x1,30,rw_t> enet;
      typedef field_t<0x400fc0c4,0x1,31,rw_t> usb;
   };
#endif

   /**
    * Ghapter 9: GPIO
    */
   template <unsigned which, unsigned pin>
   struct fio
   {
      static_assert(
         0 <= which && which <= 4,
         "there are 5 fios (0-4)"
      );

      static_assert(
         0 <= pin && pin <= 31,
         "each register serves 32 pins (0-31)"
      );

      typedef field_t<0x2009c000+which*0x20,0x1,pin,rw_t> dir;
      typedef field_t<0x2009c018+which*0x20,0x1,pin,wo_t> set;
      typedef field_t<0x2009c01c+which*0x20,0x1,pin,wo_t> clr;
   };
}
