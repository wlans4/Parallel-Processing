#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "functions.h"

int main (int argc, char **argv) {

	//seed value for the randomizer 
  double seed;
  
  seed = clock(); //this will make your program run differently everytime
  //seed = 0; //uncomment this and you program will behave the same everytime it's run
  
  srand48(seed);


  //begin by getting user's input
	unsigned int n;

  printf("Enter a number of bits: ");
  if (scanf("%u", &n) == 1){
    ; //getting rid of warning
    }

  else{
  printf("failed to read in integer");
   }


  //make sure the input makes sense
  if ((n<2)||(n>30)) {
  	printf("Unsupported bit size.\n");
		return 0;  	
  }

  int p;

  /* Q2.2: Use isProbablyPrime and randomXbitInt to find a random n-bit prime number */
  int counter = 0;
  //make a number and if it is probably prime 45/50 times, keep it. Else, make a new one
  for (int z = 0; z < 1000; z++){
	  p = randomXbitInt(n);
	for (int i = 0; i < 50; i++){
	  if (isProbablyPrime(p) == 1){
		  counter++;
	  }
  }
	  if (counter > 45){
		  break;
	  }
}

  printf("p = %u is probably prime.\n", p);

  /* Q3.2: Use isProbablyPrime and randomXbitInt to find a new random n-bit prime number 
     which satisfies p=2*q+1 where q is also prime */
  int q;
  counter = 0;
  int counterq = 0;
  for (int z = 0; z < 1000; z++){
	  p = randomXbitInt(n);
	  q = (p - 1) / 2;
	for (int i = 0; i < 50; i++){
	  if (isProbablyPrime(p) == 1){
		  counter++;
	  }
	  
	  if (isProbablyPrime(q) == 1){
		  counterq++;
	  }
	}
	  if (counter > 30 && counterq > 30){
		  break;
	  }
  }
	printf("p = %u is probably prime and equals 2*q + 1. q= %u and is also probably prime.\n", p, q);  

	/* Q3.3: use the fact that p=2*q+1 to quickly find a generator */
	unsigned int g = findGenerator(p);

	printf("g = %u is a generator of Z_%u \n", g, p);  

  return 0;
}
