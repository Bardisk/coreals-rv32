`ifndef EX_M
`define EX_M

`include "../common.sv"
`include "../decode.sv"

interface if_ex_m();

    logic `WIDE(`XLEN) aluresult, rbdata;
    logic mem_load, reg_wr;
    logic mem_wr;
    logic `WIDE(3) mem_opt;
    logic mem_signed;
    logic `WIDE(5) reg_wnum;

    modport in (
        input rbdata, mem_load, reg_wr, mem_wr, aluresult, reg_wnum, mem_opt, mem_signed
    );
    modport out (
        output rbdata, mem_load, reg_wr, mem_wr, aluresult, reg_wnum, mem_opt, mem_signed
    );

endinterface //if_w_wb

module ex_m (
    input wire clk,
    input wire rst,
    if_ex_m.in if_ex_m_ex,
    if_ex_m.out if_ex_m_m
);

    `ALWAYS_CR if(rst) begin
        if_ex_m_m.aluresult    <= '0;
        if_ex_m_m.mem_opt      <= '0;
        if_ex_m_m.mem_signed   <= '0;
        if_ex_m_m.reg_wr       <= '0;
        if_ex_m_m.reg_wnum     <= '0;
        if_ex_m_m.mem_load     <= '0;
        if_ex_m_m.rbdata       <= '0;
        if_ex_m_m.mem_wr       <= '0;
    end else begin
        if_ex_m_m.aluresult    <= if_ex_m_ex.aluresult;
        if_ex_m_m.mem_opt      <= if_ex_m_ex.mem_opt;
        if_ex_m_m.mem_signed   <= if_ex_m_ex.mem_signed;
        if_ex_m_m.reg_wr       <= if_ex_m_ex.reg_wr;
        if_ex_m_m.reg_wnum     <= if_ex_m_ex.reg_wnum;
        if_ex_m_m.mem_load     <= if_ex_m_ex.mem_load;
        if_ex_m_m.rbdata       <= if_ex_m_ex.rbdata;
        if_ex_m_m.mem_wr       <= if_ex_m_ex.mem_wr;
    end

endmodule

`endif
