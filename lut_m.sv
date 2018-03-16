// CSE141L Winter 2018 in class demo
// lookup table for data memory addressing
// lets us access dm_adr pointer values 3, 4, and 5
//   (could be ANY desired others, including 64, 65, 128, etc.)
//   using only a 2-bit selector
module lut_m(
  input [4:0] ptr,
  output logic[7:0] dm_adr);

always_comb case (ptr)
	0: dm_adr = -8'd11;	        // demo will load from mem_adr 3 and 4
	1: dm_adr = 8'd9;
	2: dm_adr = -8'd20;
	3: dm_adr = 8'd14;
	4: dm_adr = 8'd3;
	5: dm_adr = 8'd17;
  default: dm_adr = 255;
endcase

endmodule