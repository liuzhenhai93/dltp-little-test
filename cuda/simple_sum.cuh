//
// Created by liuzhenhai on 28.2.23.
//

#pragma once

void Add1d(const float *x, const float *y, float *z, int n);

void Add2d(const float *x, const float *y, float *z, int m, int n);

void Add1dWithKernel(const float *x, const float *y, float *z, int n);

void Add2dWithKernel(const float *x, const float *y, float *z, int m, int n);
