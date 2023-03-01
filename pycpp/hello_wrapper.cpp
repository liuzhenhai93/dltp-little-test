//
// Created by liuzhenhai on 28.2.23.
//

#include "pybind11/pybind11.h"

#include "hello.h"

PYBIND11_MODULE(hello, m) {
  m.doc() = "python c++ example";
  m.def("hello", &hello, "hello from c++ code");
}
