`ifndef M
`define M

`include "ex_m.sv"
`include "../decode.sv"

module m (
  // input clk,
  // input rst,
  if_ex_m.in if_ex_m_m,
  if_m_wb.out if_m_wb_m,
  input  wire `WIDE(`XLEN) Data_in,
  output wire `WIDE(`XLEN) Data_out,
  output reg  `WIDE(`XLEN) Addr_out,
  output wire `WIDE(5) reg_wnum_m,
  output wire reg_wr_m,
  output wire mem_load_m,
  output wire `WIDE(`XLEN) mem_dat_i_w_m,
  output wire MemRW_Mem
);

  assign mem_load_m = if_ex_m_m.mem_load;
  assign reg_wr_m = if_ex_m_m.reg_wr;
  assign reg_wnum_m = if_ex_m_m.reg_wnum;
  assign mem_dat_i_w_m = if_m_wb_m.mem_dat_i_w;

  assign MemRW_Mem = if_ex_m_m.mem_wr;
  // assign

  always @(*) begin
    if (if_ex_m_m.mem_load || if_ex_m_m.mem_wr) begin
      Addr_out = if_ex_m_m.aluresult;
    end
    else Addr_out = '0;
  end

  save_sext save_sext_0(
    .current(if_ex_m_m.rbdata),
    .mem_mode(if_ex_m_m.mem_opt),
    .low_addr(`BITRANGE(if_ex_m_m.aluresult, 2, 0)),
    .target(Data_out)
  );

  load_sext load_sext_0(
    .current(Data_in),
    .mem_mode(if_ex_m_m.mem_opt),
    .low_addr(`BITRANGE(if_ex_m_m.aluresult, 2, 0)),
    .mem_signed(if_ex_m_m.mem_signed),
    .target(if_m_wb_m.mem_dat_i_w)
  );

  assign if_m_wb_m.aluresult = if_ex_m_m.aluresult;
  assign if_m_wb_m.Data_out = Data_out;
  assign if_m_wb_m.reg_wr = if_ex_m_m.reg_wr;
  assign if_m_wb_m.reg_wnum = if_ex_m_m.reg_wnum;
  assign if_m_wb_m.mem_load = if_ex_m_m.mem_load;

endmodule

`endif
