MAKEFLAGS += -j
$(if $(strip $(GOPATH)),\
	$(comment all is well with your go),\
	$(error Set GOPATH to the location of your Go binaries.)\
 )

build-dir := $(CURDIR)/build
binary := $(notdir $(CURDIR))
binary-fullpath := $(build-dir)/$(binary)
sources := $(shell find . -name "*.go")

.PHONY: build
build: $(binary-fullpath)

$(binary-fullpath): $(sources) $(MAKEFILE_LIST) .formatted | $(build-dir)
	go build -o $(binary-fullpath) *.go
	go test ./...
	go vet -composites=false ./...

.formatted: $(sources) $(MAKEFILE_LIST)
	go mod tidy
	go fmt ./...
	go generate ./...
	touch $@

$(build-dir):
	mkdir -p $@

