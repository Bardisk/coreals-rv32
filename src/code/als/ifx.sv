`ifndef IF
`define IF

`include "../common.sv"
`include "../pc_reg.sv"

module ifx (
  input clk,
  input rst,
  input wire `WIDE(`XLEN) inst_IF,
  if_if_id.out if_if_id_if,
  output wire `WIDE(`XLEN) PC_out_IF,
  input `WIDE(`XLEN) pcg_offset,
  input `WIDE(`XLEN) pcg_jalr_reg,
  input wire pcg_isjalr,
  input wire pcg_branch
);

  reg pc_reg_en; 
  wire `WIDE(`XLEN) pc_out, pc_now;
  
  assign PC_out_IF = pc_reg_en ? pc_out : 32'h00000000;

  assign if_if_id_if.inst = inst_IF;
  assign if_if_id_if.pc = pc_now;

  pc_reg pc_reg_0(.*);

  // assign PC_out_IF = ;

  `ALWAYS_CR begin
    if (rst) 
      pc_reg_en     <= '0;
    else pc_reg_en  <= '1;
  end

endmodule

`endif
