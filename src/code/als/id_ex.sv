`ifndef ID_EX
`define ID_EX

`include "../coredefs.sv"
`include "../common.sv"

interface if_id_ex();

    logic mem_load, reg_wr;
    logic mem_wr;
    logic `WIDE(3) mem_opt;
    logic mem_signed;
    logic `WIDE(5) reg_anum, reg_bnum, reg_wnum;
    logic `WIDE(2) alu_sela, alu_selb;
    logic `WIDE(3) ALUctr;
    logic ALUext;
    logic `WIDE(32) imm, pc;
    logic `WIDE(3)  branch;

    modport in (
        input mem_load, reg_wr, mem_wr, alu_sela, alu_selb, ALUctr, ALUext, reg_anum, reg_bnum, reg_wnum, mem_opt, mem_signed, imm, pc, branch
    );
    modport out (
        output mem_load, reg_wr, mem_wr, alu_sela, alu_selb, ALUctr, ALUext, reg_anum, reg_bnum, reg_wnum, mem_opt, mem_signed, imm, pc, branch
    );

endinterface //if_w_wb

module id_ex (
    input wire clk,
    input wire rst,
    input wire id_ex_stalled,
    if_id_ex.in if_id_ex_id,
    if_id_ex.out if_id_ex_ex
);

    `ALWAYS_CR if(rst) begin
        if_id_ex_ex.alu_sela     <= '0;
        if_id_ex_ex.alu_selb     <= '0;
        if_id_ex_ex.mem_opt      <= '0;
        if_id_ex_ex.mem_signed   <= '0;
        if_id_ex_ex.reg_wr       <= '0;
        if_id_ex_ex.reg_anum     <= '0;
        if_id_ex_ex.reg_bnum     <= '0;
        if_id_ex_ex.reg_wnum     <= '0;
        if_id_ex_ex.mem_load     <= '0;
        if_id_ex_ex.ALUctr       <= '0;
        if_id_ex_ex.ALUext       <= '0;
        if_id_ex_ex.mem_wr       <= '0;
        if_id_ex_ex.imm          <= '0;
        if_id_ex_ex.pc           <= '0;
        if_id_ex_ex.branch       <= '0;
    end else if (~id_ex_stalled) begin
        if_id_ex_ex.alu_sela     <= if_id_ex_id.alu_sela;
        if_id_ex_ex.alu_selb     <= if_id_ex_id.alu_selb;
        if_id_ex_ex.mem_opt      <= if_id_ex_id.mem_opt;
        if_id_ex_ex.mem_signed   <= if_id_ex_id.mem_signed;
        if_id_ex_ex.reg_wr       <= if_id_ex_id.reg_wr;
        if_id_ex_ex.reg_anum     <= if_id_ex_id.reg_anum;
        if_id_ex_ex.reg_bnum     <= if_id_ex_id.reg_bnum;
        if_id_ex_ex.reg_wnum     <= if_id_ex_id.reg_wnum;
        if_id_ex_ex.mem_load     <= if_id_ex_id.mem_load;
        if_id_ex_ex.ALUctr       <= if_id_ex_id.ALUctr;
        if_id_ex_ex.ALUext       <= if_id_ex_id.ALUext;
        if_id_ex_ex.mem_wr       <= if_id_ex_id.mem_wr;
        if_id_ex_ex.imm          <= if_id_ex_id.imm;
        if_id_ex_ex.pc           <= if_id_ex_id.pc;
        if_id_ex_ex.branch       <= if_id_ex_id.branch;
    end else begin
        if_id_ex_ex.alu_sela     <= `ALU_A_REG;
        if_id_ex_ex.alu_selb     <= `ALU_B_IMM;
        if_id_ex_ex.mem_opt      <= '0;
        if_id_ex_ex.mem_signed   <= '0;
        if_id_ex_ex.reg_wr       <= '0;
        if_id_ex_ex.reg_anum     <= '0;
        if_id_ex_ex.reg_bnum     <= '0;
        if_id_ex_ex.reg_wnum     <= '0;
        if_id_ex_ex.mem_load     <= '0;
        if_id_ex_ex.ALUctr       <= `ALU_ADD;
        if_id_ex_ex.ALUext       <= `ALU_ADD_EXT;
        if_id_ex_ex.mem_wr       <= '0;
        if_id_ex_ex.imm          <= '0;
        if_id_ex_ex.pc           <= '0;
        if_id_ex_ex.branch       <= `BRANCH_NIL;
    end

endmodule

`endif
