libs := 

.PHONY: all
all \
  : main \
    main.s main.i \

main \
  : main.o \
  ; g++-4.4 -std=c++0x -L/usr/local/lib $^ -o $@ $(addprefix -l,$(libs))

%.o \
  : %.cpp shared_ptr.hpp $(MAKEFILE_LIST) \
  ; g++-4.4 -std=c++0x -c -g -I/usr/local/include $< -o $@

%.i \
  : %.cpp $(MAKEFILE_LIST) \
  ; g++-4.4 -E -std=c++0x -c -g -I/usr/local/include $< -o $@

%.s \
  : %.s.in \
  ; cat $< | c++filt > $@

%.s.in \
  : %.cpp $(MAKEFILE_LIST) \
  ; g++-4.4 -S -std=c++0x -c -g -I/usr/local/include $< -o $@
