`ifndef _CORE
`define _CORE
`include "common.sv"
`include "alu.sv"
`include "decode.sv"
`include "pc_reg.sv"
`include "gprfile.sv"

module core(
  input   wire                  clk,
  input   wire                  rst,
  // input   wire                  intr,
  output  wire                  MemRW,
  input   wire    `WIDE(`XLEN)  inst_in,
  input   wire    `WIDE(`XLEN)  Data_in,
  output  wire    `WIDE(`XLEN)  Addr_out,
  output  wire    `WIDE(`XLEN)  PC_out,
  output  wire    `WIDE(`XLEN)  Data_out  
);
  //IF
  reg pcg_isjalr, pcg_branch;
  
  always @(*) begin
    if (branch == `BRANCH_JALR)
      pcg_isjalr = 1'b1;
    else pcg_isjalr = 1'b0;
  end

  always @(*) begin
    case (branch)
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

  reg pc_reg_en; 
  wire `WIDE(`XLEN) pcg_offset, pcg_jalr_reg, pc_out, pc_now;

  assign PC_out = pc_reg_en ? pc_out : 32'h00000000;
  assign MemRW = mem_wr;
  assign Data_out = mem_dat_o_w;
  assign Addr_out = aluresult;

  pc_reg pc_reg_0(.*);

  //ID
  wire `WIDE(`XLEN) inst = inst_in;
  wire `WIDE(`XLEN) imm;
  wire `WIDE(5) reg_anum, reg_bnum, reg_wnum;
  wire `WIDE(3) ALUctr, mem_opt, branch;
  wire `WIDE(2) alu_sela, alu_selb;
  wire ALUext, mem_wr, reg_wr, mem_load, mem_signed;
  decode decode_0(.*);

  wire `WIDE(`XLEN) radata, rbdata;
  reg `WIDE(`XLEN) rwdata;

  wire reg_wen = reg_wr;
  gprfile gprfile_0(.*);

  assign pcg_jalr_reg = radata;
  assign pcg_offset = imm;

  //EX
  reg `WIDE(`XLEN) dataa, datab;
  always @(*) begin
    case (alu_sela)
      `ALU_A_PC:    dataa = pc_now;
      `ALU_A_ZERO:  dataa = '0;
      `ALU_A_REG:   dataa = radata;
      default:      dataa = '0;
    endcase
    case (alu_selb)
      `ALU_B_FOUR:  datab = 32'h4;
      `ALU_B_IMM:   datab = imm;
      `ALU_B_REG:   datab = rbdata;
      default:      datab = '0;
    endcase
  end
  wire less, zero;
  wire `WIDE(`XLEN) aluresult;
  alu alu_0(.*);

  //M
  wire `WIDE(`XLEN) mem_dat_o_w;
  save_sext save_sext_0(
    .current(rbdata),
    .mem_mode(mem_opt),
    .low_addr(`BITRANGE(aluresult, 2, 0)),
    .target(mem_dat_o_w)
  );

  //WB
  wire `WIDE(`XLEN) mem_dat_i_w;
  load_sext load_sext_0(
    .current(Data_in),
    .mem_mode(mem_opt),
    .low_addr(`BITRANGE(aluresult, 2, 0)),
    .mem_signed(mem_signed),
    .target(mem_dat_i_w)
  );
  always @(*) begin
    if (mem_load) begin
      rwdata = mem_dat_i_w;
    end
    else if(reg_wr) begin
      rwdata = aluresult;
    end
    else rwdata = '0;
  end


  `ALWAYS_CR begin
    if (rst) 
      pc_reg_en     <= '0;
    else pc_reg_en  <= '1;
  end

endmodule

`endif
