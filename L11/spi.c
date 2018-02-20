#include <stdio.h>
#include <stdlib.h>
#include <math.h>

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

  double localpi = Ncircle/ (double) Ntotal;
  float float worldpisum +=localpi;
  MPI_Reduce(&localpi, &worldpisum, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);



  MPI_Finalize();
  return 0;
}
