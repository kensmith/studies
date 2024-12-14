.PHONY: demo
demo: build
	echo nice balls | $(binary-fullpath)
