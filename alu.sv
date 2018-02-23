// ALU for class demo
// CSE141L Win 2018
import definitions::*;              // declares ALU opcodes 
module alu (			         
  input             ci,			    // carry in
  input       [3:0] op,			    // opcode
  input       [7:0] in_a,		    // operands in
                    in_acc,
  output logic[7:0] acc,		    // result out
  output logic      co,			    // carry out
  output logic      z, 		    // zero flag, like ARM Z flag
  output logic      neg);          // negative flag
  op_mne op_mnemonic;			    // type enum: used for convenient waveform viewing
  
  logic [8:0] temp;
  always_comb begin
    case(op)						// selective override one or more defaults
	   kADD: begin
			temp = in_acc + in_a + ci;
			assign co = temp[8];
			assign neg = temp[7];
			assign acc = temp[7:0];
		        //{co,acc} = in_acc + in_a + ci;  // add w/ carry in and out
              		//sum <= in_acc + in_a + ci;
				//  neg = sum[7];
		 end
      kSUB: begin
				  temp = in_acc + (!in_a + 1);
		        assign co = temp[8];
				  assign neg = temp[7];
			     assign acc = temp[7:0];
				end
 	   kSTR: acc = in_acc;			  // store in data_mem from reg_file
	   kLDR: acc = in_a;		        // load reg_file from data_mem
      kAND: acc = in_acc & in_a;  	  // AND, acc = acc & operand
	   kXOR: acc = in_acc ^ in_a;	  // XOR, acc = acc ^ operand
	   kMLD: acc = in_a;	           // loads from memory into acc
	   kMST: acc = in_acc;	        // stores from acc into memory
	   kLDI: acc = in_a;	           // load immediate into acc
	   kSHL: {co,acc} = in_acc << in_a;	  // shifts the acc n times left
	   kSHR: acc = in_acc >> in_a;	  // shifts the acc n times right
	   kJMP: z = !in_a;	           // branch absolute: same test in ALU
	   kBRN: neg = neg;	              // branch if neg bit is on
	   kBRZ: z = !in_acc;           // branch relative: if(in_a=0), set z flag=1
	   kNOT: acc = !in_acc;	        // NOT, acc = ~acc	 
	   kCLR: begin
		        co    = 1'b0;				    // defaults
              acc  = 8'b0;
	           z     = 1'b0;
	           neg = 1'b0;
			   end
    endcase
  end
  assign  op_mnemonic = op_mne'(op);  // creates ALU opcode mnemonics in timing diagram

endmodule