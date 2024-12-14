.PHONY: demo
demo: build
	seq 10 | shuf | $(binary-fullpath)
