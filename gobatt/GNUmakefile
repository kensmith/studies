github-usename := kensmith

MAKEFLAGS += -j
$(if $(strip $(GOPATH)),\
	$(comment all is well with your go),\
	$(error Set GOPATH to the location of your Go binaries.)\
 )

build-dir := $(CURDIR)/build
binary := $(notdir $(CURDIR))
binary-fullpath := $(build-dir)/$(binary)
sources := $(shell find . -name "*.go")
scc := $(GOPATH)/bin/scc
scc-result := $(build-dir)/scc.txt
go-nontest-files := $(shell find $(CURDIR) -name "*.go" -not -name "*_test.go")
go-test-files := $(patsubst %.go,%_test.go,$(go-nontest-files))
go-test-files := $(filter-out $(CURDIR)/main_test.go,$(go-test-files))
go-mod := $(CURDIR)/go.mod
proj := $(notdir $(CURDIR))
studies-proj := studies/$(proj)
pkg-name := github.com/$(github-usename)/$(studies-proj)/gobatt
go-vet-result := $(build-dir)/go-vet.txt
go-test-result := $(build-dir)/go-test.txt
nilaway := $(GOPATH)/bin/nilaway
nilaway-result := $(build-dir)/nilaway.txt
govulncheck := $(GOPATH)/bin/govulncheck
govulncheck-result := $(build-dir)/govulncheck.txt

.PHONY: build
build: $(binary-fullpath) $(go-vet-result) $(go-test-result) $(scc-result) $(nilaway-result) $(govulncheck-result) fail-on-missing-tests
	cat $(scc-result)
	cat $(nilaway-result)
	cat $(go-vet-result)
	cat $(go-test-result)
	cat $(govulncheck-result)

$(govulncheck-result): $(govulncheck) $(sources) $(MAKEFILE_LIST) | $(build-dir)
	$(govulncheck) | tee $@

$(govulncheck):
	go install golang.org/x/vuln/cmd/govulncheck@latest

$(nilaway-result): $(nilaway) $(sources) $(MAKEFILE_LIST) | $(build-dir)
	$(nilaway) ./... | tee $@

$(nilaway):
	go install go.uber.org/nilaway/cmd/nilaway@latest

$(go-test-result): $(binary-fullpath)
	go test ./... | tee $@

$(binary-fullpath): $(sources) $(MAKEFILE_LIST) .formatted | $(build-dir)
	go build -o $(binary-fullpath) *.go

$(go-vet-result): $(sources) $(MAKEFILE_LIST) | $(build-dir)
	go vet -composites=false ./... | tee $@

$(scc-result): $(scc) $(sources) $(MAKEFILE_LIST) | $(build-dir)
	$(scc) --no-cocomo --sort code -M json -M js -M css -M gitignore | tee $@

$(scc):
	go install github.com/boyter/scc@latest

.formatted: $(sources) $(go-mod) $(MAKEFILE_LIST)
	go mod tidy
	go fmt ./...
	go generate ./...
	touch $@

$(go-mod):
	go mod init $(pkg-name)

$(build-dir):
	mkdir -p $@

.PHONY: fail-on-missing-tests
fail-on-missing-tests: | $(go-test-files)

.PHONY: clean
clean:
	rm -Rf $(build-dir) .formatted

-include local.mk
