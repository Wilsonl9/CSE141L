// ALU for class demo
// CSE141L Win 2018
import definitions::*;              // declares ALU opcodes 
module alu (			         
  input             ci,			    // carry in
  input       [2:0] op,			    // opcode
  input       [7:0] in_a,		    // operands in
                    in_b,
  output logic[7:0] rslt,		    // result out
  output logic      co,			    // carry out
  output logic      z); 		    // zero flag, like ARM Z flag
  op_mne op_mnemonic;			    // type enum: used for convenient waveform viewing

  always_comb begin
    co    = 1'b0;				    // defaults
	rslt  = 8'b0;
	z     = 1'b0;
    case(op)						// selective override one or more defaults
      kLDR: rslt = in_a;		    // load reg_file from data_mem
	  kACC: {co,rslt} = in_a+in_b+ci;  // add w/ carry in and out
	  kACI: {co,rslt} = in_a-1+ci;	// decrement by 1 with carry in and out
	  kBZR: z = !in_a;				// branch relative: if(in_a=0), set z flag=1
	  kBZA: z = !in_a;				// branch absolute: same test in ALU
	  kSTR: rslt = in_a;			// store in data_mem from reg_file
    endcase
  end
  assign  op_mnemonic = op_mne'(op);  // creates ALU opcode mnemonics in timing diagram

endmodule