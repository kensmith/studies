libs := 

main \
  : main.o \
    main.s \
    main.i \
  ; g++ -std=c++0x -L/usr/local/lib $< -o $@ $(addprefix -l,$(libs))

main.o \
  : main.cpp $(MAKEFILE_LIST) \
  ; g++ -std=c++0x -c -g -I/usr/local/include $< -o $@

main.i \
  : main.cpp $(MAKEFILE_LIST) \
  ; g++ -E -std=c++0x -c -g -I/usr/local/include $< -o $@

main.s \
  : main.s.in \
  ; cat $< | c++filt > $@

main.s.in \
  : main.cpp $(MAKEFILE_LIST) \
  ; g++ -S -std=c++0x -c -g -I/usr/local/include $< -o $@
