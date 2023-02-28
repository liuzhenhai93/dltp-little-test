cmake_minimum_required(VERSION 3.16)
project(hello_world LANGUAGES CXX CUDA)
set(CMAKE_CXX_STANDARD 17)
include(cmake/pybind.cmake)
pybind11_add_module(hello pycpp/hello_wrapper.cpp pycpp/hello.cpp)
add_executable(simple_sum_test cuda/simple_sum_test.cpp cuda/simple_sum.cu)

