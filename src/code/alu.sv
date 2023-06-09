`ifndef _ALU
`define _ALU

`include "common.sv"
`include "coredefs.sv"

module alu(
	input wire [31:0] dataa,
	input wire [31:0] datab,
	input wire [2:0]  ALUctr,
    input wire        ALUext,
	output reg less,
	output reg zero,
	output reg [31:0] aluresult
);

    reg [31:0] reverse;
    reg [31:0] temp;
    reg carry;
    reg of;
    wire [4:0] offset;
    assign offset = datab[4:0];
    always @(*)
    begin
        case(ALUctr)
        `ALU_ADD:
            begin
                reverse = '0;
                of = '0;
                temp = '0;
                if(~ALUext)
                begin
                    {carry, aluresult} = dataa + datab;
                    less = '0;
                    zero = ~(|aluresult);
                end
                else 
                begin
                    {carry, aluresult} = {1'b0, dataa} + {1'b0, ~datab} + 33'b1;
                    less = '0;
                    zero = ~(|aluresult);
                end
            end
        `ALU_SLL:
            begin
                reverse = '0;
                carry = '0;
                of = '0;
                temp = '0;
                aluresult = dataa << datab[4:0];
                less = '0;
                zero = ~(|aluresult);
            end
        `ALU_SLT:
            begin
                reverse = ~datab;
                temp = '0;
                {carry, aluresult} = dataa + reverse + 1;
                of = (dataa[31] == reverse[31]) && (aluresult [31] != dataa[31]);
                less = (aluresult[31] ^ of) ? 1'b1 : 1'b0;
                aluresult = {31'b0, less};
                zero = (dataa == datab);
            end
        `ALU_SLTU:
            begin 
                reverse = ~datab;
                of = '0;
                temp = '0;
                {carry, aluresult} = dataa + reverse + 1;
                less = (carry ^ 1) ? 1'b1 : 1'b0;
                aluresult = {31'b0, less};
                zero = (dataa == datab);
            end
        `ALU_XOR:
            begin 
                reverse = '0;
                carry = '0;
                of = '0;
                temp = '0;
                aluresult = dataa ^ datab;
                less = '0;
                zero = ~(|aluresult);
            end
        `ALU_SR:
            begin 
                reverse = '0;
                carry = '0;
                of = '0;
                if(~ALUext)
                begin
                    temp = dataa >> datab[4:0];
                end
                else
                begin
                    temp = offset[0] ? {dataa[31], dataa[31:1]} : dataa;
                    temp = offset[1] ? {{2{temp[31]}}, temp[31:2]} : temp;
                    temp = offset[2] ? {{4{temp[31]}}, temp[31:4]} : temp;
                    temp = offset[3] ? {{8{temp[31]}}, temp[31:8]} : temp;
                    temp = offset[4] ? {{16{temp[31]}}, temp[31:16]} : temp;
                end
                aluresult = temp;
                less = '0;
                zero = ~(|aluresult);
            end
        `ALU_OR:
            begin 
                reverse = '0;
                temp = '0;
                of = '0;
                carry = '0;
                aluresult = dataa | datab;
                less = '0;
                zero = ~(|aluresult);
            end
        `ALU_AND:
            begin 
                reverse = '0;
                temp = '0;
                of = '0;
                carry = '0;
                aluresult = dataa & datab;
                less = '0;
                zero = ~(|aluresult);
            end
        default: 
            begin
                reverse = '0;
                temp = '0;
                of = '0;
                carry = '0;
                aluresult = '0;
                less = '0;
                zero = '0;
            end
        endcase 
    end
endmodule

`endif
