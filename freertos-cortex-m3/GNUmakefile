opt := -g -Os

linker-script := atmel-rom.ld

srcs := \
    main.cpp \
    typeelmt.cpp \
    freetype-2.4.8/src/base/ftsystem.c \
    freetype-2.4.8/src/base/ftinit.c \
    freetype-2.4.8/src/base/ftdebug.c \
    freetype-2.4.8/src/base/ftbase.c \
    freetype-2.4.8/src/base/ftbbox.c \
    freetype-2.4.8/src/base/ftglyph.c \
    freetype-2.4.8/src/base/ftbitmap.c \
    freetype-2.4.8/src/base/ftsynth.c \
    freetype-2.4.8/src/truetype/truetype.c \
    freetype-2.4.8/src/raster/raster.c

src-suffixes := \
    .c \
    .cpp \
    .s

objs := $(srcs)
$(foreach suffix,$(src-suffixes), \
  $(eval \
    objs := $$(patsubst %$(suffix),%.o,$(objs)) \
   ) \
 )
header-deps := $(objs:.o=.d)
secondary-processed := $(filter-out boot.%,$(objs))
preprocs := $(if $(preproc),$(secondary-processed:.o=.E))
disassms := $(if $(disassm),$(secondary-processed:.o=.S))

output-suffixes := .elf .bin

.PHONY: app flash clean
app: \
    $(addprefix app,$(output-suffixes)) \
    $(preprocs) \
    $(disassms)
flash: app; ./flash.py app.elf
clean:; rm -f $(sort $(strip \
    *.d \
    *.o \
    *.E \
    *.S \
    app.elf \
    app.bin \
    app.map))

app.bin \
    : app.elf \
    ; arm-elf-objcopy $< -O binary $@

app.elf \
    : $(objs) \
    ; $(strip arm-elf-g++ \
      -nostartfiles \
      -std=gnu++0x \
      -mthumb \
      -mfpu=vfp \
      -mcpu=cortex-m3 \
      -msoft-float \
      $(objs) \
      -Xlinker -M -Xlinker -Map=app.map \
      -T $(linker-script) \
      -o $@)

common-deps := $(strip \
    $(MAKEFILE_LIST) \
    $(linker-script))

assembler-flags := $(strip \
    -mthumb \
    -msoft-float \
    -mfpu=vfp \
    -mcpu=cortex-m3)

compiler-flags = $(strip \
    $(if $(filter ARM%,$@), \
      $(comment building ARM), \
     ) \
    $(assembler-flags) \
    $(opt) \
    -I . \
    -MMD \
    -Ifreetype-2.4.8/include \
    -Wall \
    -Wextra \
    -Wmissing-declarations  \
    -Wno-strict-aliasing  \
    -D FT2_BUILD_LIBRARY)

c-compiler-flags = \
    $(compiler-flags) \
    -std=gnu99 \
    -Wstrict-prototypes \
    -Wmissing-prototypes

c++-compiler-flags = \
    $(compiler-flags) \
    -std=gnu++0x


%.o \
    : %.s $(common-deps) \
    ; arm-elf-gcc $(assembler-flags) $< -c -o $@


%.o \
    : %.c $(common-deps) \
    ; arm-elf-gcc $(c-compiler-flags) $< -c -o $@
%.E \
    : %.c $(common-deps) \
    ; arm-elf-gcc $(c-compiler-flags) $< -E -o $@
%.S \
    : %.c $(common-deps) \
    ; arm-elf-gcc $(c-compiler-flags) $< -S -o $@


%.o \
    : %.cpp $(common-deps) \
    ; arm-elf-g++ $(c++-compiler-flags) $< -c -o $@
%.E \
    : %.cpp $(common-deps) \
    ; arm-elf-g++ $(c++-compiler-flags) $< -E -o $@
%.S \
    : %.cpp $(common-deps) \
    ; arm-elf-g++ $(c++-compiler-flags) $< -S -o $@

-include $(header-deps)
