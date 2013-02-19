# This software is released under the Boost Software License, version 1.0.
# See LICENSE_1_0.txt or http://www.boost.org/LICENSE_1_0.txt
# Copyright Ken Smith kgsmith at gmail dot com, 2013.

# User configurable portion.
prefix := /usr/local
name := $(notdir $(CURDIR))
optimize := t

# Implementation
MAKEFLAGS := j4
g := g++ -flto -g -std=c++11 -Wall -Werror -pedantic
$(if $(strip $(optimize)),\
  $(eval\
    g += -Os\
   )\
 )
g := $(strip $(g))
c := $(g) -c -MMD -I/usr/include/botan-1.10
l := $(g)
s := $(wildcard *.cpp)
o := $(patsubst %.cpp,%.o,$(s))
d := $(o:o=d)
p := $(filter-out %-test.o,$(o))
t := $(patsubst %.o,%,$(filter %-test.o,$(o)))

$(name)\
:$(p) $(addsuffix .passed,$(t))\
;$(l) -o $@ $(p) -lbotan-1.10

%.o\
:%.cpp $(MAKEFILE_LIST)\
;$(c) -o $@ $<

%-test.passed\
:%-test.o $(MAKEFILE_LIST)\
;$(l) -o $(patsubst %.passed,%,$@) $< -lboost_unit_test_framework\
&& ./$(patsubst %.passed,%,$@)\
&& touch $@.passed

.PHONY\
:clean\
 install

install\
:$(name)\
;cp $(name) $(prefix)/bin

clean\
:\
;rm -Rf $(name) $(t) *.o *.d *.passed html latex

-include $(d)
