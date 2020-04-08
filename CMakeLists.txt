cmake_minimum_required(VERSION 3.9)
project(Motifs LANGUAGES CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if (APPLE)
    set(CMAKE_CXX_COMPILER clang++)
else ()
    set(CMAKE_CXX_COMPILER g++)
endif ()

add_compile_options("-std=gnu++0x" "-O3" "-Wall" "-Wno-expansion-to-defined")

# FASCIA
find_package(OpenMP)

if (OpenMP_FOUND)
    FILE(GLOB FASCIA_SOURCES FASCIA/*.h FASCIA/*.hpp)
    add_executable(fascia FASCIA/fascia.cpp ${FASCIA_SOURCES})
    target_link_libraries(fascia PUBLIC OpenMP::OpenMP_CXX)
else ()
    message(WARNING "OpenMP not found, skipping FASCIA")
endif ()

# Random graph generator
add_executable(ensemble src/ensemble.cpp)
