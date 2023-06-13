`ifndef WB
`define WB

`include "m_wb.sv"
`include "../decode.sv"

module wb(
  if_m_wb.in if_m_wb_wb,
  output wire `WIDE(`XLEN) Data_out_WB,
  output reg  `WIDE(`XLEN) rwdata,
  output wire `WIDE(5) reg_wnum,
  output wire reg_wen
);

  assign Data_out_WB = rwdata;
  assign reg_wen = if_m_wb_wb.reg_wr;
  assign reg_wnum = if_m_wb_wb.reg_wnum;

  always @(*) begin
    if (if_m_wb_wb.mem_load) begin
      rwdata = if_m_wb_wb.mem_dat_i_w;
    end
    else if(if_m_wb_wb.reg_wr) begin
      rwdata = if_m_wb_wb.aluresult;
    end
    else rwdata = '0;
  end

endmodule

`endif
