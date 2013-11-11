# Use
#
# make -j debug
#
# when debugging. Add source filenames to
# turn-off-optimization-for in order to improve single
# stepping in those files.

# configurables
turn-off-optimization-for :=
omit-debugging-symbols-for :=
preproc := t
genassm := t

# main
linker-script := lpc-1768.ld

srcs :=\
 $(wildcard *.cpp)\
 $(wildcard *.c)\

src-suffixes :=\
 .c\
 .cpp\
 .s

objs := $(srcs)
$(foreach suffix,$(src-suffixes),\
  $(eval\
    objs := $$(patsubst %$(suffix),%.o,$(objs))\
   )\
 )
header-deps :=\
 $(addsuffix .d,$(objs))\
 $(addsuffix .d,$(objs:.o=.E))\
 $(addsuffix .d,$(objs:.o=.S))
secondary-processed := $(filter-out boot.%,$(objs))
preprocs := $(if $(preproc),$(secondary-processed:.o=.E))
genassms := $(if $(genassm),$(secondary-processed:.o=.S))

output-suffixes := .elf .bin .xxd


.PHONY: app
app\
:$(addprefix app,$(output-suffixes))\
 $(preprocs)\
 $(genassms)\
 docs

.PHONY: done
done\
:\
;git commit -a && git push

.PHONY: docs
docs\
:html/index.html

html/index.html\
:Doxyfile $(objs)\
;doxygen > doxygen.out 2>&1

.PHONY: debug
debug\
:flash\
;arm-none-eabi-gdb

.PHONY: flash 
flash\
:app\
;./flash.py app.bin

.PHONY: clean
clean\
:\
;rm -Rf\
 $(sort\
   $(strip\
     *.d\
     *.o\
     *.E\
     *.S\
     app.*\
     doxygen.out\
     html\
     latex\
    )\
  )

app.xxd\
:app.bin\
;xxd $< > $@

app.bin\
:app.elf\
;arm-none-eabi-objcopy $< -O binary $@

app.elf\
:$(objs)\
;$(strip arm-none-eabi-g++\
 -mthumb\
 -std=gnu++0x\
 -nostartfiles\
 -mfpu=vfp\
 -mcpu=cortex-m3\
 -march=armv7-m\
 -msoft-float\
 $(objs)\
 -Xlinker -M -Xlinker -Map=app.map\
 -T $(linker-script)\
 -o $@)

common-deps :=\
$(strip\
  $(MAKEFILE_LIST)\
  $(linker-script)\
 )

assembler-flags :=\
$(strip\
  -mthumb\
  -msoft-float\
  -mfpu=vfp\
  -mcpu=cortex-m3\
  -march=armv7-m\
 )

compiler-flags =\
$(strip\
  $(if $(filter ARM%,$@),\
    $(comment building ARM),\
   )\
  $(assembler-flags)\
  $(if $(filter $<,$(omit-debugging-symbols-for)),,-g)\
  $(if $(filter $<,$(turn-off-optimization-for)),,-Os)\
  -MMD\
  -MF $@.d\
  -I .\
  -Ifreetype-2.4.8/include\
  -Wall\
  -Wextra\
  -Wmissing-declarations\
  -Wno-strict-aliasing\
  -D FT2_BUILD_LIBRARY\
  -I /opt/boost\
 )

c-compiler-flags =\
 $(compiler-flags)\
 -std=gnu99\
 -Wmissing-prototypes

c++-compiler-flags =\
 $(compiler-flags)\
 -std=gnu++0x

%.o\
:%.s $(common-deps)\
;arm-none-eabi-gcc $(assembler-flags) $< -c -o $@

%.o\
:%.c $(common-deps)\
;arm-none-eabi-gcc $(c-compiler-flags) $< -c -o $@
%.E\
:%.c $(common-deps)\
;arm-none-eabi-gcc $(c-compiler-flags) $< -E -o $@
%.S\
:%.c $(common-deps)\
;arm-none-eabi-gcc $(c-compiler-flags) $< -S -o $@

%.o\
:%.cpp $(common-deps)\
;arm-none-eabi-g++ $(c++-compiler-flags) $< -c -o $@
%.E\
:%.cpp $(common-deps)\
;arm-none-eabi-g++ $(c++-compiler-flags) $< -E -o $@
%.S\
:%.cpp $(common-deps)\
;arm-none-eabi-g++ $(c++-compiler-flags) $< -S -o $@

-include $(header-deps)

# vim:tw=60:
