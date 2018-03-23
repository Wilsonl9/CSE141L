// CSE141L Winter 2018
// in-class demo -- program counter lookup table
// tells PC what do do on an absolute or a relative jump/branch
module lut_pc(
  input[4:0] ptr,					  // lookup table's incoming address pointer
  output logic signed[7:0] dout);	  // goes to input port on PC

  always_comb case (ptr)
   	0: dout = 8'd0;

        // Multiply lut_pc
	1: dout = -8'd12;           // jmp FIRST_MULTIPLY
	2: dout = 8'd6;             // jmp LOWER_BITS_ARE_ZERO_END
	3: dout = -8'd18;           // jmp SECOND_MULTIPLY
	4: dout = 8'd12;            // brz FIRST_MULTIPLY_END
	5: dout = 8'd2;             // brz LOWER_BITS_ARE_ZERO
	6: dout = 8'd15;            // brz SECOND_MULTIPLY_END
	// Multiply lut_pc end

        7: dout = 8'd2; // closest pair stuff
	8: dout = 8'd4;
	9: dout	= 8'd9;
	10: dout = -8'd31;
	11: dout = -8'd10;
	12: dout = -8'd51;
	13: dout = 8'd8;
	14: dout = 8'd39;
	15: dout = 8'd7;
	16: dout = 8'd5;
	17: dout = 8'd3;
	18: dout = 8'd12; // end closest pair vals

	19: dout = -8'd33; 	// LOAD
	20: dout = -8'd14;	// COMPARE
	21: dout = 8'd12;	// MATCH
	22: dout = 8'd5;	// NEXT_ELEMENT and DONE
	23: dout = 8'd5;
  default: dout = 8'd0;
	/*2'b01: dout = 8'd8;				  // use for absolute jump to PC=8
	2'b10: dout = -8'd3;			  // for relative jump back by 3 instructions
	default: dout = 8'd1;			  // default: PC advances to next value (PC+4 in ARM or MIPS)*/
  endcase

endmodule
