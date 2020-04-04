# Motif detection

A repository for a study on probabilistic motif detection techniques. 

### Requirements
* CMake
* OpenMP
* LLVM if building on macOS

### Building
To build executables with CMake run

```shell script
cmake .
make
```

This will create files `fascia` and `ensemble` in the `bin` directory.

### Usage
For guidelines on how to use **FASCIA**, refer to `FASCIA/index.html`.

`fascia` with the `-m` option must be executed in the same directory as the `motifs` folder. 