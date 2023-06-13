all:
	verilator --top core_als --cc -Isrc/code -Isrc/code/als --exe src/code/core_als.sv src/sim_main.cpp --prefix Vhello --trace -j 4 -sv -Wall -Wno-unused -Wno-declfilename --build
	obj_dir/Vhello.exe > sim.log

pre: src/code/core_als.sv
	iverilog -Isrc/code -Isrc/code/als -o core_als_pre.sv -E -g2012 src/code/core_als.sv

.PHONY: all pre