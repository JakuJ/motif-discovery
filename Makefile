CXX=clang++
CXXFLAGS=-fopenmp -L/usr/local/opt/llvm/lib -std=gnu++0x -O3
CXXDEBUGFLAGS=-fopenmp -L/usr/local/opt/llvm/lib -Wall -std=gnu++0x -g

all:
	${CXX} ${CXXFLAGS} fascia.cpp -o fascia

debug:
	${CXX} ${CXXDEBUGFLAGS} fascia.cpp -o fascia

clean:
	rm -f fascia fascia.exe
