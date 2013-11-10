srcs := $(wildcard *.c)
objs := $(srcs:.c=.o)

.PHONY: run
run: prog; ./prog

prog \
  : $(objs) \
  ; gcc -o $@ $^
