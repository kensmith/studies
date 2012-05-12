main: main.o; g++ -o main main.o -llua
main.o: main.cpp; g++ -c -o main.o main.cpp

.PHONY: clean
clean:; rm -f main main.o
