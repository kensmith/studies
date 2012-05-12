filename := $(shell date +"%Y.%m.%d-%k:%M:%S.mp3")

.PHONY: run
run \
    : recmp3 \
    ; ./recmp3 > $(filename) 2> /dev/null

recmp3 \
    : recmp3.cpp $(MAKEFILE_LIST) \
    ; g++ --std=gnu++0x -O3 -o $@ $< -lportaudio -lmp3lame

.PHONY: docs
docs \
    : Doxyfile \
    ; doxygen

Doxyfile \
    : \
    ; doxygen -g

.PHONY: clean
clean \
    : \
    ; rm -Rf recmp3 html latex Doxyfile \
    ; $(if $(wildcard *.mp3),rm -i *.mp3,true)
