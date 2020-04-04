#pragma once

#include <fstream>
#include <string>

#include "graph.hpp"

void read_in_graph(Graph &g, char *graph_file, bool labeled, int *&srcs_g, int *&dsts_g, int *&labels_g) {
    ifstream file_g;
    string line;

    file_g.open(graph_file);

    int n_g;
    int m_g;

    getline(file_g, line);
    n_g = atoi(line.c_str());
    getline(file_g, line);
    m_g = atoi(line.c_str());

    srcs_g = new int[m_g];
    dsts_g = new int[m_g];

    if (labeled) {
        labels_g = new int[n_g];
        for (int i = 0; i < n_g; ++i) {
            getline(file_g, line);
            labels_g[i] = atoi(line.c_str());
        }
    } else {
        labels_g = NULL;
    }

    for (int i = 0; i < m_g; ++i) {
        getline(file_g, line, ' ');
        srcs_g[i] = atoi(line.c_str());
        getline(file_g, line);
        dsts_g[i] = atoi(line.c_str());
    }
    file_g.close();

    g.init(n_g, m_g, srcs_g, dsts_g);
}
