#include <stdio.h>
#include <stdlib.h>
int gcd();


void main() { 

int a;
int b;

    printf("Enter the first number: ");
    scanf("%d", &a);
    printf("Enter the second number: ");
    scanf("%d", &b);

    if (gcd(a,b) == 1){
        printf("%d and %d are coprime\n", a, b);
    }

    if (gcd(a,b) != 1) {
        printf("%d and %d are not coprime\n", a, b);
    }
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

