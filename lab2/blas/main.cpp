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
    gsl_matrix *matrix = gsl_matrix_alloc(length, length);
    for (size_t i = 0; i < length; i++) {
        for (size_t j = 0; j < length; j++) {
            gsl_matrix_set(matrix, i, j, rand() / RAND_MAX);
        }
    }
    return matrix;
}

double* ddot(size_t array_size, size_t vector_length) {
    double *res = new double[array_size];
    gsl_vector *vec1 = random_vector(vector_length);
    gsl_vector *vec2 = random_vector(vector_length);
    gsl_blas_ddot(vec1, vec2, res);
    gsl_vector_free(vec1);
    gsl_vector_free(vec2);
    return res;
}

void dgemv(size_t array_size, size_t vector_length){
    gsl_matrix *A = random_matrix(vector_length);
    gsl_vector *X = random_vector(vector_length);
    gsl_vector *Y = random_vector(vector_length);
    gsl_blas_dgemv(CblasNoTrans, 1, A, X,1,Y);
    gsl_vector_free(X);
    gsl_vector_free(Y);
    gsl_matrix_free(A);
}

int main() {
    timespec start, stop;
    printf("Vector x Vector (ddot)\n");
    for(int j=10;j<10000000;j*=10){
        double sum=0.0;
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
            sum+=dur;
        }
        sum/=10;
        printf("%i\n",j);
    }
    printf("Matrix x Vector (dgemv)\n");
    for(int j=100;j<10000;j*=3){
        double sum=0.0;
        for(int i=0;i<10;i++) {
            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            dgemv(j, j);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            double dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec)*1.0/1000000000;
            printf("%lf,",dur);
            sum+=dur;
        }
        sum/=10;
        printf("%i\n",j);
    }

    return 0;
}