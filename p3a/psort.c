#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include "psort.h"

int numRecords;
int numThreads;

// helper function to print recordArray elements
void printrecordArray(Record recordArray[], int numRecords)
{
    for (int i = 0; i < numRecords; ++i) {
        printf("%d  ", recordArray[i].key);
    }
    printf("\n");
}

// helper function to write sorted records to file
void writeOutput(Record recordArray[], int numRecords, char* outputFile)
{
    FILE *fout;
    fout = fopen(outputFile, "w");

    for (int i = 0; i < numRecords; i++) {
        for (int j = 0; j < 25; j++) {
            if(j == 0)
                fwrite(&recordArray[i].key, sizeof(int), 1, fout);
            else
                fwrite(&recordArray[i].data[j-1], sizeof(int), 1, fout);
        }
    }

    fclose(fout);
}

// merge subarrays at end
void merge_subarr(Record arr[], int num, int count)
{
    for(int i = 0; i < num; i = i+2) {
        int low = i * ((numRecords/numThreads) * count);
        int high = ((i+2) * (numRecords/numThreads) * count) - 1;
        int middle = low + ((numRecords/numThreads) * count) - 1;
        if (high >= numRecords) {
            high = numRecords - 1;
        }
        merge(arr, low, middle, high);
    }
    if (num/2 >= 1) {
        merge_subarr(arr, num/2, count*2);
    }
}

// threaded merge sort
void *parallel_sort(void* argc)
{
    struct mSortArgs* args = argc;
    int middle = args->low + (args->high - args->low) / 2;
    if (args->low < args->high) {
        merge_sort(args->arr, args->low, args->high);
        merge_sort(args->arr, args->low + 1, args->high);
        merge(args->arr, args->low, middle, args->high);
    }
    return NULL;
}

// non-threaded merge sort
void merge_sort(Record arr[], int left, int right)
{
    if (left < right) {
        int middle = left + (right - left) / 2;
        merge_sort(arr, left, middle);
        merge_sort(arr, middle + 1, right);
        merge(arr, left, middle, right);
    }
}

// merge function
void merge(Record arr[], int left, int middle, int right)
{
    int k = 0;
    int low_length = middle - left + 1;
    int high_length = right - middle;
    Record* low_arr = (Record*)malloc(low_length * sizeof(Record));
    Record* high_arr = (Record*)malloc(high_length * sizeof(Record));
    
    for (int i = 0; i < low_length; i ++) {
        low_arr[i] = arr[left + i];
    }
    
    for (int j = 0; j < high_length; j ++) {
        high_arr[j] = arr[middle + 1 + j];
    }
    
    int a = 0;
    int b = 0;
    
    while (a < low_length && b < high_length) {
        if (low_arr[a].key <= high_arr[b].key) {
            arr[left+k] = low_arr[a];
            a ++;
        } else {
            arr[left+k] = high_arr[b];
            b++;
        }
        k++;
    }
    
    while (b < high_length) {
        arr[left+k] = high_arr[b];
        k++;
        b++;
    }

    while (a < low_length) {
        arr[left+k] = low_arr[a];
        k++;
        a++;
    }

    free(low_arr);
    free(high_arr);
}

int main(int argc, char* argv[])
{

    FILE *fileptr;
    char *buffer;
    long fileLen; // in bytes

    fileptr = fopen(argv[1], "rb");
    if(!fileptr) {
        fprintf(stderr, "An error has occurred\n");
        exit(0);
    }

    char *outputFile = argv[2];
    fseek(fileptr, 0, SEEK_END); // point fileptr to end of input.bin
    fileLen = ftell(fileptr); // size of file
    if(fileLen == 0) {
        fprintf(stderr, "An error has occurred\n");
        exit(0);
    }

    rewind(fileptr); // move fileptr back to beginning of input.bin
    numRecords = fileLen/100;
    numThreads = get_nprocs();

    Record* recordArray;
    recordArray = (Record*)malloc(numRecords * sizeof(Record));

    buffer = (char *)malloc(fileLen * sizeof(char)); // one byte per line of input.bin
    int rc = fread(buffer, 100, numRecords, fileptr); // load input.bin into buffer
    if(!rc) {
        fprintf(stderr, "An error has occurred\n");
        exit(0);
    }

    fclose(fileptr);

    int *iptr = (int *)buffer; // point iptr to beginning of buffer
    for (int i = 0; i < numRecords; i++) {
        for (int j = 0; j < 25; j++) {
            if(j == 0)
                recordArray[i].key = *iptr;
            else
                recordArray[i].data[j-1] = *iptr;
            iptr++;
        }
    }
    
    // create threads and args array
    pthread_t threads[numThreads];
    struct mSortArgs args[numThreads];

    // execute threads
    for (int i = 0; i < numThreads; i ++) {

        int low = i * (numRecords / numThreads);
        int high;

        if (i == numThreads - 1) {
            high = numRecords - 1;
        } else {
            high = low + (numRecords / numThreads) - 1;
        }

        struct mSortArgs arg = {low, high, recordArray};
        args[i] = arg;

        pthread_create(&threads[i], NULL, parallel_sort, &args[i]);
    }
    
    // join threads
    for(int i = 0; i < numThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    merge_subarr(recordArray, numThreads, 1);

    //DEBUG CODE
    // FILE *debug;
    // debug = fopen("debug.txt", "a");
    // fprintf(debug, "RIGHT AFTER OPENING FILE\n");
    // fclose(debug);
    //DEBUG CODE
    
    writeOutput(recordArray, numRecords, outputFile);

    free(recordArray);
    free(buffer);
    return 0;
}