`ifndef EX
`define EX

`include "ex_m.sv"
`include "../alu.sv"

module ex (
  input clk,
  input rst,
  input wire id_ex_hangon_ra,
  input wire id_ex_hangon_rb,
  input wire ex_overwrite_ra,
  input wire ex_overwrite_rb,
  input wire `WIDE(`XLEN) id_ex_over_data,
  input wire `WIDE(`XLEN) ex_over_data,
  if_id_ex.in if_id_ex_ex,
  if_ex_m.out if_ex_m_ex,
  input wire `WIDE(`XLEN) radata,
  input wire `WIDE(`XLEN) rbdata,
  output wire `WIDE(5) reg_anum,
  output wire `WIDE(5) reg_bnum,
  output wire `WIDE(5) reg_wnum_ex,
  output wire `WIDE(`XLEN) PC_out_EX,
  output wire `WIDE(`XLEN) pcg_jalr_reg,
  output wire `WIDE(`XLEN) pcg_offset,
  output wire MemRW_EX,
  output reg  pcg_branch,
  output wire reg_wr_ex,
  output wire mem_load_ex,
  output wire `WIDE(`XLEN) aluresult_ex
);

  wire `WIDE(`XLEN) radata_wrapper, rbdata_wrapper;
  reg hangon_ra, hangon_rb;
  reg `WIDE(`XLEN) hangon_data;
  `ALWAYS_CR if (rst) begin
    hangon_ra <= '0;
    hangon_rb <= '0;
    hangon_data <= '0;
  end else begin
    hangon_ra <= id_ex_hangon_ra;
    hangon_rb <= id_ex_hangon_rb;
    hangon_data <= id_ex_over_data;
  end

  assign radata_wrapper = ex_overwrite_ra ? ex_over_data : (hangon_ra ? hangon_data : radata);
  assign rbdata_wrapper = ex_overwrite_rb ? ex_over_data : (hangon_rb ? hangon_data : rbdata);

  assign PC_out_EX = if_id_ex_ex.pc;
  assign MemRW_EX = if_id_ex_ex.mem_wr;

  assign reg_anum = if_id_ex_ex.reg_anum;
  assign reg_bnum = if_id_ex_ex.reg_bnum;

  assign pcg_offset = if_id_ex_ex.imm;
  assign pcg_jalr_reg = radata_wrapper;

  wire `WIDE(`XLEN) aluresult;
  wire zero, less;

  reg `WIDE(`XLEN) dataa, datab;
  always @(*) begin
    case (if_id_ex_ex.alu_sela)
      `ALU_A_PC:    dataa = if_id_ex_ex.pc;
      `ALU_A_ZERO:  dataa = '0;
      `ALU_A_REG:   dataa = radata_wrapper;
      default:      dataa = '0;
    endcase
    case (if_id_ex_ex.alu_selb)
      `ALU_B_FOUR:  datab = 32'h4;
      `ALU_B_IMM:   datab = if_id_ex_ex.imm;
      `ALU_B_REG:   datab = rbdata_wrapper;
      default:      datab = '0;
    endcase
  end

  always @(*) begin
    case (if_id_ex_ex.branch)
      `BRANCH_JAL, `BRANCH_JALR:
        pcg_branch = 1'b1;
      `BRANCH_BEQ:
        pcg_branch = zero;
      `BRANCH_BNE:
        pcg_branch = ~zero;
      `BRANCH_BLT:
        pcg_branch = less;
      `BRANCH_BGE:
        pcg_branch = ~less;
      default: pcg_branch = 1'b0;
    endcase
  end

  wire `WIDE(3) ALUctr = if_id_ex_ex.ALUctr;
  wire ALUext = if_id_ex_ex.ALUext;

  alu alu_0 (.*);

  assign reg_wnum_ex = if_id_ex_ex.reg_wnum;
  assign mem_load_ex = if_id_ex_ex.mem_load;
  assign reg_wr_ex = if_id_ex_ex.reg_wr;
  assign aluresult_ex = aluresult;

  assign if_ex_m_ex.aluresult = aluresult;
  assign if_ex_m_ex.mem_opt = if_id_ex_ex.mem_opt;
  assign if_ex_m_ex.mem_signed = if_id_ex_ex.mem_signed;
  assign if_ex_m_ex.reg_wr = if_id_ex_ex.reg_wr;
  assign if_ex_m_ex.reg_wnum = if_id_ex_ex.reg_wnum;
  assign if_ex_m_ex.mem_load = if_id_ex_ex.mem_load;
  assign if_ex_m_ex.rbdata = rbdata;
  assign if_ex_m_ex.mem_wr = if_id_ex_ex.mem_wr;

endmodule

`endif
