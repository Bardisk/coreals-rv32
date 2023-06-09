`ifndef ID
`define ID
// `include "_m.sv"

module id (
  // input clk,
  // input rst,
  if_if_id.in if_if_id_id,
  if_id_ex.out if_id_ex_id,
  output wire `WIDE(`XLEN) PC_out_ID,
  output wire `WIDE(`XLEN) inst_ID,
  output wire pcg_isjalr,
  output wire `WIDE(5) reg_anum_id,
  output wire `WIDE(5) reg_bnum_id
);

  wire `WIDE(`XLEN) inst = if_if_id_id.inst;
  wire `WIDE(`XLEN) imm;
  wire `WIDE(5) reg_anum, reg_bnum, reg_wnum;
  wire `WIDE(3) ALUctr, mem_opt, branch;
  wire `WIDE(2) alu_sela, alu_selb;
  wire ALUext, mem_wr, reg_wr, mem_load, mem_signed;
  decode decode_0(.*);

  assign PC_out_ID = if_if_id_id.pc;
  assign inst_ID = if_if_id_id.inst;
  assign pcg_isjalr = (branch == `BRANCH_JALR);

  assign reg_anum_id = reg_anum;
  assign reg_bnum_id = reg_bnum;

  assign if_id_ex_id.alu_sela   = alu_sela;
  assign if_id_ex_id.alu_selb   = alu_selb;
  assign if_id_ex_id.mem_opt    = mem_opt;
  assign if_id_ex_id.mem_signed = mem_signed;
  assign if_id_ex_id.reg_wr     = reg_wr;
  assign if_id_ex_id.reg_anum   = reg_anum;
  assign if_id_ex_id.reg_bnum   = reg_bnum;
  assign if_id_ex_id.reg_wnum   = reg_wnum;
  assign if_id_ex_id.mem_load   = mem_load;
  assign if_id_ex_id.ALUctr     = ALUctr;
  assign if_id_ex_id.ALUext     = ALUext;
  assign if_id_ex_id.mem_wr     = mem_wr;
  assign if_id_ex_id.imm        = imm;
  assign if_id_ex_id.branch     = branch;
  assign if_id_ex_id.pc         = if_if_id_id.pc;

endmodule

`endif
