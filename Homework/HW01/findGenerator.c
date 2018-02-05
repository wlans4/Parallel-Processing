#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int gcd();

int  main(){

int a;



printf("Enter a prime number: ");
scanf("%d", &a);


    for (int i = 1; i < a; i++){
        int truth = 1;
        for (int z = 1; z < a - 1; z++){
            if (((int)pow(i, z) % a) == 1){
                truth = 0; 
            }
    } //for z

    if (truth == 1){
        printf("%d is a generator of z_%d\n", i, a);
        break;   
    }
  }//for i
}





