#!/usr/pkg/bin/bash
timeDate=`date +%H%M%S-%d%m%y`
runName="test"
echo -e "Please enter the name of this test run (e.g. control):"
read runName

#  This script defines the test protocol for running the scheduler benchmarks.
#  -- Record Scheduler Variables
#  -- Perform a 'Warm Up Run'
#  -- Run the test 10 times, directing output to a separate file with a date tag
#  -- Cat three files together to create a 'report' file
#  -- Append scheduler variables to end of report file
#  -- Clean up temp files


# Record Current Scheduler variables
nr_sched_queues=`cat /usr/src/include/minix/config.h | awk 'NR == 78 {print $3}'`
user_quantum=`cat /usr/src/include/minix/config.h | awk 'NR == 86 {print $3}'`
quantum_penalty=`cat /usr/src/servers/sched/schedule.c | 
                  awk -F" " 'NR == 44 {$3=sub(/;/,""); print $3}'`
balance_timeout=`cat /usr/src/servers/sched/schedule.c | awk -F" " 'NR == 20 {print $3}'`

schedVars="$nr_sched_queues,$user_quantum,$quantum_penalty,$balance_timeout,"

# Itroduction
  echo "Scheduler Benchmark Test Suite"
  echo "Begin Time: `date +%c`"
  echo "-----------------------------------"

# Warm-up Run
  start=`date +%s`
  echo "Beginning Warm-up Run"
  ./cpu-bound &
  ./io-bound &
  ./cpu_io-mix &
  wait
  end=`date +%s`
  let "runTime=$end-$start"
  echo "Warm-up Complete in ${runTime}s."
  
  echo "-----------------------------------"

#Create the report output file
  echo "Creating Report"
  reportName="$runName-${timeDate}.csv"
  touch reportTEMP.tmp
  touch $reportName
  echo "nr_sched_queues,user_quantum,quantum_penalty,balance_timeout,program,real,user,system" >> $reportName

# Run the tests 10 times, output to temp files.
  echo "-----------------------------------"
  start=`date +%s`
  echo "Beginning Tests"
  echo "-----------------------------------"
  
  for ((i=1; i<=10; i++))
    do
      echo "Running Test $i"
      runStart=`date +%s`
      ./cpu-bound > cpu-${start}.txt &
      ./io-bound > io-${start}.txt &
      ./cpu_io-mix > mix-${start}.txt &
      wait
      runEnd=`date +%s`
      let "runTime=$runEnd-$runStart"
      echo "Test $i complete in ${runTime}s."
      cat mix-${start}.txt io-${start}.txt cpu-${start}.txt >> reportTEMP.tmp
      awk -v schedVars=$schedVars '{sub(/^/,schedVars); print}' reportTEMP.tmp >> $reportName
      rm reportTEMP.tmp
      rm *${start}.txt
      echo "======="
    done

  end=`date +%s`
  let "totalTime=$end-$start"
  echo "Test Duration ${totalTime}s."
  echo "Report $reportName created."
  echo "End Time: `date +%c`"
