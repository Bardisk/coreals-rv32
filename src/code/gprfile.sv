`ifndef _GPRFILE
`define _GPRFILE
`include "common.sv"

module gprfile(
  input  wire  clk,
  input  wire  rst,
  input  wire  `WIDE(5)     reg_anum,
  input  wire  `WIDE(5)     reg_bnum,
  output reg   `WIDE(`XLEN) radata,
  output reg   `WIDE(`XLEN) rbdata,
  input  wire  `WIDE(5)     reg_wnum,
  input  wire               reg_wen,
  input  wire  `WIDE(`XLEN) rwdata
);

  integer i;

  reg `WIDE(`XLEN) gprs[32];
  `ALWAYS_NCR begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1)
        gprs[i] <= '0;
    end
    else begin
      if (|reg_wnum && reg_wen) begin
        $display("write %h into %d", rwdata, reg_wnum);
        gprs[reg_wnum] <= rwdata;
      end
    end
  end

  assign radata = gprs[reg_anum];
  assign rbdata = gprs[reg_bnum];

endmodule

`endif
