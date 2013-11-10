graph := graph.dot
outputs := eps

.PHONY: all clean
all \
  : $(addprefix $(graph:dot=),$(outputs))

clean \
  : \
  ; rm -f $(addprefix *.,$(outputs))

$(graph:dot=eps) \
  : $(graph) \
  ; dot -T ps < $< > $@


