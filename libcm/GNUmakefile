gmake-recipes := $(HOME)/public/gmake-recipes

include $(gmake-recipes)/main.mk

plat := native
type := staticlib
preflags := -include "base.hpp"

include $(gmake-recipes)/finalize.mk

.PHONY: ref
ref\
:\
;(nohup acroread reference/* > /dev/null 2>&1 &)
