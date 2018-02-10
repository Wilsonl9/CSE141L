// CSE141L in class demo -- data memory
module dmem(
  input      clk,					// for writes only
             we,			        // write enable
  input[7:0] addr,					// address pointer for read or write
  input[7:0] di,					// data value to be written	to data memory
  output logic[7:0] dout);			// data read out of memory

  logic[7:0] guts[8];				// the 2-D memory array itself
  always_ff @(posedge clk) if (we)	// clocked writes, only if we=1
    guts[addr] <= di;

  always_comb						// unclocked (continuous) reads
    dout = guts[addr];

endmodule