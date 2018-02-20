#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mpi.h"

int main(int argc, char **argv) {


    MPI_Init(&argc, &argv);
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int sourceRank = rank -1;
    if (rank == 0) sourceRank = size -1;
    int N = 1;
    
    //need running tallies
    long long int Ntotal;
    long long int Ncircle;

    //seed random number generator
    double seed = 1.0;
    srand48(rank);

  for (long long int n=0; n<10000;n++) {
    //gererate two random numbers
    double rand1 = drand48(); //drand48 returns a number between 0 and 1
    double rand2 = drand48();
    
    double x = -.5 + 2*rand1; //shift to [-1,1]
    double y = -.5 + 2*rand2;

    //check if its in the circle
    if (sqrt(x*x+y*y)<=.5) Ncircle++;
    Ntotal++;
  }

 MPI_Reduce(&Ntotal, &Ncircle, rank, MPI_FLOAT, MPI_SUM,0, MPI_COMM_WORLD);
  
   if (rank % 100 == 0){
         float pi = (float) Ncircle/(Ntotal*size);
         printf("Pi is equal to:%f", pi);
    }

  
  MPI_Finalize();
  return 0;
}
