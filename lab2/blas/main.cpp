#include <stdio.h>
#include <gsl/gsl_blas.h>
#include <cstdlib>
#include <ctime>

gsl_vector *random_vector(size_t length) {
    gsl_vector *vec1 = gsl_vector_alloc(length);
    for (size_t i = 0; i < length; i++) {
        gsl_vector_set(vec1, i, rand() / RAND_MAX);
    }
    return vec1;
}

gsl_matrix *random_matrix(size_t length) {
    gsl_vector *vec1 = gsl_vector_alloc(length);
    for (size_t i = 0; i < length; i++) {
        gsl_vector_set(vec1, i, rand() / RAND_MAX);
    }
    return vec1;
}

double* ddot(size_t array_size, size_t vector_length) {
    double *res = new double[array_size];
    gsl_vector *vec1 = random_vector(vector_length);
    gsl_vector *vec2 = random_vector(vector_length);
    gsl_blas_ddot(vec1, vec2, res);
    return res;
}

double *dgemv(size_t array_size, size_t vector_length){
    gsl_vector *vec1 = random_vector(vector_length);
    gsl_vector *vec2 = random_vector(vector_length);
    gsl_blas_dgemv(CblasNoTrans, 1, ,,1);
}

int main() {
    timespec start, stop;
    for(int j=10;j<10000000;j*=100){
        for(int i=0;i<10;i++) {
            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            double *res = ddot(j, j);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            double dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec)*1.0/1000000000;
            printf("%lf,",dur);
        }
        printf("%i\n",j);
    }

    return 0;
}