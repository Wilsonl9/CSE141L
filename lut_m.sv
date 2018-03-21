// CSE141L Winter 2018 in class demo
// lookup table for data memory addressing
// lets us access dm_adr pointer values 3, 4, and 5
//   (could be ANY desired others, including 64, 65, 128, etc.)
//   using only a 2-bit selector
module lut_m(
  input [7:0] ptr,
  output logic[7:0] dm_adr);

always_comb case (ptr)
	0: dm_adr = 8'd1;	        // demo will load from mem_adr 3 and 4
	1: dm_adr = 8'd2;
	2: dm_adr = 8'd3;
	3: dm_adr = 8'd4;
	4: dm_adr = 8'd5;
  default: dm_adr = 8'd0;
endcase

endmodule