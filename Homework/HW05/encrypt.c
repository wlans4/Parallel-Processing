#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <time.h>

#include "functions.h"

int main (int argc, char **argv) {

	//seed value for the randomizer 
  double seed = clock(); //this will make your program run differently everytime
  //double seed = 0; //uncomment this and your program will behave the same everytime it's run

  srand(seed);

  int bufferSize = 1024;
  unsigned char *message = (unsigned char *) malloc(bufferSize*sizeof(unsigned char));

  printf("Enter a message to encrypt: ");
  int stat = scanf (" %[^\n]%*c", message); //reads in a full line from terminal, including spaces
  printf("Message = \"%s\"\n", message);
  //declare storage for an ElGamal cryptosytem
  unsigned int n, p, g, h;

  printf("Reading file.\n");

  /* Q2 Complete this function. Read in the public key data from public_key.txt,
    convert the string to elements of Z_p, encrypt them, and write the cyphertexts to 
    message.txt */
	//Read public_key file
	FILE *file = fopen("public_key.txt", "r");
	if (file == NULL){
		printf("ERROR: public_key.txt does not exist\n");
		return -1;
	}  
	fscanf(file, "%u\n %u\n %u\n %u\n", &n, &p, &g, &h);
	printf("Reading in public key\n");
	printf("n is %d\n", n);
	printf("p is %d\n", p);	
	printf("g is %d\n", g);
	printf("h is %d\n", h);
	unsigned int charsPerInt = (n - 1)/8;
	printf("Padding String with spaces...\n");
	printf("Done\n");
	printf("length of message: %d\n", strlen(message));
	printf("charsPerInt: %d\n", charsPerInt);	

	padString(message, charsPerInt);
	unsigned int Nchars = strlen(message);
	unsigned int Nints = strlen(message)/charsPerInt;	
	printf("Nints is %d\n", Nints);
	printf("Nchars is %d\n", Nchars);

	unsigned int *Zmessage = (unsigned int*) malloc(Nints*sizeof(unsigned int));
	unsigned int *a = (unsigned int*) malloc(Nints*sizeof(unsigned int));


	printf("Converting message to Integer...\n");
	convertStringToZ(message, Nchars, Zmessage, Nints);
	printf("Done\n");

	printf("Performing El Gamal Encryption...\n");
	ElGamalEncrypt(Zmessage, a, Nints, p, g, h);
	printf("Done\n");

	FILE *out = fopen("message.txt", "w");
	printf("Printing to message.txt\n");
	fprintf(out, "%u\n", Nints);
	for (int i = 0; i < Nints; i++){
		fprintf(out, "%u %u\n", Zmessage[i], a[i]); 
	}

  return 0;
}
