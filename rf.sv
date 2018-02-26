// CSE141L Win 2018  in-class demo
// 16-element reg_file (yours will have up to 16 elements)
module rf(
  input             clk,
  input  [7:0]      di,					// data to load into reg_file
  input             we,				    // write enable
  input  [3:0]      ptr_w,				// address to write to
                    ptr_a,				// 2 addresses to read from
  output logic[7:0] do_a,
  output logic[7:0] do_acc);               // 2 data values to be read from reg_file

  logic  [7:0] core[16];				    // our reg_file itself -- 8x16 2-dimensional array
  logic  [7:0] accumulator;
  always_ff @(posedge clk) if(we)		// write only on posedge clock and only if we=1
	if(ptr_w != 15 && ptr_w != 14)
	begin
	  core[ptr_w] <= di;
	end

  always_comb
  begin
    do_a = core[ptr_a];		// reads are continuous/combinational instead of 
                                       //   clocked/sequential
    do_acc = accumulator;
  end
													
  always_ff @(posedge clk)
  begin
    accumulator = di;
  end

endmodule