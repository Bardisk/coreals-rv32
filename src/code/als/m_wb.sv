`ifndef M_WB
`define M_WB

`include "../common.sv"

interface if_m_wb();

    logic `WIDE(`XLEN) aluresult, mem_dat_i_w, Data_out;
    logic mem_load, reg_wr;
    logic `WIDE(5) reg_wnum;

    modport in (
        input mem_load, reg_wr, aluresult, reg_wnum, mem_dat_i_w, Data_out
    );
    modport out (
        output mem_load, reg_wr, aluresult, reg_wnum, mem_dat_i_w, Data_out
    );

endinterface //if_w_wb

module m_wb (
    input wire clk,
    input wire rst,
    if_m_wb.in if_m_wb_m,
    if_m_wb.out if_m_wb_wb
);

    `ALWAYS_CR if(rst) begin
        if_m_wb_wb.aluresult    <= '0;
        if_m_wb_wb.mem_dat_i_w  <= '0;
        if_m_wb_wb.Data_out     <= '0;
        if_m_wb_wb.reg_wr       <= '0;
        if_m_wb_wb.reg_wnum     <= '0;
        if_m_wb_wb.mem_load     <= '0;
    end else begin
        if_m_wb_wb.aluresult    <= if_m_wb_m.aluresult;
        if_m_wb_wb.mem_dat_i_w  <= if_m_wb_m.mem_dat_i_w;
        if_m_wb_wb.Data_out     <= if_m_wb_m.Data_out;
        if_m_wb_wb.reg_wr       <= if_m_wb_m.reg_wr;
        if_m_wb_wb.reg_wnum     <= if_m_wb_m.reg_wnum;
        if_m_wb_wb.mem_load     <= if_m_wb_m.mem_load;
    end
    

endmodule

`endif
