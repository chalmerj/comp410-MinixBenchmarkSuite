usage:
	@echo "" 
	@echo "Makefile for Minix Scheduler Benchmark Suite." 
	@echo "" 
	@echo "Usage:" 
	@echo " make all	# Compile everything"
	@echo " make cpu	# Compile the CPU test program"
	@echo " make io	# Compile the IO test program"
	@echo " make mix	# Compile the CPU/IO mix test program"
	@echo " make clean	# Remove the compiled programs and temp output files"
	@echo ""

all:
	gcc cpu_io-mix.c -o cpu_io-mix
	gcc cpu-bound.c -o cpu-bound
	gcc io-bound.c -o io-bound
cpu:
	gcc cpu-bound.c -o cpu-bound
io:
	gcc io-bound.c -o io-bound
mix:
	gcc cpu_io-mix.c -o cpu_io-mix
clean:
	rm -rf cpu_io-mix cpu-bound io-bound *.txt
