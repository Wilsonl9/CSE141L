// CSE141L Winter 2018 in class demo
// lookup table for data memory addressing
// lets us access dm_adr pointer values 3, 4, and 5
//   (could be ANY desired others, including 64, 65, 128, etc.)
//   using only a 2-bit selector
module lut_m(
  input [1:0] ptr,
  output logic[7:0] dm_adr);

always_comb case (ptr)
  2'b00: dm_adr = 3;	        // demo will load from mem_adr 3 and 4
  2'b01: dm_adr = 4;
  2'b10: dm_adr = 5;			// demo will store result into mem_adr 5
  default: dm_adr = 255;
endcase

endmodule