// CSE141L Winter 2018
// in-class demo -- program counter lookup table
// tells PC what do do on an absolute or a relative jump/branch
module lut_pc(
  input[4:0] ptr,					  // lookup table's incoming address pointer
  output logic signed[7:0] dout);	  // goes to input port on PC

  always_comb case (ptr)
   0: dout = 8'd0;	        // demo will load from mem_adr 3 and 4
   1: dout = -8'd11;	        // demo will load from mem_adr 3 and 4
	2: dout = 8'd7;
	3: dout = -8'd18;
	4: dout = 8'd11;
	5: dout = 8'd2;
	6: dout = 8'd15;
  default: dout = 8'd0;
	/*2'b01: dout = 8'd8;				  // use for absolute jump to PC=8
	2'b10: dout = -8'd3;			  // for relative jump back by 3 instructions
	default: dout = 8'd1;			  // default: PC advances to next value (PC+4 in ARM or MIPS)*/
  endcase

endmodule