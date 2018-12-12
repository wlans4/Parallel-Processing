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

#define MXITER 1000

typedef struct {
  
  double r;
  double i;
  
}complex_t;

// return iterations before z leaves mandelbrot set for given c
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

__global__ void  mandelbrot(int Nre, int Nim, complex_t cmin, complex_t cmax, float *count){ 
  int n,m;

  complex_t c;

  double dr = (cmax.r-cmin.r)/(Nre-1);
  double di = (cmax.i-cmin.i)/(Nim-1);;

  n = threadIdx.x + blockIdx.x * blockDim.x;
  m = threadIdx.y + blockIdx.y * blockDim.y;
	

  c.r = cmin.r + dr*m;
  c.i = cmin.i + di*n;
  count[m+n] = testpoint(c);
   

}

int main(int argc, char **argv){

  // to create a 4096x4096 pixel image [ last argument is placeholder for number of threads ] 
  // usage: ./mandelbrot 4096 4096 1  
  int Nre = atoi(argv[1]);
  int Nim = atoi(argv[2]);
  int Nthreads = atoi(argv[3]);

  
   float *d_a;
  //2D Block
  int NBlocksx = Nre;
  int NBlocksy = Nim;
  int NBlocksz = 1;
  //Num Blocks
  int NGridsx = 1;
  int NGridsy = 1;
  int NGridsz = 1;
  cudaMalloc(&d_a, Nre*Nim*sizeof(float));
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
 write_hot_png(fp, Nre, Nim, count, 0, 80);
  printf("done.\n");

  free(count);

  exit(0);
  return 0;
}  
