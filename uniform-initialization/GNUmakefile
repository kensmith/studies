libs := 

main \
  : main.o \
  ; g++ -std=c++0x -L/usr/local/lib $< -o $@ $(addprefix -l,$(libs))

main.o \
  : main.cpp $(MAKEFILE_LIST) \
  ; g++ -std=c++0x -c -g -I/usr/local/include $< -o $@
