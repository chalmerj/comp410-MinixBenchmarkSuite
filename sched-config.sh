#!/usr/pkg/bin/bash
# 
# This script automates the process of changing the scheduler configuration valus in the Minix
# source. It does create a backup of the files first (.BAK), but could still be dangerous.
# Use with caution, or copious backups in place.

################# Function Definitions ######################
getVals()
{
	nr_sched_queues=`cat /usr/src/include/minix/config.h | awk 'NR == 78 {print $3}'`
	user_quantum=`cat /usr/src/include/minix/config.h | awk 'NR == 86 {print $3}'`
	quantum_penalty=`cat /usr/src/servers/sched/schedule.c | 
	                  awk -F" " 'NR == 44 {$3=sub(/;/,""); print $3}'`
	balance_timeout=`cat /usr/src/servers/sched/schedule.c | awk -F" " 'NR == 20 {print $3}'`
}

setVals()
{
	echo "-----------------------------------"
	echo "Setting New Values"
	echo "------"
	
	changesMade=1
	
	echo "Backing up config.h to config.h.BAK"
	cd /usr/src/include/minix/
	cp config.h config.h.BAK
	echo "Setting NR_SCHED_QUEUES to $1"
	sed -e '78s/[0-9]\{1,\}/'$1'/ ' config.h > config.h.NEW
	echo "Setting USER_QUANTUM to $2"
	sed -e '86s/[0-9]\{1,\}/'$2'/ ' config.h.NEW > config.h
	rm config.h.NEW
	echo "------"
	
	echo "Backing up schedule.c to schedule.c.BAK"
	cd /usr/src/servers/sched/
	cp schedule.c schedule.c.BAK
	echo "Setting QUANTUM_PENALTY to $3"
	sed -e '44s/[0-9]\{1,\}/'$3'/ ' schedule.c > schedule.c.NEW
	echo "Setting BALANCE_TIMEOUT to $4"
	sed -e '20s/[0-9]\{1,\}/'$4'/ ' schedule.c.NEW > schedule.c
	rm schedule.c.NEW
}

printVals()
{
	echo "-----------------------------------"
	echo "Current Configuration Values:"
cat << VALUES
	tnr_sched_queues: $nr_sched_queues
	    user_quantum: $user_quantum
	 quantum_penalty: $quantum_penalty
	 balance_timeout: $balance_timeout
VALUES
	echo "-----------------------------------"
}

askRecompile()
{
	echo "-----------------------------------"
	echo "Changes made to source files. Recompile Kernel [y/N]? "
	read -p "--> " answer
	if [ answer == "y" ]; then
		/usr/src/make world &
	fi
}


################# Display Menu of Options ######################

echo "-----------------------------------"
echo "Scheduler Parameter Config Switcher"
changesMade=0
getVals
printVals
 
PS3="Select Config #: "
declare -a options

options[${#options[*]}]="Set default values [16,200,1,5]";
options[${#options[*]}]="Set min values [6,25,1,1]";
options[${#options[*]}]="Set max nr_sched_queues [64]";
options[${#options[*]}]="Set max user_quantum [1500]";
options[${#options[*]}]="Set max quantum_penalty [2]";
options[${#options[*]}]="Set max balance_timeout [20]";
options[${#options[*]}]="Enter Custom Values";
options[${#options[*]}]="Quit";

select opt in "${options[@]}"; 
do
  case $REPLY in
	1) 
		echo "Setting Default Values";
		setVals 16 200 1 5;
		getVals;
		printVals;
		;;
	2)
		echo "Setting Minimum Values";
		setVals 6 25 1 1;
		getVals;
		printVals;
		;;
	3)
		echo "Set max nr_sched_queues [64]";
		setVals 64 25 1 1;
		getVals;
		printVals;
		;;
	4)
		echo "Set max user_quantum [1500]";
		setVals 6 1500 1 1;
		getVals;
		printVals;
		;;
	5)
		echo "Set max quantum_penalty [2]";
		setVals 6 25 2 1;
		getVals;
		printVals;
		;;
	6)
		echo "Set max balance_timeout [20]";
		setVals 6 25 1 20;
		getVals;
		printVals;
		;;
	7)
		echo "-----------------------------------"
		echo "Enter Custom Values";
		echo "-----"
		echo -n "Enter nr_sched_queues: "; read c1;
		echo -n "Enter user_quantum: "; read c2;
		echo -n "Enter quantum_penalty: "; read c3;
		echo -n "Enter balance_timeout: "; read c4;
		setVals $c1 $c2 $c3 $c4;
		getVals;
		printVals;
		;;
	8) 
		if [ $changesMade -gt 0 ]; then
			askRecompile
		fi
		echo "Done";	
		break 
		;;
	*)
	echo "${opt}";
	esac;
done

