#include <stdlib.h>
#include <stdio.h>



int main(int x, int y){


int a = x;
int b = y;
int gcd; 

printf("Enter the first number: ");
scanf("%d", &a);
printf("Enter the second number: ");
scanf("%d", &b);

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
printf("The greatest common denominator of %d and %d is %d\n", a, b, gcd);
return gcd;
}//main
