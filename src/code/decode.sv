`ifndef _DECODE
`define _DECODE

`include "common.sv"
`include "coredefs.sv"
`include "uibi.sv"

//decode module
module decode(
  input  wire `WIDE(`XLEN) inst,
  output reg  `WIDE(`XLEN) imm,
  output wire `WIDE(5)     reg_anum,
  output wire `WIDE(5)     reg_bnum,
  output wire `WIDE(5)     reg_wnum,
  output reg  `WIDE(3)     ALUctr,
  output reg               ALUext,
  output reg  `WIDE(2)     alu_sela,
  output reg  `WIDE(2)     alu_selb,
  output reg               mem_wr,
  output reg               reg_wr,
  output wire              mem_load,
  output reg  `WIDE(3)     mem_opt,
  output reg               mem_signed,
  output reg  `WIDE(3)     branch
);

  wire `WIDE(7) op = inst[6:0];

  //imm
  always @(*) begin
    case (op)
      `INST_TYPE_I, `INST_TYPE_L, `INST_JALR:
        imm = {{21{inst[31]}}, inst[30:20]};
      `INST_LUI, `INST_AUIPC:
        imm = {inst[31:12], 12'h0};
      `INST_JAL:
        imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
      `INST_TYPE_R_M:
        imm = '0;
      `INST_TYPE_B:
        imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
      `INST_TYPE_S:
        imm = {{21{inst[31]}}, inst[30:25], inst[11:7]};
      default:
        imm = '0;
    endcase
  end

  //ra, rb, rd
  assign reg_anum = inst[19:15];
  assign reg_bnum = inst[24:20];
  assign reg_wnum = inst[11:7];

  //alu
  always @(*) begin
    case (op)
      `INST_TYPE_R_M: begin
        ALUctr = inst[14:12];
        ALUext = inst[30];
      end
      `INST_TYPE_I: begin
        ALUctr = inst[14:12];
        if (inst[14:12] == `ALU_SR)
          ALUext = inst[30];
        else ALUext = '0;
      end
      `INST_TYPE_B: begin
        ALUctr = (inst[14:13] == 2'b11) ? `ALU_SLTU : `ALU_SLT;
        ALUext = '0;
      end
      default: begin
        ALUctr = `ALU_ADD;
        ALUext = '0;
      end
    endcase
  end

  //aluasel
  always @(*) begin
    case (op)
      `INST_AUIPC, `INST_JAL, `INST_JALR:
        alu_sela = `ALU_A_PC;
      `INST_LUI:
        alu_sela = `ALU_A_ZERO;
      default:
        alu_sela = `ALU_A_REG;
    endcase
  end
  
  //alubsel
  always @(*) begin
    case (op)
      `INST_JAL, `INST_JALR:
        alu_selb = `ALU_B_FOUR;
      `INST_TYPE_S, `INST_TYPE_L, `INST_TYPE_I, `INST_AUIPC, `INST_LUI:
        alu_selb = `ALU_B_IMM;
      default:
        alu_selb = `ALU_B_REG;
    endcase
  end

  //mem_load
  assign mem_load = (op == `INST_TYPE_L) ? 1'b1 : 1'b0;

  //mem_wr
  assign mem_wr  = (op == `INST_TYPE_S) ? 1'b1 : 1'b0;

  //reg_wr
  always @(*) begin
    case (op)
      `INST_TYPE_L, `INST_TYPE_R_M, `INST_TYPE_I, `INST_JAL, `INST_JALR, `INST_AUIPC, `INST_LUI:
        reg_wr = 1'b1;
      default:
        reg_wr = 1'b0;
    endcase
  end

  //mem_signed
  always @(*) begin
    if (op == `INST_TYPE_L && inst[14:13] == 2'b00)
      mem_signed = 1'b1;
    else mem_signed = 1'b0;
  end

  //mem_opt
  always @(*) begin
    if (op == `INST_TYPE_S || op == `INST_TYPE_L) begin
      case (inst[13:12])
        `MEM_BYTE: mem_opt = `BUS_QUAR;
        `MEM_HALF: mem_opt = `BUS_HALF;
        `MEM_WORD: mem_opt = `BUS_FULL;
        default:   mem_opt = `BUS_NULL;
      endcase
    end else mem_opt = `BUS_NULL;
  end

  //branch
  always @(*) begin
    case (op)
      `INST_JAL:
        branch = `BRANCH_JAL;
      `INST_JALR:
        branch = `BRANCH_JALR;
      `INST_TYPE_B: begin
        case (inst[14:12])
          `INST_BEQ:
            branch = `BRANCH_BEQ;
          `INST_BNE:
            branch = `BRANCH_BNE;
          `INST_BLT, `INST_BLTU:
            branch = `BRANCH_BLT;
          `INST_BGE, `INST_BGEU:
            branch = `BRANCH_BGE;
          default:
            branch = `BRANCH_NIL;
        endcase
      end
      default: branch = `BRANCH_NIL;
    endcase
  end

endmodule

module load_sext (
  input   wire    `WIDE(`XLEN)  current,
  input   wire    `WIDE(3)      mem_mode,
  input   wire    `WIDE(2)      low_addr,
  input   wire                  mem_signed,
  output  reg     `WIDE(`XLEN)  target
);

  // assign target = current;

  always_comb begin : block
    case (low_addr)
      2'b00: target = current;
      2'b01: target = current >> (`XLEN/4);
      2'b10: target = current >> (`XLEN/2);
      2'b11: target = current >> ((`XLEN/2) + (`XLEN/4));
      default: target = current;
    endcase
    if (mem_signed) begin
      case (mem_mode)
        `BUS_HALF: target |= {{(`XLEN/2) {target[(`XLEN/2)-1]}}, {(`XLEN/2) {1'b0}}};
        `BUS_QUAR: target |= {{((`XLEN/2) + (`XLEN/4)) {target[(`XLEN/4)-1]}}, {(`XLEN/4) {1'b0}}};
        default: target |= `XLEN'b0; 
      endcase
    end
  end

endmodule

module save_sext (
  input   wire    `WIDE(`XLEN)  current,
  input   wire    `WIDE(3)      mem_mode,
  input   wire    `WIDE(2)      low_addr,
  output  reg     `WIDE(`XLEN)  target
);

  always @(*) begin
    case (mem_mode)
      `BUS_HALF: target = {{(`XLEN/2) {1'b0}}, `BITRANGE(current, `XLEN/2, 0)};
      `BUS_QUAR: target = {{((`XLEN/2) + (`XLEN/4)) {1'b0}}, `BITRANGE(current, `XLEN/4, 0)};
      default: target = current; 
    endcase
    case (low_addr)
      2'b00: target = target;
      2'b01: target = target << (`XLEN/4);
      2'b10: target = target << (`XLEN/2);
      2'b11: target = target << ((`XLEN/2) + (`XLEN/4));
      default: ;
    endcase
  end

endmodule
  

`endif
