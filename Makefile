all:
	verilator --top core_als --cc -Isrc/code -Isrc/code/als --exe src/code/core_als.sv src/sim_main.cpp --prefix Vhello --trace -j 4 -sv -Wall -Wno-declfilename --build
	obj_dir/Vhello.exe > sim.log

.PHONY: all