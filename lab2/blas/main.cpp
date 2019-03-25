#include <stdio.h>
#include <gsl/gsl_blas.h>
#include <cstdlib>
#include <ctime>
#include <string>

gsl_vector *random_vector(size_t length) {
    gsl_vector *vec1 = gsl_vector_alloc(length);
    for (size_t i = 0; i < length; i++) {
        gsl_vector_set(vec1, i, rand() / RAND_MAX);
    }
    return vec1;
}

gsl_matrix *random_matrix(size_t length) {
    gsl_matrix *matrix = gsl_matrix_alloc(length, length);
    for (size_t i = 0; i < length; i++) {
        for (size_t j = 0; j < length; j++) {
            gsl_matrix_set(matrix, i, j, rand() / RAND_MAX);
        }
    }
    return matrix;
}

void *ddot(size_t vector_length) {
    double res[vector_length];
    gsl_vector *vec1 = random_vector(vector_length);
    gsl_vector *vec2 = random_vector(vector_length);
    gsl_blas_ddot(vec1, vec2, res);
    gsl_vector_free(vec1);
    gsl_vector_free(vec2);
}

void dgemv(size_t vector_length) {
    gsl_matrix *A = random_matrix(vector_length);
    gsl_vector *X = random_vector(vector_length);
    gsl_vector *Y = random_vector(vector_length);
    gsl_blas_dgemv(CblasNoTrans, 1, A, X, 1, Y);
    gsl_vector_free(X);
    gsl_vector_free(Y);
    gsl_matrix_free(A);
}

int main(int argc, char **argv) {

    int numOfSteps = 5, minDdot = 1, minDgemv = 1, stepDdot = 50, stepDgemv = 5;

    if (argc > 1)numOfSteps = std::stoi(argv[1]);
    if (argc > 3) {
        stepDdot = std::stoi(argv[2]);
        stepDgemv = std::stoi(argv[3]);
    }
    if (argc > 5) {
        minDdot = std::stoi(argv[4]);
        minDgemv = std::stoi(argv[5]);
    }
    timespec start, stop;
    printf("ddot_time,dgemv_time,ddot_size,dgemv_size\n");
    int ddotSize = minDdot;
    int dgemvSize = minDgemv;
    for (int j = 0; j < numOfSteps; j++) {
        for (int i = 0; i < 10; i++) {
            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            ddot(ddotSize);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            double dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
            printf("%lf,", dur);
            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            dgemv(dgemvSize);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
            printf("%lf,", dur);
            printf("%i,%i\n", ddotSize, dgemvSize);
        }
        ddotSize += stepDdot;
        dgemvSize += stepDgemv;
    }
    return 0;
}