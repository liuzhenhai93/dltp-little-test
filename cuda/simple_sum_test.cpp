//
// Created by liuzhenhai on 28.2.23.
//

#include <iostream>
#include <math.h>

#include "simple_sum.cuh"

void Init(float *a, float *b, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = (i % 1000) / 10.0;
        b[i] = (i % 1000) / 10.0;
    }
}

bool CheckPrecision(float *a, float *b, int n) {
    for (int i = 0; i < n; i++) {
        if (std::abs(a[i] - b[i]) > 1e-5) {
            std::cout << "a[" << i << "]: " << a[i] << "b[" << i << "]: " << b[i] << std::endl;
        }
    }
}

int main() {
    int m = 1024;
    int n = 1024 * 64;
    float *a = new float[m * n];
    float *b = new float[m * n];
    float *c = new float[m * n];
    float *d = new float[m * n];
    Init(a, b,m * n);
    Add1d(a, b, c, m * n);
    Add1dWithKernel(a, b, d, m * n);
    CheckPrecision(c, d, m * n);
    Add2dWithKernel(a, b, d, m ,  n);
    CheckPrecision(c, d, m * n);
}
