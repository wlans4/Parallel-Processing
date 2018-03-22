#include <stdlib.h>
#include <stdio.h>

#include "cuda.h"


__global__ void kernelHelloWorld(){



	int thread = threadIdx.x; //local thread number in a block
	int block = blockIdx.x;   //block number
	printf("Hello World from thread %d of block %d!\n", thread, block);


}


int main(int argc, char** argv){


	int Nblocks = 10; //number of blocks 
	int Nthreads = 3; //number of threads per blocks



	//run the function 'kernelHelloWorld on the DEVICE
	kernelHelloWorld <<< Nblocks, Nthreads >>> ();


	//Wait for the DEVICE function to complete before program finishes
	cudaDeviceSynchronize();
	return 0;


}
