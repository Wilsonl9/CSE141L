//This file defines the parameters used in the alu
// CSE141L Win 2018 in-class demo
package definitions;
    
// Instruction map
    const logic [2:0]kLDR  = 3'b000;      // load reg_file from data_mem
    const logic [2:0]kCLR  = 3'b001;	  // clear ALU output
    const logic [2:0]kACC  = 3'b010;	  // add A+B w/ carry
    const logic [2:0]kACI  = 3'b011;	  // decrement A
    const logic [2:0]kBZR  = 3'b100;	  // set z flag if A=0
	const logic [2:0]kBZA  = 3'b101;	  // set z flag if A=0
	const logic [2:0]kSTR  = 3'b110;	  // store in data_mem from reg_file
// enum names will appear in timing diagram
    typedef enum logic[2:0] {			  // mnemonic equivs of the above
        LDR, CLR, ACC, ACI, BZR, BZA, STR // strictly for user convnience in timing diagram
         } op_mne;
    
endpackage // definitions
