//
//  cpu_io-mix.c
//  minix-benchmark
//
//  Created by Jeremy Chalmer on 10/10/11.
//  Copyright 2011 Jeremy Chalmer. All rights reserved.
//
//  This program is a mix of CPU and I/O bound tasks. It calculates all
//  prime numbers less then 5,000,000 and then writes them to a file.
//  To ensure a long sample period for benchmarking, this process is
//  repeated 150 times. 

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/times.h>

#define MAX 5000000

void sieveToFile(int max, int run);


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
    
    for (i = 0; i <=100; i++)
    {
        sieveToFile(MAX, i);
    }
    
    time(&finish);
    times(&runningTime);
    
    totalTime = ((double)difftime(finish, start));
    userTime = ((double)(runningTime.tms_utime))/CLOCKS_PER_SEC;
    systemTime = ((double)(runningTime.tms_stime))/CLOCKS_PER_SEC;
    
    
    //    printf("Ran for %.3f seconds.\n", totalTime);
    //    printf("tms_utime: %.3f - tms_stime: %.3f\n", userTime,
    //           systemTime);
    
    printf("cpu_io-mix,%.0f,%.3f,%.3f\n",totalTime,userTime,systemTime);
    
    return 0;

}

void sieveToFile(int max, int run)
{
    int i,j;
    FILE *fp = 0;
    
    fp = fopen("cpu_io-mix_OUT.txt","w+");
    fprintf(fp, "RUN NUMBER %i\n",run);
    
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
    
    for (i=2; i<max; i++) 
    {
        if (!list[i]) { fprintf(fp,"%d\n", i); }
    }
    
    fclose(fp);    
}