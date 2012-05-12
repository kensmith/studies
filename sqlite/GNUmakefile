# make clean && make debug=
#   build optimized targets
#
# make clean && make
#   build debug targets

#debug ?= t

src-dir := src
src-dirs := $(src-dir)
build-dir := build
prog := $(build-dir)/sqlite-study
db-file := $(build-dir)/transactions.db
srcs := $(wildcard $(src-dir)/*.cpp)
objs := $(patsubst $(src-dir)%,$(build-dir)%,$(srcs:.cpp=.o))
deps := $(objs:.o=.d)
opt := -O3
release-macros := \
  -DNDEBUG=1 \
  -Dglobal_log_level=warning

$(if $(strip $(debug)), \
  $(eval opt := -g) \
  $(eval release-macros := -Dglobal_log_level=debug) \
 )

compile-flags := \
  -c \
  $(addprefix -I ,$(src-dirs)) \
  -Wall \
  -Wextra \
  -Weffc++ \
  -Werror \
  -MMD \
  -D_REENTRANT \
  $(opt) \
  $(release-macros)

link-flags :=

link-libs := \
  -lsqlite3

.PHONY: test
test \
  : $(prog) \
    $(db-file) \
  ; ./$(prog) $(db-file) | tee timestamps

.PHONY: $(db-file)
$(db-file) \
  : $(MAKEFILE_LIST) \
  ; rm -f $@ \
  ; sqlite3 $@ "CREATE TABLE transactions ( transactionID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, cardID INTEGER NOT NULL, transactionData TEXT NOT NULL);"

$(prog) \
  : $(objs) \
  ; g++ $(link-flags) -o $@ $^ $(link-libs)

build/%.o \
  : src/%.cpp $(MAKEFILE_LIST) \
  | $(build-dir) \
  ; g++ $(compile-flags) -o $@ $<

$(build-dir) \
  : \
  ; mkdir -p $@

.PHONY: clean
clean \
  : \
  ; rm -Rf build

-include $(deps)
