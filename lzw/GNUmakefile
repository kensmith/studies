# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
cpus := 4
prog := prog
#opt := -Os
debug := -g

# Implementation
prog ?= $(notdir $(CURDIR))
MAKEFLAGS := j$(cpus)
g := g++ -flto $(opt) $(debug) -std=c++11 -Wall -Werror -pedantic
g := $(strip $(g))
c := $(g) -c -MMD
l := $(g)
s := $(wildcard *.cpp)
o := $(addprefix .,$(patsubst %.cpp,%.o,$(s)))
d := $(o:o=d)
p := $(filter-out .test-%.o,$(o))
t := $(patsubst %.o,%,$(filter .test-%.o,$(o)))
x := $(filter-out -Werror,$(c))
x := $(filter-out -Wall,$(x))
x := $(filter-out -pedantic,$(x))
pd := .postdepend.sh

.PRECIOUS\
:$(t)\
 $(o)

$(prog)\
:$(p) $(addsuffix .passed,$(t))\
;$(l) -o $@ $(p)

.test-%.o\
:test-%.cpp $(MAKEFILE_LIST) $(pd)\
;$(x) -o $@ $<;./$(pd) $(@:o=d)

.%.o\
:%.cpp $(MAKEFILE_LIST)\
;$(c) -o $@ $<;./$(pd) $(@:o=d)

.test-%.passed\
:.test-%\
;./$< --random --auto_start_dbg=undodb-gdb --report_level=short --show_progress\
&& touch $@

.test-%\
:.test-%.o\
;$(l) -o $@ $< -lboost_unit_test_framework

.PHONY\
:clean\
 install

install\
:$(prog)\
;cp $(prog) $(prefix)/bin

clean\
:\
;rm -Rf $(prog) .test-* .*.o .*.d .*.passed html latex .postdepend.sh

.postdepend.sh\
:$(MAKEFILE_LIST)\
;echo -e\
 "#!/bin/sh\n"\
 "\n"\
 "cp \$$1 \$$1.p\n"\
 "cat \$$1"\
 "| sed"\
 "-e 's/\#.*//'"\
 "-e 's/^[^:]*: *//'" \
 "-e 's/ *\$$//'"\
 "-e '/^\$$/ d' "\
 "-e 's/$$/ :/'"\
 ">> \$$1.p\n"\
 "mv \$$1.p \$$1"\
> $@\
;chmod +x $@

-include $(d)
