#include <iostream>

#define TWO(c)     (0x1u << (c))
#define MASK(c) \
  (((unsigned int)(-1)) / (TWO(TWO(c)) + 1u))
#define COUNT(x,c) \
  ((x) & MASK(c)) + (((x) >> (TWO(c))) & MASK(c))

int bitcount (unsigned int n)  {
   n = COUNT(n, 0) ;
   n = COUNT(n, 1) ;
   n = COUNT(n, 2) ;
   n = COUNT(n, 3) ;
   n = COUNT(n, 4) ;
   /* n = COUNT(n, 5) ;    for 64-bit integers */
   return n ;
}

int mit_hakmem_bitcount(unsigned int n) {
   /* works for 32-bit numbers only    */
   /* fix last line for 64-bit numbers */

   register unsigned int tmp;

   tmp = n - ((n >> 1) & 033333333333)
           - ((n >> 2) & 011111111111);
   return ((tmp + (tmp >> 3)) & 030707070707) % 63;
}


int main()
{
#if 0
    unsigned int x = -1;
    for (int i = 0; i < 5; i++)
    {
        std::cout << std::hex << COUNT(x, i) << std::endl;
        x = COUNT(x, i);
    }
    return 0;
#else
    unsigned x = 1;
    for (unsigned i = x; (i & 0x80000000) == 0; i = (i << 1) | 1)
    {
        std::cout << "mit_hakmem_bitcount(" << std::hex << i << std::dec << ") = " << mit_hakmem_bitcount(i) << std::endl;
    }
    return 0;
#endif
}
