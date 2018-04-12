/* 

To compile:

   nvcc -O3 -o mandelbrot mandelbrot.c png_util.c -I. -lpng -lm -fopenmp

Or just type:

   module load gcc
   make

To create an image with 4096 x 4096 pixels (last argument will be used to set number of threads):

    ./mandelbrot 4096 4096 1

*/

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "png_util.h"

#include "cuda.h"

// Q2a: add include for CUDA header file here:

#define MXITER 1000

typedef struct {
  
  double r;
  double i;
  
}complex_t;

// return iterations before z leaves mandelbrot set for given c
//ADD __DEVICE__ to make visible to gpu
__device__  int testpoint(complex_t c){
  
  int iter;

  complex_t z;
  double temp;
  
  z = c;
  
  for(iter=0; iter<MXITER; iter++){
    
    temp = (z.r*z.r) - (z.i*z.i) + c.r;
    
    z.i = z.r*z.i*2. + c.i;
    z.r = temp;
    
    if((z.r*z.r+z.i*z.i)>4.0){
      return iter;
    }
  }
  
  
  return iter;
  
}

// perform Mandelbrot iteration on a grid of numbers in the complex plane
// record the  iteration counts in the count array

// Q2c: transform this function into a CUDA kernel
__global__ void  mandelbrot(int Nre, int Nim, complex_t cmin, complex_t cmax, float *count){ 
  int n,m;

  complex_t c;

  double dr = (cmax.r-cmin.r)/(Nre-1);
  double di = (cmax.i-cmin.i)/(Nim-1);;

	n = threadIdx.x + blockIdx.x * blockDim.x;
	m = threadIdx.y + blockIdx.y * blockDim.y;
	
//  for(n=0;n<Nim;++n){
  //  for(m=0;m<Nre;++m){
      c.r = cmin.r + dr*m;
      c.i = cmin.i + di*n;
      //m+n*Nre
      count[m+n] = testpoint(c);
      
  //  }
//  }

}

int main(int argc, char **argv){

  // to create a 4096x4096 pixel image [ last argument is placeholder for number of threads ] 
  // usage: ./mandelbrot 4096 4096 1  
  
  printf("TEST\n");
  int Nre = atoi(argv[1]);
printf("Test2\n");
  int Nim = atoi(argv[2]);
printf("Test3\n");
  int Nthreads = atoi(argv[3]);

printf("testblahg\n");
  
  // Q2b: set the number of threads per block and the number of blocks here: 
  
  
   float *d_a;
printf("testblah2\n");
  //2D Block
  int NBlocksx = Nre;
  int NBlocksy = Nim;
  int NBlocksz = 1;
 printf("Test1.5\n"); 
  //Num Blocks
  int NGridsx = 1;
  int NGridsy = 1;
  int NGridsz = 1;
 printf("Test1.75\n"); 
 printf("Test2\n"); 
  cudaMalloc(&d_a, Nre*Nim*sizeof(float));
  printf("Test3\n");
  dim3 B(NBlocksx, NBlocksy, NBlocksz); //2D threads
  dim3 G(NGridsx, NGridsy, NGridsz); //grid of threads
  
  // storage for the iteration counts
  float *count = (float*) malloc(Nre*Nim*sizeof(float));
  
  
  // Parameters for a bounding box for "c" that generates an interesting image
  const float centRe = -.759856, centIm= .125547;
  const float diam  = 0.151579;

  complex_t cmin; 
  complex_t cmax;

  cmin.r = centRe - 0.5*diam;
  cmax.r = centRe + 0.5*diam;
  cmin.i = centIm - 0.5*diam;
  cmax.i = centIm + 0.5*diam;

  clock_t start = clock(); //start time in CPU cycles

  // compute mandelbrot set
  mandelbrot <<<G,B>>> (Nre, Nim, cmin, cmax, count); 
  
  clock_t end = clock(); //start time in CPU cycles
  printf("MEMCPY\n"); 
  cudaMemcpy(d_a, count, Nre*Nim*sizeof(float), cudaMemcpyHostToDevice);
  // print elapsed time
  printf("elapsed = %f\n", ((double)(end-start))/CLOCKS_PER_SEC);

  // output mandelbrot to png format image
  FILE *fp = fopen("mandelbrot.png", "w");

  printf("Printing mandelbrot.png...");
 // write_hot_png(fp, Nre, Nim, count, 0, 80);
  printf("done.\n");

  free(count);

  exit(0);
  return 0;
}  
