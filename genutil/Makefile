# If you add -DGENUTIL_REENTRANT to GENUTIL_FLAGS, you may as well remove
# genutil.o from OBJECTS because it isn't necessary when using genutil in
# a multithreaded program.

CC = gcc
CFLAGS = -g $(GENUTIL_FLAGS) -pedantic -ansi -Wall
GENUTIL_FLAGS = -DGENUTIL #-DGENUTIL_REENTRANT
GLOBAL_DEPENDENCIES = Makefile genutil.h gentest.h
OBJECTS = genutil.o gentest.o

.KEEP_STATE:

# The purpose of GLOBAL_DEPENDENCIES is to force a rebuild of the entire
# program if the Makefile or the headers change.  This eliminates the
# hassle of having to do a 'make clean' if you want to make a change
# to genutil or the make file variables which affect genutil.

gentest: $(GLOBAL_DEPENDENCIES)  $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

genutil.o: $(GLOBAL_DEPENDENCIES) genutil.c
	$(CC) $(CFLAGS) -c genutil.c

gentest.o: $(GLOBAL_DEPENDENCIES) gentest.c
	$(CC) $(CFLAGS) -c gentest.c

clean:
	rm -f gentest *.o
