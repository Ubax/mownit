#include <iostream>
#include <gsl/gsl_blas.h>

gsl_matrix *random_matrix(size_t length) {
    gsl_matrix *matrix = gsl_matrix_alloc(length, length);
    for (size_t i = 0; i < length; i++) {
        for (size_t j = 0; j < length; j++) {
            gsl_matrix_set(matrix, i, j, rand() / RAND_MAX);
        }
    }
    return matrix;
}

int naiveMultiply(gsl_matrix *A, gsl_matrix *B, gsl_matrix *matrix) {
    if (A->size2 != B->size1) {
        printf("Invalid matrixes sizes\n");
        return 1;
    }

    for (int c = 0; c < B->size1; c++) {
        for (int r = 0; r < A->size1; r++) {
            for (int k = 0; k < A->size2; k++) {
                gsl_matrix_set(matrix, r, c, gsl_matrix_get(A, r, k) + gsl_matrix_get(A, k, c));
            }
        }
    }
    return 0;
}

int betterMultiply(gsl_matrix *A, gsl_matrix *B, gsl_matrix *matrix) {
    if (A->size2 != B->size1) {
        printf("Invalid matrixes sizes\n");
        return 1;
    }

    for (int r = 0; r < A->size1; r++) {
        for (int c = 0; c < B->size1; c++) {
            for (int k = 0; k < A->size2; k++) {
                gsl_matrix_set(matrix, r, c, gsl_matrix_get(A, r, k) + gsl_matrix_get(A, k, c));
            }
        }
    }
    return 0;
}

int main(int argc, char **argv) {
    int min = 10, max = 200, step = 20;

    if (argc > 1)max = std::stoi(argv[1]);
    if (argc > 2)step = std::stoi(argv[2]);
    if (argc > 3)min = std::stoi(argv[3]);

    if(min>max){
        printf("Max should be greater than min\n");
        exit(1);
    }
    if(min<=0 || max <= 0 || step <=0){
        printf("Max, step and min should be positive\n");
        exit(1);
    }

    timespec start, stop;
    printf("Size,Naive,Better,Blas\n");
    for (size_t size = min; size <= max; size += step) {
        for (int i = 0; i < 10; i++) {
            printf("%ld,", size);
            gsl_matrix *A = random_matrix(size);
            gsl_matrix *B = random_matrix(size);
            gsl_matrix *res = gsl_matrix_alloc(size, size);
            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }

            naiveMultiply(A, B, res);
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
            betterMultiply(A, B, res);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
            printf("%lf,", dur);

            if (clock_gettime(CLOCK_REALTIME, &start) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1, A, B, 1, res);
            if (clock_gettime(CLOCK_REALTIME, &stop) == -1) {
                printf("Problem with clock\n");
                return 1;
            }
            dur = stop.tv_sec - start.tv_sec + (stop.tv_nsec - start.tv_nsec) * 1.0 / 1000000000;
            printf("%lf", dur);
            gsl_matrix_free(res);
            printf("\n");
        }
    }
    return 0;
}