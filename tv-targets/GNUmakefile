# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
cpus := 8
prog := $(notdir $(CURDIR))
comp ?= clang
san ?= address

# Implementation
MAKEFLAGS := rj$(cpus)
common-cxx-flags := $(shell Magick++-config --cxxflags) -Wall
g++-flags := $(common-cxx-flags) -flto -g -Og -std=c++1y -Wall -pedantic
clang-flags := $(common-cxx-flags) -g -std=c++1y -Wall -pedantic -fsanitize=$(san)
common-ldd-flags := $(shell Magick++-config --ldflags)
g := $(comp) $($(comp)-flags)
c := $(g) -c -MMD
l := $(g)
g++-l := $(common-ldd-flags)
clang-l := $(common-ldd-flags) -lstdc++
s := $(wildcard *.cpp)
o := $(addprefix .,$(patsubst %.cpp,%.o,$(s)))
d := $(o:o=d)
p := $(filter-out .test-%.o,$(o))
t := $(patsubst %.o,%,$(filter .test-%.o,$(o)))
image-indices := $(shell seq 0 30|xargs printf "%02d\n")
image-filenames := $(addsuffix .gif,$(image-indices))

.PRECIOUS\
:$(t)\
 $(o)

.PHONY: all

all\
:$(image-filenames) calibration.gif

calibration.gif\
:00.gif\
;cp $< $@

%.gif\
:prog prog.S $(addsuffix .passed,$(t)) $(addsuffix .S,$(t))\
;./prog $(patsubst %.gif,%,$@)

prog.S\
:prog\

prog\
:$(p)\
;$(l) -o $@ $(p) $($(comp)-l)

.%.o\
:%.cpp $(MAKEFILE_LIST) .compiler\
;ccache $(c) -o $@ $<

.compiler\
:.compiler-sentinel\
;diff -qN $< $@ > /dev/null 2>&1\
||mv $< $@

.PHONY: .compiler-sentinel
.INTERMEDIATE: .compiler-sentinel
.compiler-sentinel\
:\
;echo "$(comp), sanitize $(san), flags are $($(comp)-flags)" > $@

.PHONY: test
test\
:\
;rm -f .test-*.passed\
;$(MAKE)

$(foreach test-program,$(t),\
  $(eval target-name := $(patsubst .%,%,$(test-program)))\
  $(eval .PHONY: $(target-name))\
  $(eval\
    $(target-name)\
    :$(test-program)\
    ;rm -f $(test-program).passed\
    ;$(MAKE)\
   )\
 )

%.S\
:%\
;objdump -S $< > $@

.test-%.passed\
:.test-%\
;./$< --random\
&& touch $@

.test-%\
:.test-%.o\
;$(l) -o $@ $< -lboost_unit_test_framework $($(comp)-l)

.PHONY\
:clean\
 install

install\
:prog\
;install -m 755 prog $(prefix)/bin/$(prog)

clean\
:\
;rm -Rf prog $(t) .*.o .*.d .*.S *.S .*.passed html latex \
 *.gif

-include $(d)
