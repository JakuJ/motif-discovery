CXX=clang++
CXXFLAGS=-fopenmp -L/usr/local/opt/llvm/lib -std=gnu++0x -O3
CXXDEBUGFLAGS=-fopenmp -L/usr/local/opt/llvm/lib -Wall -std=gnu++0x -g

.PHONY: clean

all: fascia ensemble

fascia: fascia.cpp
	${CXX} ${CXXFLAGS} fascia.cpp -o fascia

ensemble: ensemble.cpp
	${CXX} ${CXXFLAGS} ensemble.cpp -o ensemble

debug: fascia.cpp
	${CXX} ${CXXDEBUGFLAGS} fascia.cpp -o fascia

clean:
	rm -f fascia fascia.exe
