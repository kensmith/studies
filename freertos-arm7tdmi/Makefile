#/*
#    FreeRTOS V7.1.0 - Copyright (C) 2011 Real Time Engineers Ltd.
#	
#
#    ***************************************************************************
#     *                                                                       *
#     *    FreeRTOS tutorial books are available in pdf and paperback.        *
#     *    Complete, revised, and edited pdf reference manuals are also       *
#     *    available.                                                         *
#     *                                                                       *
#     *    Purchasing FreeRTOS documentation will not only help you, by       *
#     *    ensuring you get running as quickly as possible and with an        *
#     *    in-depth knowledge of how to use FreeRTOS, it will also help       *
#     *    the FreeRTOS project to continue with its mission of providing     *
#     *    professional grade, cross platform, de facto standard solutions    *
#     *    for microcontrollers - completely free of charge!                  *
#     *                                                                       *
#     *    >>> See http://www.FreeRTOS.org/Documentation for details. <<<     *
#     *                                                                       *
#     *    Thank you for using FreeRTOS, and thank you for your support!      *
#     *                                                                       *
#    ***************************************************************************
#
#
#    This file is part of the FreeRTOS distribution.
#
#    FreeRTOS is free software; you can redistribute it and/or modify it under
#    the terms of the GNU General Public License (version 2) as published by the
#    Free Software Foundation AND MODIFIED BY the FreeRTOS exception.
#    >>>NOTE<<< The modification to the GPL is included to allow you to
#    distribute a combined work that includes FreeRTOS without being obliged to
#    provide the source code for proprietary components outside of the FreeRTOS
#    kernel.  FreeRTOS is distributed in the hope that it will be useful, but
#    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#    or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#    more details. You should have received a copy of the GNU General Public
#    License and the FreeRTOS license exception along with FreeRTOS; if not it
#    can be viewed here: http://www.freertos.org/a00114.html and also obtained
#    by writing to Richard Barry, contact details for whom are available on the
#    FreeRTOS WEB site.
#
#    1 tab == 4 spaces!
#
#    http://www.FreeRTOS.org - Documentation, latest information, license and
#    contact details.
#
#    http://www.SafeRTOS.com - A version that is certified for use in safety
#    critical systems.
#
#    http://www.OpenRTOS.com - Commercial support, development, porting,
#    licensing and training services.
#*/

CC=arm-elf-gcc
C++:=arm-elf-g++
OBJCOPY=arm-elf-objcopy
ARCH=arm-elf-ar
CRT0=boot.s
DEBUG=-g
OPTIM=-Os
LDSCRIPT=atmel-rom.ld

#
# CFLAGS common to both the THUMB and ARM mode builds
#

CFLAGS= \
-MMD \
-I.  \
-std=gnu99 \
-Ifreetype-2.4.8/include \
-Wall  \
-Wextra  \
-Wstrict-prototypes  \
-Wmissing-prototypes  \
-Wmissing-declarations  \
-Wno-strict-aliasing  \
-D SAM7_GCC  \
-D THUMB_INTERWORK \
-D FT2_BUILD_LIBRARY \
-mthumb-interwork \
-mcpu=arm7tdmi  \
-T$(LDSCRIPT) \
$(DEBUG)  \
$(OPTIM)
#-fomit-frame-pointer

C++FLAGS := \
-MMD \
-std=gnu++0x \
-I.  \
-Ifreetype-2.4.8/include \
-Wall  \
-Wextra  \
-Wmissing-declarations  \
-Wno-strict-aliasing  \
-D SAM7_GCC  \
-D THUMB_INTERWORK \
-D FT2_BUILD_LIBRARY \
-mthumb-interwork \
-mcpu=arm7tdmi  \
-T$(LDSCRIPT) \
$(DEBUG)  \
$(OPTIM)

THUMB_FLAGS=-mthumb
LINKER_FLAGS=-Xlinker -ortosdemo.elf -Xlinker -M -Xlinker -Map=rtosdemo.map

#
# Source files that can be built to THUMB mode.
#
FREERTOS_THUMB_SRC= \
  tasks.c \
  queue.c \
  list.c \
  port.c \

  #freetype-2.4.8/src/base/ftsystem.c \
  freetype-2.4.8/src/base/ftinit.c \
  freetype-2.4.8/src/base/ftdebug.c \
  freetype-2.4.8/src/base/ftbase.c \
  freetype-2.4.8/src/base/ftbbox.c \
  freetype-2.4.8/src/base/ftglyph.c \
  freetype-2.4.8/src/base/ftbitmap.c \
  freetype-2.4.8/src/base/ftsynth.c \
  freetype-2.4.8/src/truetype/truetype.c \
  freetype-2.4.8/src/raster/raster.c



DEMO_APP_THUMB_SRC= \
  heap_2.c \
  ParTest.c \
  tasky.c \
  flash.c \

DEMO_APP_THUMB_CPP_SRC := \
  main.cpp \

  #typeelmt.cpp \

LWIP_THUMB_SRC=

