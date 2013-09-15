#include <stdio.h>
#include <stdlib.h>
#include "genutil.h"
#include "gentest.h"

void recurse(int depth) {
	entering_function("recurse(int depth)");
	geninfo("depth: %d", depth);

	if (depth > 0) {
		printf("weeee!\n");
		recurse(depth - 1);
	}

	leaving_function(0);
	return;
}

int initialize() {
	entering_function("initialize()");

	leaving_function(4);
	return 4;
}

int main(int argc, char** argv) {
	int number;

	entering_function("main(int argc, char** argv)");
	geninfo("argc: %d", argc);
	geninfo("argv: %p", argv);

	if (argc != 2) {
		if (argc > 0) {
			fprintf(stderr, "usage: %s <number>\n", argv[0]);
		}
		else {
			/* not bloody likely but I've seen worse stuff
			 * happen */
			fprintf(stderr, "usage: program <number>\n");
		}
		leaving_function(1);
		return 1;
	}

	number = atoi(argv[1]);
	initialize();
	recurse(number);
	
	leaving_function(0);
	return(0);
}
