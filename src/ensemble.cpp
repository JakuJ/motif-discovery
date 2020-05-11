#include <sys/stat.h>
#include <dirent.h>
#include <iostream>
#include <string>

#include "../FASCIA/load_graph.hpp"
#include "../FASCIA/graph.hpp"

int main(int argc, char **argv) {
    // process command line args
    if (argc < 3) {
        std::cout << "Usage: ensemble <path to network> <how many to generate>" << std::endl;
    }

    char *input_path = argv[1];
    int num_graphs = atoi(argv[2]);
    const int Q = 100;

    Graph g;
    int *sources;
    int *destinations;
    int *labels;

    read_in_graph(g, input_path, false, sources, destinations, labels);

    int edges = g.num_edges() / 2;

    // create output directory
    std::string path = "./random_graphs";

    if (opendir(path.c_str())) {
        system(("rm -rf " + path).c_str());
    }

    const int dir_err = mkdir("./random_graphs", S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    if (-1 == dir_err) {
        std::cout << "Error creating directory!" << std::endl;
        exit(1);
    }
    // Initialize target arrays
    int *target_srcs = new int[edges];
    int *target_dsts = new int[edges];

    // Initialize RNG seeds
    unsigned int seed1 = time(nullptr);
    unsigned int seed2 = seed1 + 1;

    for (int iter = 1; iter <= num_graphs; ++iter) {
        std::cout << "\rGenerating: " << iter << " / " << num_graphs << std::flush;

        // Create a new copy of the initial graph
        std::copy(sources, sources + edges, target_srcs);
        std::copy(destinations, destinations + edges, target_dsts);

        // randomly permute edges
        for (int i = 0; i < Q * edges; ++i) {
            int e1 = rand_r(&seed1) % edges;
            int e2 = rand_r(&seed2) % edges;

            // a -> b, c -> d => a -> d, c -> b
            std::swap(target_dsts[e1], target_dsts[e2]);
        }

        // write the graph to file
        char filename[200];
        snprintf(filename, sizeof(filename), "./random_graphs/random_%d.graph", iter);

        std::ofstream file(filename);

        file << g.num_vertices() << std::endl;
        file << edges << std::endl;

        for (int i = 0; i < edges; ++i) {
            file << target_srcs[i] << " " << target_dsts[i] << std::endl;
        }

        file.close();
    }

    std::cout << std::endl;
}
