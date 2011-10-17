## README for Minix Scheduler Benchmark Suite
This is a homework assignment (#3) for COMP410 [Fall 2011] - Operating Systems at Loyola University. 

### Introduction:
This project is a set of test programs and scripted test protocols for observing how changes to the Scheduler implementation in Minix affect performance. The suite includes three test programs:

* **cpu-bound**
  > A very simple implementation of the [Sieve of Eratosthenes][1] used to check for prime numbers between 0 and 5,000,000. While not exactly memory efficient, it does keep the CPU quite busy.

* **io-bound**  
  > Writes a million lines of clock ticks to a file on disk.
      
* **cpu_io-mix**  
  > Combines the previous two programs and writes the result of the prime number search to a file.

Each test program measures its own execution time in two ways: real time, using clock seconds, and CPU time, in clock ticks. The output of each program is a row of data in csv format:`name,realTime,userTime,systemTime` (e.g. `cpu-bound,31,21.86,0.086`).

To automate the testing procedure, two bash scripts were assembled:

* test.sh
  > This script automates the testing procedure. *It assumes the three test programs are in the same directory.* It runs the three test programs in parallel, using the `wait` command to pause until all three have finished. The test consists of 11 runs - 1 'Warm-up' run to ensure the libraries are pre-loaded, and 10 test runs. The results of each test run are assembled into a .csv file with the time, date and test name (e.g. `control-172657-111011.csv`).
  
* sched-config.sh
  > This script allows the user to modify the four variables being observed in the Minix Scheduler:
  * Number of Schedule Priority queues: `nr_sched_queues`.
  * Length of a user quantum in clock ticks: `user_quantum`.
  * Priority Penalty for using a complete quantum: `quantum_penalty`
  * Time between scheduler priority re-balancing in seconds: `balance_timeout`
  
[1]: http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

### Usage
Can be compiled under Mac OS X or Minix-3, using the included makefile. 

Minix:


	
Mac OS X:



Then run: 



Code © 2011 Jeremy Chalmer 

---

Exampe Output (Minix-3):

	bash:~#
