//
// Created by liuzhenhai on 28.2.23.
//

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
    cudaMalloc( (void**)&x_d, n * sizeof(float) );
    cudaMalloc( (void**)&y_d, n * sizeof(float) );
    cudaMalloc( (void**)&z_d, n * sizeof(float) );
    cudaMemcpy(x_d, x, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(y_d, y, n * sizeof(float), cudaMemcpyHostToDevice);
    constexpr int block_size = 256;
    constexpr int grid_size = 1024;
    AddKernel<<<grid_size, block_size>>>(x_d, y_d, z_d, n);
    cudaMemcpy(y, y_d, n * sizeof(float), cudaMemcpyDeviceToHost);
    // free the memory allocated on the GPU
    cudaFree( x_d );
    cudaFree( y_d );
    cudaFree( z_d );
}

void Add2dWithKernel(float *x, float *y, float *z, int m, int n) {
    Add1dWithKernel(x, y, z, m *  n);
}