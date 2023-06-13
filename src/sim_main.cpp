#include "Vhello.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <stdint.h>
#include <cstdio>
uint64_t tb_time = 0;

uint32_t memory[16384];
int mem_size = 0;

uint32_t dmem[16384];

void downEdge(Vhello *top) {
  if (top->MemRW_Mem == 1 && (top->Addr_out >> 2) >= 16384) {
    printf("WARNING: ADDR OUT OF BOUND of %08x\n", top->Addr_out);
  }
  uint32_t tmp_Data_in = dmem[(top->Addr_out & 16383) >> 2];
  uint32_t tmp_Data_out = top->Data_out;
  uint32_t tmp_Addr_out = (top->Addr_out & 16383) >> 2;
  top->eval();
  top->Data_in = tmp_Data_in;
  printf("Data read %08x : %08x\n", tmp_Addr_out, top->Data_in);
  if (top->MemRW_Mem) {
    dmem[top->Addr_out >> 2] = tmp_Data_out;
    printf("Data write %08x : %08x\n", tmp_Addr_out, tmp_Data_out);
  }
}

void posEdge(Vhello *top) {
  printf("PC: 0x%08x\n", top->PC_out_IF);
  if ((top->PC_out_IF >> 2) >= mem_size) {
    printf("WARNING: PC OUT OF BOUND of %08x\n", top->PC_out_IF);
  }
  uint32_t tmp_inst_IF = memory[top->PC_out_IF >> 2];
  uint32_t tmp_PC_out_IF = top->PC_out_IF;
  top->eval();
  top->inst_IF = tmp_inst_IF;
  printf("Inst read %08x : %08x\n", tmp_PC_out_IF, top->inst_IF);
}

int main(int argc, char** argv) {
  dmem[2] = 0x80000000;
  Verilated::traceEverOn(true);
  Vhello* top = new Vhello("top");
  VerilatedVcdC *tfp = new VerilatedVcdC();
  top->trace(tfp, 0);
  tfp->open("wave.vcd");
  int k;

  FILE *mem = fopen("src/code/code.dat", "r");
  uint32_t now;
  while (~fscanf(mem, "%x", &now)) {
    memory[mem_size++] = now;
  }
  // fscanf(mem, "%d", now)

  top->clk = 1;
  top->rst = 0;
  top->eval();
  tfp->dump(tb_time++);

  top->rst = 1;
  k = 5;
  while (k--) {
    top->eval();
    tfp->dump(tb_time++);
  }

  k = 10000;
  while (k--) {
    top->rst = 0;
    if (tb_time % 6 == 0) {
      if (top->clk == 1) {
        top->clk = 0;
        downEdge(top);
      } else {
        top->clk = 1;
        posEdge(top);
      }
    }
    else top->eval();
    
    tfp->dump(tb_time++);
  }
  top->final();
  tfp->close();
  delete top;
  return 0;
}