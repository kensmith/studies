MAKEFLAGS += -j
$(if $(strip $(GOPATH)),\
	$(comment all is well with your go),\
	$(error Set GOPATH to the location of your Go binaries.)\
 )

build-dir := $(CURDIR)/build
binary := $(notdir $(CURDIR))
binary-fullpath := $(build-dir)/$(binary)
sources := $(shell find . -name "*.go")
go-nontest-files := $(shell find $(CURDIR) -name "*.go" -not -name "*_test.go")
go-test-files := $(patsubst %.go,%_test.go,$(go-nontest-files))
go-test-files := $(filter-out $(CURDIR)/main_test.go,$(go-test-files))

.PHONY: build
build: $(binary-fullpath) fail-on-missing-tests
	go test ./...
	go vet -composites=false ./...

$(binary-fullpath): $(sources) $(MAKEFILE_LIST) .formatted | $(build-dir)
	go build -o $(binary-fullpath) *.go

.formatted: $(sources) $(MAKEFILE_LIST)
	go mod tidy
	go fmt ./...
	go generate ./...
	touch $@

$(build-dir):
	mkdir -p $@

.PHONY: fail-on-missing-tests
fail-on-missing-tests: $(go-test-files)

.PHONY: clean
clean:
	rm -Rf $(build-dir) .formatted

-include local.mk
