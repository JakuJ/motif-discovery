#include <iostream>

#include "load_graph.hpp"
#include "graph.hpp"

int main(int argc, char **argv) {
    if (argc < 2) {
        std::cout << "Specify the input file" << std::endl;
    }

    char *filepath = argv[1];

    Graph g;
    int *srcs_g;
    int *dsts_g;
    int *labels_g;

    read_in_graph(g, filepath, false, srcs_g, dsts_g, labels_g);
    std::cout << "Max degree: " << g.max_degree() << std::endl;
}