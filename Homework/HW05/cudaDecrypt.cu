#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "cuda.h"
#include "functions.c"




__device__ unsigned int DeviceModprod(unsigned int a, unsigned int b, unsigned int p) {
  unsigned int za = a;
  unsigned int ab = 0;

  while (b > 0) {
    if (b%2 == 1) ab = (ab +  za) % p;
    za = (2 * za) % p;
    b /= 2;
  }
  return ab;
}

//compute a^b mod p safely
__device__  unsigned int DeviceModExp(unsigned int a, unsigned int b, unsigned int p) {
  unsigned int z = a;
  unsigned int aExpb = 1;

  while (b > 0) {
    if (b%2 == 1) aExpb = DeviceModprod(aExpb, z, p);
    z = DeviceModprod(z, z, p);
    b /= 2;
  }
  return aExpb;
}


__global__ void findKey(unsigned int x, unsigned int p, unsigned int g, unsigned int h, unsigned int* result){

	int i = 0;
      if (DeviceModExp(g, i+1, p) == h) {
        printf("Secret key found! x = %u \n", i+1);
        *result = i + 1;
	i++;
      }
}

int main (int argc, char **argv) {
  unsigned int n, p, g, h, x;
  unsigned int Nints;

  //get the secret key from the user
  printf("Enter the secret key (0 if unknown): "); fflush(stdout);
  char stat = scanf("%u",&x);

  printf("Reading file.\n");

  //Read in from public_key.txt
  FILE *file = fopen("public_key.txt", "r");
  if (file == NULL){
        printf("ERROR: public_key.txt does not exist\n");
        return -1;
  }

  fscanf(file, "%d %d %d %d", &n, &p, &g, &h);
  printf("Read in public_key.txt\n");

  file = fopen("message.txt", "r");
  if (file == NULL){
        printf("ERROR: message.txt does not exist\n");
        return -1;
  }

  fscanf(file, "%d", &Nints);
  unsigned int* ints = (unsigned int*) malloc(Nints*sizeof(unsigned int));
  for (int i = 0; i < Nints - 1; i++){
        fscanf(file, "%u", (ints + i));
  }
  printf("Read in cyphertexts from messages.txt\n");


  int Nblocks = 1;
  int Nthreads = 1;
  unsigned int* h_count = (unsigned int*) malloc(1*sizeof(unsigned int));;
  unsigned int* d_count;
  cudaMalloc(&d_count, sizeof(unsigned int));
  // find the secret key
  double startTime = clock();
  if (x==0 || modExp(g,x,p)!=h) {
    printf("Finding the secret key...\n");
    findKey <<< Nblocks, Nthreads>>> (x, p, g, h, d_count);
      }
  	
    cudaMemcpy(h_count, d_count, sizeof(unsigned int), cudaMemcpyHostToDevice);
    double endTime = clock();
    printf("The secret key is %u\n", *h_count);
    double totalTime = (endTime-startTime)/CLOCKS_PER_SEC;
    double work = (double) p;
    double throughput = work/totalTime;

    printf("Searching all keys took %g seconds, throughput was %g values tested per second.\n", totalTime, throughput);
  }





