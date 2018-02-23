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
  
  always_comb begin
	co = ci;
	acc = in_acc;
	neg = acc[7];
	z = (acc == 0)? 1 : 0;
	case(op)						// selective override one or more defaults
		kADD: begin
					{co,acc} = in_acc + in_a + ci;
					neg = acc[7];
					z = (acc == 0)? 1 : 0;
				end
		kSUB: begin
					{co,acc} = in_acc + (!in_a + 1);
					neg = acc[7];
					z = (acc == 0)? 1 : 0;
				end
		kSTR: begin
					acc = in_acc;			  // store in data_mem from reg_file
					z = (acc == 0)? 1 : 0;
				end
		kLDR: begin
					acc = in_a;		        // load reg_file from data_mem
					z = (acc == 0)? 1 : 0;
				end
		kAND: begin
					acc = in_acc & in_a;  	  // AND, acc = acc & operand
					z = (acc == 0)? 1 : 0;
				end
		kXOR: begin
					acc = in_acc ^ in_a;	  // XOR, acc = acc ^ operand
					z = (acc == 0)? 1 : 0;
				end
		kMLD: begin
					acc = in_a;	           // loads from memory into acc
					z = (acc == 0)? 1 : 0;
				end
		kMST: acc = in_acc;	        // stores from acc into memory
		kLDI: begin
					acc = in_a;	           // load immediate into acc
					z = (acc == 0)? 1 : 0;
				end
		kSHL: begin
					{co,acc} = in_acc << in_a;	  // shifts the acc n times left
					z = (acc == 0)? 1 : 0;
				end
		kSHR: begin
					acc = in_acc >> in_a;	  // shifts the acc n times right
					z = (acc == 0)? 1 : 0;
				end
		kJMP: begin
					z = !in_a;	           // branch absolute: same test in ALU
				end
		kBRN: begin
					neg = neg;	              // branch if neg bit is on
				end
		kBRZ: begin
					z = !in_acc;           // branch relative: if(in_a=0), set z flag=1
				end
		kNOT: begin
					acc = !in_acc;	        // NOT, acc = ~acc	 
					z = (acc == 0)? 1 : 0;
				end
		kCLR: begin
					co    = 1'b0;				    // defaults
					acc = acc;
					z     = 1'b0;
					neg = 1'b0;
				end
	endcase
  end
  assign  op_mnemonic = op_mne'(op);  // creates ALU opcode mnemonics in timing diagram

endmodule