#
# Source files that must be built to ARM mode.
#
ARM_SRC= \
  portISR.c \
  Cstartup_SAM7.c \
  printk.c

ARM_ASM_SRC= \
  $(CRT0)


#
# Define all object files.
#
ARM_OBJ = $(ARM_SRC:.c=.o)
ARM_ASM_OBJ = $(ARM_ASM_SRC:.s=.o)
FREERTOS_THUMB_OBJ = $(FREERTOS_THUMB_SRC:.c=.o)
DEMO_APP_THUMB_OBJ = $(DEMO_APP_THUMB_SRC:.c=.o)
DEMO_APP_THUMB_CPP_OBJ = $(DEMO_APP_THUMB_CPP_SRC:.cpp=.o)
LWIP_THUMB_OBJ = $(LWIP_THUMB_SRC:.c=.o)
all-obj :=  \
    $(ARM_OBJ) \
    $(ARM_ASM_OBJ) \
    $(FREERTOS_THUMB_OBJ) \
    $(DEMO_APP_THUMB_OBJ) \
    $(DEMO_APP_THUMB_CPP_OBJ) \
    $(LWIP_THUMB_OBJ)
preproc := $(all-obj:.o=.E)
disassm := $(all-obj:.o=.S)

rtosdemo.bin : rtosdemo.elf $(preproc) $(disassm)
	$(OBJCOPY) rtosdemo.elf -O binary rtosdemo.bin

rtosdemo.hex : rtosdemo.elf
	$(OBJCOPY) rtosdemo.elf -O ihex rtosdemo.hex

rtosdemo.elf : $(ARM_ASM_OBJ) $(ARM_OBJ) $(DEMO_APP_THUMB_OBJ) $(DEMO_APP_THUMB_CPP_OBJ)  $(LWIP_THUMB_OBJ) $(FREERTOS_THUMB_OBJ) Makefile FreeRTOSConfig.h
	$(C++) $(CFLAGS) $(ARM_ASM_OBJ) $(ARM_OBJ) $(DEMO_APP_THUMB_OBJ) $(LWIP_THUMB_OBJ) $(FREERTOS_THUMB_OBJ) $(DEMO_APP_THUMB_CPP_OBJ) -nostartfiles $(LINKER_FLAGS)

$(DEMO_APP_THUMB_OBJ)  : %.o : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -c $(THUMB_FLAGS) $(CFLAGS) $< -o $@

#$(DEMO_APP_THUMB_OBJ)  : %.o.E : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -E $(THUMB_FLAGS) $(CFLAGS) $< -o $@.E
#
#$(DEMO_APP_THUMB_OBJ)  : %.o.S : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -S $(THUMB_FLAGS) $(CFLAGS) $< -o $@.S

$(LWIP_THUMB_OBJ)  : %.o : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -c $(THUMB_FLAGS) $(CFLAGS) $< -o $@

#$(LWIP_THUMB_OBJ)  : %.o.E : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -E $(THUMB_FLAGS) $(CFLAGS) $< -o $@.E
#
#$(LWIP_THUMB_OBJ)  : %.o.S : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -S $(THUMB_FLAGS) $(CFLAGS) $< -o $@.S

$(FREERTOS_THUMB_OBJ)  : %.o : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -c $(THUMB_FLAGS) $(CFLAGS) $< -o $@

#$(FREERTOS_THUMB_OBJ)  : %.o.E : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -E $(THUMB_FLAGS) $(CFLAGS) $< -o $@.E
#
#$(FREERTOS_THUMB_OBJ)  : %.o.S : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -S $(THUMB_FLAGS) $(CFLAGS) $< -o $@.S

$(ARM_OBJ) : %.o : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -c $(CFLAGS) $< -o $@

$(ARM_OBJ:.o=.E) : %.E : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -E $(CFLAGS) $< -o $@

#$(ARM_OBJ) : %.o.S : %.c $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -S $(CFLAGS) $< -o $@.S

$(ARM_ASM_OBJ) : %.o : %.s $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(CC) -c $(CFLAGS) $< -o $@

#$(ARM_ASM_OBJ) : %.o.E : %.s $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -E $(CFLAGS) $< -o $@.E
#
#$(ARM_ASM_OBJ) : %.o.S : %.s $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(CC) -S $(CFLAGS) $< -o $@.S

$(DEMO_APP_THUMB_CPP_OBJ) : %.o : %.cpp $(LDSCRIPT) Makefile FreeRTOSConfig.h
	$(C++) -c $(C++FLAGS) $< -o $@

#$(DEMO_APP_THUMB_CPP_OBJ) : %.o.E : %.cpp $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(C++) -E $(C++FLAGS) $< -o $@.E
#
#$(DEMO_APP_THUMB_CPP_OBJ) : %.o.S : %.cpp $(LDSCRIPT) Makefile FreeRTOSConfig.h
#	$(C++) -S $(C++FLAGS) $< -o $@.S

clean :
	rm -f *.o rtosdemo.* `find . -name "*.d"`

-include $(shell find . -name "*.d")
