#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    const char *alloc_size_str = getenv("ALLOC_SIZE");
    const char *num_allocs_str = getenv("NUM_ALLOCS");

    if (!alloc_size_str || !num_allocs_str) {
        fprintf(stderr, "Environment variables ALLOC_SIZE and NUM_ALLOCS must be set.\n");
        return 1;
    }

    int alloc_size = atoi(alloc_size_str);
    int num_allocs = atoi(num_allocs_str);

    if (alloc_size <= 0 || num_allocs <= 0) {
        fprintf(stderr, "Invalid values for ALLOC_SIZE or NUM_ALLOCS.\n");
        return 1;
    }

    clock_t start, end;
    double cpu_time_used;
    char *ptr;

    start = clock();
    for (int i = 0; i < num_allocs; i++) {
        ptr = (char *)malloc(alloc_size);
        if (!ptr) {
            fprintf(stderr, "Memory allocation failed at iteration %d\n", i);
            return 1;
        }
        free(ptr);
    }
    end = clock();

    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("num_allocs: %d\nnum_deallocs %d\nbytes: %d\nseconds: %f\n", num_allocs, alloc_size, num_allocs * alloc_size, cpu_time_used);

    return 0;
}
