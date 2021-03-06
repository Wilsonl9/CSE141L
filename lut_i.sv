// CSE141L Winter 2018 in class demo
// lookup table for data memory addressing
// lets us access dm_adr pointer values 3, 4, and 5
//   (could be ANY desired others, including 64, 65, 128, etc.)
//   using only a 2-bit selector
module lut_i(
  input [4:0] ptr_i,
  output logic[7:0] dm_i);

always_comb case (ptr_i)
	0: dm_i = 8'd14;	        // demo will load from mem_adr 3 and 4
	1: dm_i = 8'd20;
	2: dm_i = 8'd127;

        // String Macthing
	3: dm_i = 8'd0;
	4: dm_i = 8'd15;
	5: dm_i = 8'd5;
	6: dm_i = 8'd6;
	7: dm_i = 8'd32;
	8: dm_i = 8'd64;
	9: dm_i = 8'd7;
  default: dm_i = 8'd0;
  /*5'b00: dm_i = 3;	        // demo will load from mem_adr 3 and 4
  5'b01: dm_i = 4;
  5'b10: dm_i = 5;			// demo will store result into mem_adr 5
  default: dm_i = 255;*/
endcase

endmodule
