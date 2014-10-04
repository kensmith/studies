# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
cpus := 8
prog := $(notdir $(CURDIR))
comp ?= clang

# Implementation
MAKEFLAGS := rj$(cpus)
g++-flags := -flto -g -Og -std=c++1y -Wall -Werror -pedantic
clang-flags := -g -std=c++1y -Wall -Werror -pedantic
g := $(comp) $($(comp)-flags)
c := $(g) -c -MMD
l := $(g)
clang-l := -lstdc++
s := $(wildcard *.cpp)
o := $(addprefix .,$(patsubst %.cpp,%.o,$(s)))
d := $(o:o=d)
p := $(filter-out .test-%.o,$(o))
t := $(patsubst %.o,%,$(filter .test-%.o,$(o)))

.PRECIOUS\
:$(t)\
 $(o)

all\
:prog prog.S $(addsuffix .passed,$(t)) $(addsuffix .S,$(t))

prog.S\
:prog\

prog\
:$(p)\
;$(l) -o $@ $(p) $($(comp)-l)

.%.o\
:%.cpp $(MAKEFILE_LIST) .compiler\
;$(c) -o $@ $<

.compiler\
:.compiler-sentinel\
;diff -qN $< $@ > /dev/null 2>&1\
||mv $< $@

.PHONY: .compiler-sentinel
.INTERMEDIATE: .compiler-sentinel
.compiler-sentinel\
:\
;echo $(comp) > $@

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
;rm -Rf prog $(t) .*.o .*.d .*.S *.S .*.passed html latex

-include $(d)
