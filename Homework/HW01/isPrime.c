#include <stdio.h>
#include <stdlib.h>


int main() {

int a;
int half;
int isPrime = 1;
printf("Enter a number: ");
scanf("%d", &a);
half = a/2 + 1;



    if (a <= 0){
        printf("%d is not a prime number", a);\
        return 0;
    }

    for (int i = 2; i < half; i++){

    if (a % i == 0){
        isPrime = 0;
        }
    }//for i


    if (isPrime == 1){
    printf("%d is a prime number", a);
    }
    else if (isPrime == 0){
    printf("%d is not a prime number", a);
    }
}//main




