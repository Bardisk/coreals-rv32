`include "als/if_id.sv"
`include "als/id_ex.sv"
`include "als/ex_m.sv"
`include "als/m_wb.sv"

`include "gprfile.sv"

`include "als/ifx.sv"
`include "als/id.sv"
`include "als/ex.sv"
`include "als/m.sv"
`include "als/wb.sv"

`include "als/staller.sv"
`include "als/bypasser.sv"

`include "common.sv"

module core_als(
  input wire clk,
  input wire rst,
  // input wire intr,
  output  wire                  MemRW_Mem,
  output  wire                  MemRW_EX,
  input   wire    `WIDE(`XLEN)  inst_IF,
  output  wire    `WIDE(`XLEN)  inst_ID,
  input   wire    `WIDE(`XLEN)  Data_in,
  output  wire    `WIDE(`XLEN)  Addr_out,
  output  wire    `WIDE(`XLEN)  PC_out_IF,
  output  wire    `WIDE(`XLEN)  PC_out_ID,
  output  wire    `WIDE(`XLEN)  PC_out_EX,
  output  wire    `WIDE(`XLEN)  Data_out,
  output  wire    `WIDE(`XLEN)  Data_out_WB  
);

  //stall
  wire if_id_stalled, id_ex_stalled;

  //pcg
  wire pcg_branch, pcg_isjalr;
  wire `WIDE(`XLEN) pcg_offset, pcg_jalr_reg;

  //gpr
  wire `WIDE(`XLEN) radata, rbdata, rwdata;
  wire reg_wen;
  wire `WIDE(5) reg_anum, reg_bnum, reg_wnum;

  //bypasser
  wire id_ex_hangon_ra, id_ex_hangon_rb, ex_overwrite_ra, ex_overwrite_rb;
  wire `WIDE(`XLEN) id_ex_over_data, ex_over_data;
  wire `WIDE(5) reg_anum_id, reg_anum_ex, reg_bnum_id, reg_bnum_ex, reg_wnum_ex, reg_wnum_m;
  wire reg_wr_ex, reg_wr_m, mem_load_ex, mem_load_m;
  wire `WIDE(`XLEN) aluresult_ex, mem_dat_i_w_m;

  assign reg_anum_ex = reg_anum;
  assign reg_bnum_ex = reg_bnum;

  if_m_wb if_m_wb_m();
  if_m_wb if_m_wb_wb();

  if_ex_m if_ex_m_ex();
  if_ex_m if_ex_m_m();
  
  if_id_ex if_id_ex_id();
  if_id_ex if_id_ex_ex();

  if_if_id if_if_id_if();
  if_if_id if_if_id_id();

  m_wb m_wb_0(.*);
  ex_m ex_m_0(.*);
  id_ex id_ex_0(.*);
  if_id if_id_0(.*);

  wb wb_0(.*);
  m m_0(.*);
  ex ex_0(.*);
  id id_0(.*);
  ifx ifx_0(.*);

  gprfile gprfile_0(.*);

  bypasser bypasser_0(.*);
  staller staller_0(.*);


endmodule

