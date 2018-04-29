#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "functions.h"
#include "cuda.h"
#include "functions.c"
__device__ unsigned int deviceModProd(unsigned int a, unsigned int b, unsigned int p){
	unsigned int za = a;
	unsigned int ab = 0;
	

	while (b > 0){
		if (b%2 == 1) ab = (ab + za) % p;
		za = (2 * za) % p;
		b /= 2;
	}

	return ab;
}


__device__ unsigned int deviceModExp(unsigned int a, unsigned int b, unsigned int p){

	unsigned int z = a;
	unsigned int aExpb = 1;

	while (b > 0){
		if (b%2 == 1) aExpb = deviceModProd(aExpb, z, p);
		z = deviceModProd(z, z, p);
		b /= 2;
	}
	return aExpb;

}

__global__ void find(unsigned int p, unsigned int g, unsigned int h, unsigned int* result){

	unsigned int x = (unsigned int)(threadIdx.x + blockIdx.x*blockDim.x);
	unsigned int y = (unsigned int)(threadIdx.y + blockIdx.y*blockDim.y);

	unsigned int i = y*blockDim.x * gridDim.x + x;
	if (i < p){
		if (deviceModExp(g, i + 1, p) == h){
			*result = i + 1;
		}

	}
}



int main (int argc, char **argv) {

  //declare storage for an ElGamal cryptosytem
  unsigned int n, p, g, h, x;
  unsigned int Nints;
  unsigned int Nchars;
  
  //get the secret key from the user
  printf("Enter the secret key (0 if unknown): "); fflush(stdout);
  char stat = scanf("%u", &x);

  printf("Reading file.\n");

  /* Q3 Complete this function. Read in the public key data from public_key.txt
    and the cyphertexts from messages.txt. */

  //Read in from public_key.txt
  FILE *file = fopen("bonus_public_key.txt", "r");
  if (file == NULL){
	printf("ERROR: bonus_public_key.txt does not exist\n");
	return -1;
  }

  fscanf(file, "%d %d %d %d", &n, &p, &g, &h);
  printf("Read in public_key.txt\n");
  fclose(file);
  file = fopen("bonus_message.txt", "r");
  if (file == NULL){
	printf("ERROR: bonus_message.txt does not exist\n");
	return -1;
  }

  fscanf(file, "%u",&Nints);
  unsigned int* Z = (unsigned int*) malloc(Nints*sizeof(unsigned int));
  unsigned int* a = (unsigned int*) malloc(Nints*sizeof(unsigned int));
  for (int i = 0; i < Nints; i++){
	fscanf(file, "%u %u\n", &Z[i], &a[i]);
  }
  fclose(file);
  Nchars = Nints*(n-1)/8;





  unsigned int* h_x = (unsigned int*) malloc(sizeof(unsigned int));
  *h_x = 0;
  unsigned int* d_x;
  cudaMalloc(&d_x, sizeof(unsigned int));
  dim3 B(32, 32, 1);
  int N = (n - 9)/2;
  if (N < 0){
	N = 0;
  }
  N = 1 << N;
  dim3 G(N, N, 1);

  printf("Read in cyphertexts from messages.txt\n");
  double startTime = clock();
 find  <<< G, B >>> (p, g, h, d_x);
  cudaDeviceSynchronize();   
  double endTime = clock();

    double totalTime = (endTime-startTime)/CLOCKS_PER_SEC;
    double work = (double) p;
    double throughput = work/totalTime;

	
    printf("Searching all keys took %g seconds, throughput was %g values tested per second.\n", totalTime, throughput);
  


cudaMemcpy(h_x, d_x, sizeof(unsigned int), cudaMemcpyDeviceToHost);
printf("The secret key is %u\n", *h_x);

printf("The decrypted message is:\n");
        unsigned char* message = (unsigned char*) malloc(100*sizeof(unsigned char));
        ElGamalDecrypt(Z, a, Nints, p, *h_x);
        convertZToString(Z, Nints, message, Nchars);
        printf("\"%s\"\n", message);
        printf("\n");
	free(h_x);
	
}
