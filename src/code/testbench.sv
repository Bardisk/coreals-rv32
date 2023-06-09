`timescale 1ns/1ps
`include "core.sv"

module tb_core;

reg clk = 0;
reg rst = 1;
reg [31:0] inst;

core core_0(
    .rst (rst),
    .clk (clk),
    .intr (1'b0),
    .inst_in(inst),
    .Data_in('0)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_core.vcd");
    $dumpvars(0, tb_core);
end

initial begin
    rst = 0;
    #1
    rst = 1;
    inst = '0;
    #(CLK_PERIOD - 1)
    rst = 0;
    #(CLK_PERIOD/2)
    inst = 32'h00007293;
    #(CLK_PERIOD)
    inst = 32'h00007313;
    #(CLK_PERIOD)
    inst = 32'h88888137;
    #(CLK_PERIOD)
    inst = 32'h00832183;
    #(CLK_PERIOD)
    inst = 32'h0032a223;
    #(CLK_PERIOD)
    inst = 32'h00402083;
    #(CLK_PERIOD)
    inst = 32'h01c02383;
    #(CLK_PERIOD)
    inst = 32'h00338863;
    #(CLK_PERIOD)
    inst = 32'h555550b7;
    #(CLK_PERIOD)
    inst = 32'h0070a0b3;
    #(CLK_PERIOD)
    inst = 32'hfe0098e3;
    #(CLK_PERIOD)
    inst = 32'h007282b3;
    #(CLK_PERIOD)
    inst = 32'h00230333;
    #(CLK_PERIOD)
    inst = 32'h00531463;
    #(CLK_PERIOD)
    inst = 32'h40000033;
    #(CLK_PERIOD)
    inst = 32'h40530433;
    #(CLK_PERIOD)
    inst = 32'h405304b3;
    #(CLK_PERIOD)
    inst = 32'h0080006f;
    #(CLK_PERIOD)
    inst = 32'h00007033;
    #(CLK_PERIOD)
    inst = 32'h0072f533;
    #(CLK_PERIOD)
    inst = 32'h00157593;
    #(CLK_PERIOD)
    inst = 32'h00b51463;
    #(CLK_PERIOD)
    inst = 32'h00006033;
    #(CLK_PERIOD)
    inst = 32'h00a5e5b3;
    #(CLK_PERIOD)
    inst = 32'h0015e513;
    #(CLK_PERIOD)
    inst = 32'h00558463;
    #(CLK_PERIOD)
    inst = 32'h00004033;
    #(CLK_PERIOD)
    #(CLK_PERIOD)
    inst = 32'h00129293;
    #(CLK_PERIOD)
    inst = 32'h00b28463;
    #(CLK_PERIOD)
    inst = 32'h00000013;
    #(CLK_PERIOD)
    inst = 32'h001026b3;
    #(CLK_PERIOD)
    inst = 32'h00503733;
    #(CLK_PERIOD)
    inst = 32'hf65ff06f;
    #(CLK_PERIOD*100)

    $finish;
end

endmodule