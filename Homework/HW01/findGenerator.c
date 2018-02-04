#include <stdio.h>
#include <stdlib.h>



int gcd();

int  main(){

int a;



printf("Enter a prime number: ");
scanf("%d", &a);


    for (int i = 2; i < a; i++){
        if (gcd(i,a) == 1){
            printf("%d is a generator of Z_%d\n", i, a);
        }   
    }//for i
}//main




int gcd(int x, int y){

    int a = x;
    int b = y;
    int gcd;

    if (b == 0){
    printf("The GCD of %d and %d is %d", a, b, a);
        }

    else {
        for (int i = 1; i <= a && i <= b; i++){
            if (a%i == 0 && b%i == 0){
                gcd = i;
                     }//if mod   
            }//for i
        } //else 
return gcd;
}//method

