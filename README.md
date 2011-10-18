# README for Minix Scheduler Benchmark Suite
This is a homework assignment (#3) for COMP410 [Fall 2011] - Operating Systems at Loyola University. 

**Use at your own risk. No warranty is expressed or implied.**

## Introduction:
This project is a set of test programs and scripted test protocols for observing how changes to the Scheduler implementation in Minix affect performance. The suite includes three test programs:

* **cpu-bound**  
  A very simple implementation of the [Sieve of Eratosthenes][1] used to check for prime numbers between 0 and 5,000,000. While not exactly memory efficient, it does keep the CPU quite busy.

* **io-bound**  
  Writes a million lines of clock ticks to a file on disk.
      
* **cpu_io-mix**  
  Combines the previous two programs and writes the result of the prime number search to a file.

Each test program measures its own execution time in two ways: real time, using clock seconds, and CPU time, in clock ticks. The output of each program is a row of data in csv format:`name,realTime,userTime,systemTime` (e.g. `cpu-bound,31,21.86,0.086`).

To automate the testing procedure, two bash scripts were assembled:

* **test.sh**  
  This script automates the testing procedure. *It assumes the three test programs are in the same directory.* It runs the three test programs in parallel, using the `wait` command to pause until all three have finished. The test consists of 11 runs - 1 'Warm-up' run to ensure the libraries are pre-loaded, and 10 test runs. The results of each test run are assembled into a .csv file with the time, date and test name (e.g. `control-172657-111011.csv`).
  
* **sched-config.sh**  
  This script allows the user to modify the four variables being observed in the Minix Scheduler:
  *  `nr_sched_queues` - Number of Schedule Priority queues.
  * `user_quantum` - Length of a user quantum in clock ticks.
  * `quantum_penalty` - Priority Penalty for using a complete quantum.
  * `balance_timeout` - Time between scheduler priority re-balancing in seconds.
  
By adjusting the scheduler variables and running the benchmark tests, the user can determine if there are changes in performance for each type of program task. You can choose from test condition settings, or input custom values. **<font color=red>NOTE!** There is no value bounds checking in the scheduler configuration script. </font>
  
[1]: http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
<br />

----

## Usage
1. Clone the git repository to a directory on your Minix-3 system (virtual or otherwise).
2. Use the included make file to compile the benchmark programs: `bash:~# make`.
3. Run the sched config script: `bash:~# ./sched-config.sh`. ([See below](#sched-config))
4. Choose a preset scheduler setting or input your own.
5. If you change the scheduler settings, the `sched-config` script will prompt you to recompile the Minix kernel when you quit the script. Choose y or n to automate the recompile step. ( Or [manually recompile](#recompile-minix))
6. When the new custom kernel is created, run `shutdown` to reboot the Minix system.
7. At the boot menu, press the `2` key to boot the custom kernel.
8. `cd` back to the benchmark directory
9. Run ./test.sh ([See Below](#test.sh))
10. At the prompt, enter then name of the test run. The name should reflect the variables being tested, and is provided your benefit to keep track of test report files. (e.g. `MAX_nr_sched_queues`)
11. Let the test run complete. (Time will depend on the power of your system)
12. The test program will create a `.csv` file (e.g. `MAX_nr_sched_queues-172657-111011.csv`) with the name of the test run, time and date. Save this file somewhere off the Minix system for further review.
13. Rinse and repeat.

Repeating the tests with different scheduler variables is easily accomplished by creating snapshots of the Minix system in your virtual machine manager of choice. The snapshot method ensures that any changes to the system that render it unbootable will not destroy the system as a whole.

---


### Benchmark Programs
The benchmark programs consist of one '.c' file each, and can be compiled using the basic `gcc` package found on Minix-3. There are no compiler flags necessary for the build process.

#### Using the included `makefile`:
Output of `make usage`:  

	make all	# Compile everything  
	make cpu	# Compile the CPU test program  
	make io		# Compile the IO test program  
	make mix	# Compile the CPU/IO mix test program  
	make clean	# Remove the compiled programs and temp output files  


### Test Scripts

#### Using `test.sh` <a id="test.sh">
`test.sh` is straightforward - running the script will prompt you for a test name, and then run through the test cycle. The test cycle consists of one warm-up run and 10 test run cycles of each benchmark program.
##### Stoppping `test.sh`:
If you need to interrupt the test cycle, press `ctrl-c` on the keyboard and `test.sh` will shutdown the processes and remove the test files.

##### Example Output:

	root:~/schedule-bench #./test.sh 
	Please enter the name of this test run (e.g. control): MAX_nr_sched_queues
	Scheduler Benchmark Test Suite
	Begin Time: Mon Oct 17 13:53:27 2011
	-----------------------------------
	Warm-up Running
	io-bound,62,17.467,17.717
	cpu-bound,63,22.783,0.683
	cpu_io-mix,85,20.650,2.367
	Warm-up Complete in 85s.
	-----------------------------------
	Initializing Report
	-----------------------------------
	Beginning Tests
	-----------------------------------
	Running Test 1
	...

#### Using `sched-config.sh` <a id="sched-config">
The scheduler config script helps to automate the changes to the Minix scheduler algorithm by modifying two files: 

* `/usr/src/include/minix/config.h`
* `/usr/src/servers/sched/schedule.c`

The script was designed with the following test protocol in mind: 

1. Test the default scheduler variables.
2. Lower all the variables to their acceptable minimum.
3. Raise each variable one at a time to its acceptable maximum, leaving the others at minimum.

This test protocol will result in 6 test reports, each containing the output from 10 test cycles. The complete test results set will have 540 data points in total, for further review.

##### Running `sched-config.sh`
When run, the schedule parameter configuration switcher will present you with the current configuration values as gathered from the existing source files, and a numeric menu for inserting new values. Each menu item indicates the parameter it will change, and the value it will change to. 

	root:~/schedule-bench #./sched-config.sh 
	-----------------------------------
	Scheduler Parameter Config Switcher
	-----------------------------------
	Current Configuration Values:
		tnr_sched_queues: 16
		    user_quantum: 200
		 quantum_penalty: 1
		 balance_timeout: 5
	-----------------------------------
	1) Set default values [16,200,1,5]  5) Set max quantum_penalty [2]
	2) Set min values [6,25,1,1]	    6) Set max balance_timeout [20]
	3) Set max nr_sched_queues [64]	    7) Enter Custom Values
	4) Set max user_quantum [1500]	    8) Quit
	Select Config #:

