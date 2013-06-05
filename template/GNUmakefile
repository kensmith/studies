# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
cpus := 4
prog := $(notdir $(CURDIR))

# Implementation
MAKEFLAGS := j$(cpus)
g := g++ -flto -g -std=c++11 -Wall -Werror -pedantic
c := $(g) -c -MMD
l := $(g)
s := $(wildcard *.cpp)
o := $(addprefix .,$(patsubst %.cpp,%.o,$(s)))
d := $(o:o=d)
p := $(filter-out .test-%.o,$(o))
t := $(patsubst %.o,%,$(filter .test-%.o,$(o)))

.PRECIOUS\
:$(t)\
 $(o)

$(prog)\
:$(p) $(addsuffix .passed,$(t))\
;$(l) -o $@ $(p) -lluabind

.%.o\
:%.cpp $(MAKEFILE_LIST)\
;$(c) -o $@ $<

.test-%.passed\
:.test-%\
;./$< --random\
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
;rm -Rf $(prog) $(t) .*.o .*.d .*.passed html latex

-include $(d)
