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
