`ifndef IF_ID
`define IF_ID

`include "../common.sv"
`include "../decode.sv"

interface if_if_id();
  logic `WIDE(`XLEN) inst, pc;

  modport in (
    input inst, pc
  );
  modport out (
    output inst, pc
  );

endinterface //if_w_wb

module if_id (
  input wire clk,
  input wire rst,
  input wire if_id_stalled,
  if_if_id.in if_if_id_if,
  if_if_id.out if_if_id_id
);

  `ALWAYS_CR if(rst) begin
    if_if_id_id.inst    <= '0;
    if_if_id_id.pc      <= '0;
  end else if(~if_id_stalled) begin
    if_if_id_id.inst    <= if_if_id_if.inst;
    if_if_id_id.pc      <= if_if_id_if.pc;
  end else begin
    if_if_id_id.inst    <= `NOP;
    if_if_id_id.pc      <= 32'hffffffff;
  end

endmodule

`endif
