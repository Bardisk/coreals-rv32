//unisys internal bus interface
`ifndef _UIBI
`define _UIBI

`include "common.sv"

//bus_mode:
//111: all bytes
//011: half bytes
//001: one fourth bytes

`define UIBI_MASTER\
  input   wire  `WIDE(`XLEN)                bus_dat_i,\
  output  wire  `WIDE(`XLEN)                bus_dat_o,\
  output  wire  `WIDE(`XLEN-`SLAVE_WIDTH)   bus_addr,\
  output  wire  `WIDE(`SLAVE_WIDTH)         bus_num,\
  output  wire                              bus_req,\
  output  wire                              bus_wen,\
  output  wire  `WIDE(3)                    bus_mode,\
  input   wire                              bus_ready\

`define UIBI_SLAVE\
  input   wire  `WIDE(`XLEN)                bus_dat_i,\
  output  wire  `WIDE(`XLEN)                bus_dat_o,\
  input   wire  `WIDE(`XLEN - `SLAVE_WIDTH) bus_addr,\
  input   wire                              bus_req,\
  input   wire                              bus_wen,\
  input   wire  `WIDE(3)                    bus_mode,\
  output  wire                              bus_ready\

`define STDMASTER(NAME)\
  .bus_dat_i(master_dat_o[`UNFOLD(NAME``_NO)]),\
  .bus_dat_o(master_dat_i[`UNFOLD(NAME``_NO)]),\
  .bus_addr(master_addr[`UNFOLD(NAME``_NO)]),\
  .bus_num(master_num[`UNFOLD(NAME``_NO)]),\
  .bus_req(master_req[`UNFOLD(NAME``_NO)]),\
  .bus_wen(master_wen[`UNFOLD(NAME``_NO)]),\
  .bus_mode(master_mode[`UNFOLD(NAME``_NO)]),\
  .bus_ready(master_ready[`UNFOLD(NAME``_NO)])

`define STDSLAVE(NAME)\
  .bus_dat_i(slave_dat_o[`UNFOLD(NAME``_NO)]),\
  .bus_dat_o(slave_dat_i[`UNFOLD(NAME``_NO)]),\
  .bus_addr(slave_addr[`UNFOLD(NAME``_NO)]),\
  .bus_req(slave_req[`UNFOLD(NAME``_NO)]),\
  .bus_wen(slave_wen[`UNFOLD(NAME``_NO)]),\
  .bus_mode(slave_mode[`UNFOLD(NAME``_NO)]),\
  .bus_ready(slave_ready[`UNFOLD(NAME``_NO)])

//bus modes
`define BUS_FULL  3'b111
`define BUS_HALF  3'b011
`define BUS_QUAR  3'b001
`define BUS_NULL  3'b000

module mode_convertor(
  input wire `WIDE(3) bus_mode,
  input wire `WIDE(2) bus_addr,
  output wire `WIDE(`XLEN/8) rl_mode
);

  wire `WIDE(`XLEN/8) tr_mode;
  assign `BITRANGE(tr_mode, (`XLEN/8),  (`XLEN/16)) = {(`XLEN/16){bus_mode[2]}};
  assign `BITRANGE(tr_mode, (`XLEN/16), (`XLEN/32)) = {(`XLEN/32){bus_mode[1]}};
  assign `BITRANGE(tr_mode, (`XLEN/32), 0)          = {(`XLEN/32){bus_mode[0]}};

  assign rl_mode = tr_mode << ((bus_addr[1] ? (`XLEN/16) : 0) + (bus_addr[0] ? (`XLEN/32) : 0));

endmodule

`define CONVERT_BUS_MODE\
  wire `WIDE(`XLEN/8) rl_mode;\
  mode_convertor convertor_0(bus_mode, `BITRANGE(bus_addr, 2, 0), rl_mode);


`define PROXY_BUS_DATA\
  reg `WIDE(`XLEN) bus_dat_o_r;\
  genvar gi;\
  generate\
    for (gi = 0; gi < 4; gi = gi + 1)\
      assign `BITRANGE(bus_dat_o, (gi+1)*(`XLEN/4), gi*(`XLEN/4)) = rl_mode[gi] ? `BITRANGE(bus_dat_o_r, (gi+1)*(`XLEN/4), gi*(`XLEN/4)) : {(`XLEN/4){1'b0}};\
  endgenerate

//to use this you should have an integer i in the context
`define RECEIVE_BUS_DATA(name)\
  begin\
    if (rl_mode[0])\
      `BITRANGE(name, 1*(`XLEN/4), 0*(`XLEN/4)) <= `BITRANGE(bus_dat_i, 1*(`XLEN/4), 0*(`XLEN/4));\
    if (rl_mode[1])\
      `BITRANGE(name, 2*(`XLEN/4), 1*(`XLEN/4)) <= `BITRANGE(bus_dat_i, 2*(`XLEN/4), 1*(`XLEN/4));\
    if (rl_mode[2])\
      `BITRANGE(name, 3*(`XLEN/4), 2*(`XLEN/4)) <= `BITRANGE(bus_dat_i, 3*(`XLEN/4), 2*(`XLEN/4));\
    if (rl_mode[3])\
      `BITRANGE(name, 4*(`XLEN/4), 3*(`XLEN/4)) <= `BITRANGE(bus_dat_i, 4*(`XLEN/4), 3*(`XLEN/4));\
  end

`endif
