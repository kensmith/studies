#include "FreeRTOS.h"
#include "Board.h"
#include "AT91SAM7X256.h"
#include "tasky.h"
#include "printk.h"
#if 0
#include "ft2build.h"
#include FT_FREETYPE_H
#endif

#if defined(__cplusplus)
extern "C" {
#endif

void tasky(void * unused)
{
    (void) unused;
    printk("starting tasky\r\n");
    // TODO increase stack size
#if 0
    FT_Library library;
    int error = FT_Init_FreeType(&library);
    if (error)
    {
        printk("failed to initialize freetype\r\n");
    }
    printk("freetype initialization complete\r\n");
#endif
    while (1)
    {
        printk("dude");
    }
}

#if defined(__cplusplus)
}
#endif
