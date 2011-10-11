//
//  cpu-bound.c
//  minix-benchmark
//
//  Created by Jeremy Chalmer on 10/10/11.
//  Copyright 2011 Jeremy Chalmer. All rights reserved.
//
//  This program uses the Sieve of Eratosthenes to calculate prime numbers
//  up to the 'MAX' define (5,000,000). It then loops that function a number
//  of times to generate a CPU intensive process. 

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/times.h>

#define MAX 5000000

void sieve(int max);


int main (int argc, const char * argv[])
{
    time_t start; 
    time_t finish;
    
    double userTime;
    double systemTime;
    struct tms runningTime;
    double totalTime;
    
    int i;
    
    time(&start);
    
    for (i = 0; i <=250; i++)
    {
        sieve(MAX);
    }
    
    time(&finish);
    times(&runningTime);
    
    totalTime = ((double)difftime(finish, start));
    userTime = ((double)(runningTime.tms_utime))/CLOCKS_PER_SEC;
    systemTime = ((double)(runningTime.tms_stime))/CLOCKS_PER_SEC;
    
    
    //    printf("Ran for %.3f seconds.\n", totalTime);
    //    printf("tms_utime: %.3f - tms_stime: %.3f\n", userTime,
    //           systemTime);
    
    printf("cpu-bound,%.0f,%.3f,%.3f\n",totalTime,userTime,systemTime);
    
    return 0;
}



void sieve(int max)
{
    int i,j;
    
    char list[max];
    
    for (i=2; i*i <= max; i++) 
    {
        if (!list[i]) 
        {
            for(j = i+i; j < max; j+=i) 
            { 
                list[j] = 1; 
            }

        }
    }
}
