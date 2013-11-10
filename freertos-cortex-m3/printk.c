#include "printk.h"
#include "AT91SAM7X256.h"

void arm_printk(const char * buffer)
{
    AT91PS_DBGU pDbgu = AT91C_BASE_DBGU ;
#if 1
    unsigned int temp;
#endif

    while(*buffer != '\0')
    {
#if 1
        temp=0;

        while (temp==0)
        {
          if ( (pDbgu->DBGU_CSR & 0x0200) == 0)
            temp=0;
          else
            temp=1;
        }
#else
        while ((pDbgu->DBGU_CSR & 0x2) != 0)
        {
            // wait
        }
#endif
        pDbgu->DBGU_THR = *buffer;
        buffer++;
    }
}

void arm_printchar(char c)
{
    char buf[2] = {c, '\0'};
    printk(buf);
}

void arm_printhex(const char * name, unsigned x)
{
    static const char const digits[] = {
        '0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', 'a', 'b',
        'c', 'd', 'e', 'f',
        'x', 'y', 'z', '!'
    };
    static char result[9];
    int result_idx = 8;
    result[result_idx--] = '\0';
    printk(name);
    printk(" = 0x");
    for (int i = 0; i < 8; i++)
    {
        int digit_val = x & 0xf;
        result[result_idx--] = digits[digit_val];
        x >>= 4;
    };
    printk(result);
    printk("\r\n");
}

