//
// Created by liuzhenhai on 28.2.23.
//


#include <stdio.h>

static void HandleError( cudaError_t err,
                         const char *file,
                         int line ) {
    if (err != cudaSuccess) {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
                file, line );
        exit( EXIT_FAILURE );
    }
}
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))


#define HANDLE_NULL( a ) {if (a == NULL) { \
                            printf( "Host memory failed in %s at line %d\n", \
                                    __FILE__, __LINE__ ); \
                            exit( EXIT_FAILURE );}}

// grid stride loop
__global__ void AddKernel(float *x, float *y, float *z, int n) {
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for (int i = index; i < n; i += stride) {
        z[i] = x[i] + y[i];
    }
}

void Add1d(float *x, float *y, float *z, int n) {
    for (int i = 0; i < n; i++) {
        z[i] = x[i] + y[i];
    }
}

void Add2d(float *x, float *y, float *z, int m, int n) {
    Add1d(x, y, z, m * n);
}


void Add1dWithKernel(float *x, float *y, float *z, int n) {
    float *x_d, *y_d, *z_d;
    // allocate gpu memory
    HANDLE_ERROR(cudaMalloc( (void**)&x_d, n * sizeof(float) ));
    HANDLE_ERROR(cudaMalloc( (void**)&y_d, n * sizeof(float) ));
    HANDLE_ERROR(cudaMalloc( (void**)&z_d, n * sizeof(float) ));
    HANDLE_ERROR(cudaMemcpy(x_d, x, n * sizeof(float), cudaMemcpyHostToDevice));
    HANDLE_ERROR(cudaMemcpy(y_d, y, n * sizeof(float), cudaMemcpyHostToDevice));
    constexpr int block_size = 256;
    constexpr int grid_size = 1024;
    AddKernel<<<grid_size, block_size>>>(x_d, y_d, z_d, n);
    cudaMemcpy(y, y_d, n * sizeof(float), cudaMemcpyDeviceToHost);
    // free the memory allocated on the GPU
    HANDLE_ERROR(cudaFree( x_d ));
    HANDLE_ERROR(cudaFree( y_d ));
    HANDLE_ERROR(cudaFree( z_d ));
}

void Add2dWithKernel(float *x, float *y, float *z, int m, int n) {
    Add1dWithKernel(x, y, z, m *  n);
}