If you select a number, the script will insert those values into the source files and return the new values. When making a modification to the source files, the script backs up the existing file in place, with the extention `.BAK`.

	Select Config #: 2
	Setting Minimum Values
	-----------------------------------
	Setting New Values
	------
	Backing up config.h to config.h.BAK
	Setting NR_SCHED_QUEUES to 6
	Setting USER_QUANTUM to 25
	------
	Backing up schedule.c to schedule.c.BAK
	Setting QUANTUM_PENALTY to 1
	Setting BALANCE_TIMEOUT to 1
	-----------------------------------
	Current Configuration Values:
		tnr_sched_queues: 6
		    user_quantum: 25
		 quantum_penalty: 1
		 balance_timeout: 1
	-----------------------------------

Once the values have been inserted, the next step is usually to quit the script (option #8). On quit, the script will check if changes have been made, and prompt for automatic re-compilation of the Minix kernel.

	Select Config #: 8
	-----------------------------------
	Changes made to source files. Recompile Kernel [y/N]? 
	-->

If you type `y` or `yes`, the script will automatically launch the `make world` command in `/usr/src/` - triggering a recompilation of the Minix kernel. If you enter `n` or nothing, the script simply quits - the modified values remain in place.

##### Using custom scheduler values
If you wish to define custom values for the scheduler algorithm, select option #7 at the menu prompt. This will then prompt you for the 4 scheduler variables in question.

	Select Config #: 7
	-----------------------------------
	Enter Custom Values
	-----
	Enter nr_sched_queues: 16
	Enter user_quantum: 200
	Enter quantum_penalty: 1
	Enter balance_timeout: 5
	-----------------------------------
	Setting New Values
	------
	Backing up config.h to config.h.BAK
	Setting NR_SCHED_QUEUES to 16
	Setting USER_QUANTUM to 200
	------
	Backing up schedule.c to schedule.c.BAK
	Setting QUANTUM_PENALTY to 1
	Setting BALANCE_TIMEOUT to 5
	-----------------------------------
	Current Configuration Values:
		tnr_sched_queues: 16
		    user_quantum: 200
		 quantum_penalty: 1
		 balance_timeout: 5
	-----------------------------------

**Please Note:** There is **NO** type or value checking on the custom input entries. If you enter something other then an integer, the script will happily insert it into the source file - and proceed to stop working (it checks for specific fields in the file, and will fail if they aren't found). This is why `.BAK` files are made before writing any changes.



#### Manually recompiling the Minix kernel <a id="recompile-minix">:
> 1.	Shutdown your Minix system. In your virtualization solution, create a snapshot of your Minix 3 VM just in case you make a mistake that causes the system to not be runnable.
2.	Make sure the output of the command `echo $PATH` is the following: `/root/bin:/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/pkg/bin:/usr/pkg/sbin:/usr/pkg/X11 R6/bin`
3.	`cd` to `/usr/src `
4.	Type `make world`. Wait about 3-5 minutes. 
5.	After saving your work, shutdown the system with the `shutdown` command. 
6.	Start the VM. At the boot menu, press the ‘2’ key to boot the custom micro kernel.


Code © 2011 Jeremy Chalmer 

---

