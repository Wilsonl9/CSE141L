// CSE141L Winter 2018
// program counter for in class demo
import definitions::*;
module pc (
  input        [3:0] op, 		 // opcodes
  input              z,		     // zero flag from ALU
  input              neg,
  input signed [7:0] bamt,		 // how far/where to jump or branch
  input              clk,	     // clk -- PC advances and memory/reg_file writes are clocked 
  input              reset,		 // overrides all else, forces PC to 0 (start of program)
  output logic [7:0] PC);		 // program count

  assign brel = (z && op==BRZ) || (neg && op==BRN) || (z && op==JMP);	 // do a relative branch iff ALU z flag is set on a BRZ instruction

  always_ff @(posedge clk) 
    if(reset)					 // resetting to start=0
  	  PC <= 'b0;
  	else if (brel)               // relative branching
  	  PC <= PC + bamt;
  	else						 // normal/default operation
  	  PC <= PC + 'b1;			 

endmodule