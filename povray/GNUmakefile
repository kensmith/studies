widths = 5120 2560 2732 13660 1366
h5120 := 3200
h2560 := 1600
h2732 := 1536
h1366 := 768
h13660 := 7680

clean-files :=

.PHONY: clean view all
all:

$(foreach width,$(widths),\
  $(info width=$(width))\
  $(eval height := $(h$(width)))\
  $(eval input-filename := stars$(width)x$(height).pov)\
  $(eval output-filename := stars$(width)x$(height).png)\
  $(eval clean-files += $(input-filename))\
  $(eval clean-files += $(output-filename))\
  $(eval\
    $(input-filename)\
    :stars.pov\
    ;cp -f $$< $$@\
   )\
  $(eval\
    $(output-filename)\
    :$(input-filename)\
    ;povray -H$(height) -W$(width) $$<\
   )\
  $(eval\
    all: $(output-filename)\
   )\
 )

clean\
:\
;$(strip rm -f $(clean-files))
