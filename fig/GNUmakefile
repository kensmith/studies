gmake-recipes := $(HOME)/code/gmake-recipes

include $(gmake-recipes)/main.mk

plat := native
type := prog

include $(gmake-recipes)/finalize.mk

.PHONY: run
run \
  : $(real-target) \
  ; ./build/fig > glider.gif

my-clean-files := glider.gif
