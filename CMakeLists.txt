cmake_minimum_required(VERSION 3.9)
project(Motifs LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_compile_options("-std=gnu++0x" "-Ofast" "-ffast-math" "-Wall" "-Wno-expansion-to-defined")

find_package(OpenMP REQUIRED)

# FASCIA
FILE(GLOB FASCIA_SOURCES FASCIA/*.h FASCIA/*.hpp)
add_executable(fascia FASCIA/fascia.cpp ${FASCIA_SOURCES})
target_link_libraries(fascia PUBLIC OpenMP::OpenMP_CXX)

# Narzędzie do generowania sieci podobnych
add_executable(ensemble src/ensemble.cpp)
target_link_libraries(ensemble PUBLIC OpenMP::OpenMP_CXX)
