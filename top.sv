// CSE141L Win2018    in-class demo
// top-level design connects all pieces together
import definitions::*;
module top(
  input        clk,
               reset,
  output logic done);

// list of interconnecting wires/buses w/ respective bit widths 
  wire signed[7:0] bamt;	    // PC jump
  wire[7:0] PC;				    // program counter
  wire[8:0] inst;			    // machine code
  wire[7:0] dm_out,			    // data memory
            dm_in,			   
            dm_adr;
  wire[7:0] in_a,			    // alu inputs
            in_b,			   
			rslt,               // alu output
            do_a;	            // reg_file outputs
  wire[7:0] rf_din;	            // reg_file input
  wire[4:0] op;	                // opcode
  wire[3:0] ptr_a;			    // ref_file pointers
  wire      z;	                // alu zero flag
  logic     rf_we;              // reg_file write enable
  wire      ldr,			    // load mode (mem --> reg_file)
            str;			    // store (reg_file --> mem)
  assign    op    = inst[6:4];
  assign    ptr_a = inst[3:2];
  assign    ptr_w = inst[3:2];
  assign    ptr_b = inst[1:0];
  assign    dm_in = do_a;	    // rf ==> dm
  assign    in_a  = do_a; 		// rf ==> ALU
  always_comb case (op)
    kLDR, kCLR, kACC, kACI: rf_we = 1;
    default: rf_we = 0;
  endcase
// load: rf data input from mem; else: from ALU out 
  assign    rf_din = ldr? dm_out : rslt;
// select immediate or rf for second ALU input
  assign    in_b  = op==kACI? -1 : do_b; 
// PC branch values
  logic[1:0] lutpc_ptr;
  always_comb case(op)
    kBZR: lutpc_ptr = 2;	     // relative
	kBZA: lutpc_ptr = 1;	     // absolute
	default: lutpc_ptr = 0;	     // biz-as-usual
  endcase 					   
  lut_pc lp1(				     // maps 2 bits to 8
    .ptr  (lutpc_ptr),		    
	.dout (bamt));	             // branch distance in PC
							   
  pc pc1(						 // program counter
    .clk (clk) ,
	.reset, 
	.op   ,					     // from inst_mem
	.bamt (bamt) ,		         // from lut_pc
	.z    ,					     // zero flag from ALU
	.PC );					     // to PC module

  imem im1(					     // instruction memory
     .PC   ,				     // pointer in = PC
	 .inst);				     // output = 7-bit (yours is 9) machine code

  assign done = inst[6:4]==kSTR; // store result & hit done flag

  ls_dec  dc1(				     // load and store decode
    .op  ,
	.str ,					     // store turns on memory write enable
	.ldr					     // load turns on reg_file write enable
    );

  rf rf1(						 // reg file -- one write, two reads
    .clk             ,
	.di   (rf_din)   ,			 // data to be written in
	.we   (rf_we)      ,		 // write enable
	.ptr_w(inst[3:2])   ,		 // write pointer = one of the read ptrs
	.ptr_a(inst[3:2])   ,		 // read pointers 
	.ptr_b(inst[1:0])   ,
	.do_a               ,        // to ALU
	.do_b  						 // to ALU immediate input switch
  );

  alu au1(						 // execution (ALU) unit
    .ci (1'b0),					 // not using carry-in in this program
	.op ,						 // ALU operation
	.in_a ,						 // alu inputs
	.in_b ,
	.rslt ,						 // alu output
	.co (),						 // carry out -- not connected, not used
	.z  );						 // zero flag   in_a=0

  lut_m lm1(					 // lookup table for data mem address
    .ptr(inst[1:0]),			 // select one of up to four addresses
	.dm_adr						 // send this (8-bit) address to data mem
  );

  dmem dm1(						 // data memory
    .clk         ,
	.we  (str)   ,				 // only time to write = store 
	.addr(dm_adr),				 // from LUT
	.di  (dm_in) ,				 // data to store (from reg_file)
	.dout(dm_out));				 // data out (for loads)

endmodule