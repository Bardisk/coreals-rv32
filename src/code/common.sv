`ifndef _COMMON
`define _COMMON

`define NOP 32'h13

`ifdef _IMPLEMENT
  `define SYS_FREQ 10000000
`endif

`ifdef _SIMULATE
  `define SYS_FREQ 100000000
`endif

`define XLEN 32
`define AMOUNT(name, value)\
  `define name``_WIDTH value\
  `define name``_SIZE (2**value)

`AMOUNT(SLAVE, 3)
`AMOUNT(MASTER, 1)

`define UNFOLD(NAME) `NAME

`AMOUNT(RIBADDR, (`XLEN-`SLAVE_WIDTH))

`define BITRANGE(name, hi, lo) name[((hi)-1):(lo)]
`define SEXT(name, hi, lo, supplement)\
  {{supplement{name[(hi)-1]}}, `BITRANGE(name, hi, lo)}
`define WIDE(xlen) [((xlen)-1):0]

`define ALWAYS_CR always_ff @(posedge clk, posedge rst)
`define ALWAYS_NCR always_ff @(negedge clk, posedge rst)

`endif
