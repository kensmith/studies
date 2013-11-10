main \
  : main.o \
  ; g++ -o $@ $^

main.o \
  : main.cpp \
  ; g++ -std=gnu++0x -c -g $< -o $@
