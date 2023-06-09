`ifndef _COREDEFS
`define _COREDEFS

// I type inst

`define INST_ADDI   3'b000
`define INST_SLTI   3'b010
`define INST_SLTIU  3'b011
`define INST_XORI   3'b100
`define INST_ORI    3'b110
`define INST_ANDI   3'b111
`define INST_SLLI   3'b001
`define INST_SRI    3'b101

// Ops
`define INST_TYPE_I   7'b0010011
`define INST_TYPE_L   7'b0000011
`define INST_TYPE_R_M 7'b0110011
`define INST_TYPE_S   7'b0100011
`define INST_TYPE_B   7'b1100011
`define INST_LUI    7'b0110111
`define INST_AUIPC  7'b0010111
`define INST_JAL    7'b1101111
`define INST_JALR   7'b1100111

`define MEM_BYTE    2'b00
`define MEM_HALF    2'b01
`define MEM_WORD    2'b10

`define BRANCH_NIL  3'b000
`define BRANCH_JAL  3'b001
`define BRANCH_JALR 3'b010
`define BRANCH_BEQ  3'b100
`define BRANCH_BNE  3'b101
`define BRANCH_BLT  3'b110
`define BRANCH_BGE  3'b111

`define INST_LB     3'b000
`define INST_SB     3'b000
`define INST_LH     3'b001
`define INST_SH     3'b001
`define INST_LW     3'b010
`define INST_SW     3'b010
`define INST_LBU    3'b100
`define INST_LHU    3'b101


// R and M type inst

// R type inst
`define ALU_ADD    3'b000
`define ALU_SLL    3'b001
`define ALU_SLT    3'b010
`define ALU_SLTU   3'b011
`define ALU_XOR    3'b100
`define ALU_SR     3'b101
`define ALU_OR     3'b110
`define ALU_AND    3'b111

`define ALU_ADD_EXT 1'b0
`define ALU_SUB_EXT 1'b1
`define ALU_SRL_EXT 1'b0
`define ALU_SRA_EXT 1'b1

`define ALU_A_REG   2'b00
`define ALU_A_PC    2'b01 //auipc
`define ALU_A_ZERO  2'b10 //lui

`define ALU_B_REG   2'b00
`define ALU_B_IMM   2'b01
`define ALU_B_FOUR  2'b10


// M type inst
`define INST_MUL    3'b000
`define INST_MULH   3'b001
`define INST_MULHSU 3'b010
`define INST_MULHU  3'b011
`define INST_DIV    3'b100
`define INST_DIVU   3'b101
`define INST_REM    3'b110
`define INST_REMU   3'b111

// J type inst


`define INST_NOP_OP 7'b0000001
`define INST_FENCE  7'b0001111

`define INST_NOP    32'h00000001
`define INST_MRET   32'h30200073
`define INST_RET    32'h00008067
`define INST_ECALL  32'h00000073
`define INST_EBREAK 32'h00100073

`define INST_BEQ    3'b000
`define INST_BNE    3'b001
`define INST_BLT    3'b100
`define INST_BGE    3'b101
`define INST_BLTU   3'b110
`define INST_BGEU   3'b111

// CSR inst
`define INST_CSR    7'b1110011
`define INST_CSRRW  3'b001
`define INST_CSRRS  3'b010
`define INST_CSRRC  3'b011
`define INST_CSRRWI 3'b101
`define INST_CSRRSI 3'b110
`define INST_CSRRCI 3'b111

// CSR reg addr
`define CSR_CYCLE   12'hc00
`define CSR_CYCLEH  12'hc80
`define CSR_MTVEC   12'h305
`define CSR_MCAUSE  12'h342
`define CSR_MEPC    12'h341
`define CSR_MIE     12'h304
`define CSR_MSTATUS 12'h300
`define CSR_MSCRATCH 12'h340

`endif 
