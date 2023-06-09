`ifndef STALLER
`define STALLER

module staller(
  input wire pcg_isjalr,
  input wire pcg_branch,
  output wire id_ex_stalled,
  output wire if_id_stalled
);

  assign id_ex_stalled = pcg_branch;
  assign if_id_stalled = pcg_isjalr | pcg_branch;

endmodule

`endif
