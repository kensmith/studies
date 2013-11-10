# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
cpus := 4
prog := $(notdir $(CURDIR))

# Implementation
MAKEFLAGS := j$(cpus)
g := g++ -flto -Os -std=c++11 -Wall -Werror -pedantic# -ftemplate-depth=100000
c := $(g) -c -MMD
l := $(g)
s := $(wildcard *.cpp)
o := $(addprefix .,$(patsubst %.cpp,%.o,$(s)))
d := $(o:o=d)
p := $(filter-out .test-%.o,$(o))
t := $(patsubst %.o,%,$(filter .test-%.o,$(o)))
libs := boost_thread boost_system pthread
libs := $(addprefix -l,$(libs))

.PRECIOUS\
:$(t)\
 $(o)

$(prog)\
:$(p) $(addsuffix .passed,$(t))\
;$(l) -o $@ $(p) $(libs)

.%.o\
:%.cpp $(MAKEFILE_LIST)\
;$(c) -o $@ $<

.test-%.passed\
:.test-%\
;./$< --random\
&& touch $@

.test-%\
:.test-%.o\
;$(l) -o $@ $< -lboost_unit_test_framework $(libs)

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
