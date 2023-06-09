`ifndef BYPASSER
`define BYPASSER

module bypasser(
  input wire `WIDE(5) reg_anum_id,
  input wire `WIDE(5) reg_bnum_id,
  input wire `WIDE(5) reg_anum_ex,
  input wire `WIDE(5) reg_bnum_ex,
  input wire `WIDE(5) reg_wnum_ex,
  input wire `WIDE(5) reg_wnum_m,
  input wire reg_wr_ex,
  input wire mem_load_ex,
  input wire `WIDE(`XLEN) aluresult_ex,
  input wire reg_wr_m,
  input wire mem_load_m,
  input wire `WIDE(`XLEN) mem_dat_i_w_m,
  output wire id_ex_hangon_ra,
  output wire id_ex_hangon_rb,
  output wire ex_overwrite_ra,
  output wire ex_overwrite_rb,
  output wire `WIDE(`XLEN) id_ex_over_data,
  output wire `WIDE(`XLEN) ex_over_data
);
  //general
  assign id_ex_hangon_ra = (reg_wr_ex & ~mem_load_ex) & (reg_anum_id == reg_wnum_ex);
  assign id_ex_hangon_rb = (reg_wr_ex & ~mem_load_ex) & (reg_bnum_id == reg_wnum_ex);
  //load use
  assign ex_overwrite_ra = (reg_wr_m & mem_load_m) & (reg_anum_ex == reg_wnum_m);
  assign ex_overwrite_rb = (reg_wr_m & mem_load_m) & (reg_bnum_ex == reg_wnum_m);

  //bypass data
  assign id_ex_over_data = aluresult_ex;
  assign ex_over_data = mem_dat_i_w_m; 

endmodule

`endif

