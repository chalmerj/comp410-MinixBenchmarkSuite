//
//  io-bound.c
//  minix-benchmark
//
//  Created by Jeremy Chalmer on 10/10/11.
//  Copyright 2011 Jeremy Chalmer. All rights reserved.
//
//  This program opens a file on disk, and writes a million lines of 
//  clock tick to it. It repeats that process 10 times.

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/times.h>

void writeFile(int count);

int main(int argc, const char* argv[])
{
    time_t start; 
    time_t finish;
    
    double userTime;
    double systemTime;
    struct tms runningTime;
    double totalTime;
    
    int i;
    
    time(&start);
    
    for (i = 0; i <=5; i++)
    {
        writeFile(1000000);
    }
    
    time(&finish);
    times(&runningTime);
    
    totalTime = ((double)difftime(finish, start));
    userTime = ((double)(runningTime.tms_utime))/CLOCKS_PER_SEC;
    systemTime = ((double)(runningTime.tms_stime))/CLOCKS_PER_SEC;
    
    
    //    printf("Ran for %.3f seconds.\n", totalTime);
    //    printf("tms_utime: %.3f - tms_stime: %.3f\n", userTime,
    //           systemTime);
    
    printf("io-bound,%.0f,%.3f,%.3f\n",totalTime,userTime,systemTime);
    
    return 0;
}

void writeFile(int count)
{
    FILE *fp = 0;
    clock_t tick;
    
    fp = fopen("io-bound_OUT.txt","w+"); 
    
    int i;
    
    for (i = 0; i <= count; i++)
    {
        tick = clock();
        fprintf(fp,"%li\n", tick); 
    }
    
    fclose(fp); 
}