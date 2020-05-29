#include <iostream>
#include <memory>
#include <string>
#include <filesystem>
#include <random>
#include <thread>

#if defined (_MSC_VER)  // Visual studio
#define thread_local __declspec( thread )
#elif defined (__GCC__) // GCC
#define thread_local __thread
#endif

#include "../FASCIA/load_graph.hpp"

int intRand(const int &min, const int &max) {
    static thread_local std::mt19937 generator(static_cast<unsigned int>(time(nullptr)));
    std::uniform_int_distribution<int> distribution(min, max);
    return distribution(generator);
}

int main(int argc, char **argv) {
    // process command line args
    if (argc < 3) {
        std::cout << "Usage: ensemble <path to network> <how many to generate>" << std::endl;
        return 1;
    }

    char *input_path = argv[1];
    int num_graphs = atoi(argv[2]);

    Graph g;
    int *sources = nullptr, *destinations = nullptr, *labels = nullptr;
    read_in_graph(g, input_path, false, sources, destinations, labels);

    const int edges = g.num_edges() / 2;

    // create output directory
    const std::string path{"./random_graphs"};

    std::filesystem::remove_all(path);
    std::filesystem::create_directory(path);

    if (!std::filesystem::exists(path)) {
        std::cout << "Error creating directory!" << std::endl;
        exit(1);
    }

#pragma omp parallel default(shared)
    {
        // Initialize arrays for each thread
        std::unique_ptr<int[]> target_srcs(new int[edges]);
        std::unique_ptr<int[]> target_dsts(new int[edges]);

#pragma omp for schedule(dynamic)
        for (int iter = 1; iter <= num_graphs; ++iter) {
            if (iter % 10 == 0) {
                std::cout << "\rGenerating: " << iter << " / " << num_graphs << std::flush;
            }

            // Create a new copy of the initial graph
            std::copy(sources, sources + edges, target_srcs.get());
            std::copy(destinations, destinations + edges, target_dsts.get());

            // randomly permute edges
            for (int i = 0; i < 100 * edges; ++i) {
                int e1 = intRand(0, edges - 1);
                int e2 = intRand(0, edges - 1);

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

    }

    std::cout << std::endl;
}
