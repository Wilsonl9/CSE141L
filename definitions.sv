//This file defines the parameters used in the alu
// CSE141L Win 2018 in-class demo
package definitions;
    
// Instruction map
    const logic [3:0]kADD  = 4'b0000;	  // add, acc = acc + operand
    const logic [3:0]kSUB  = 4'b0001;	  // sub, acc = acc - operand
	 const logic [3:0]kSTR  = 4'b0010;	  // stores the acc value into the register
	 const logic [3:0]kLDR  = 4'b0011;     // loads the register value into the acc
    const logic [3:0]kAND  = 4'b0100;	  // AND, acc = acc & operand
	 const logic [3:0]kXOR  = 4'b0101;	  // XOR, acc = acc ^ operand
	 const logic [3:0]kMLD  = 4'b0110;	  // loads from memory into acc
	 const logic [3:0]kMST  = 4'b0111;	  // stores from acc into memory
	 const logic [3:0]kLDI  = 4'b1000;	  // load immediate into acc
	 const logic [3:0]kSHL  = 4'b1001;	  // shifts the acc n times left
	 const logic [3:0]kSHR  = 4'b1010;	  // shifts the acc n times right
	 const logic [3:0]kJMP  = 4'b1011;	  // jump, pc = pc + offset
	 const logic [3:0]kBRN  = 4'b1100;	  // branch if neg bit is on
	 const logic [3:0]kBRZ  = 4'b1101;	  // branch if zero bit is on
	 const logic [3:0]kNOT  = 4'b1110;	  // NOT, acc = ~acc	 
	 const logic [3:0]kCLR  = 4'b1111;	  // clears the alu bit flags

// enum names will appear in timing diagram
    typedef enum logic[2:0] {			  // mnemonic equivs of the above
        ADD, SUB, STR, LDR, AND, XOR,
		  MLD, MST, LDI, SHL, SHR, JMP,
		  BRN, BRZ, NOT, CLR // strictly for user convnience in timing diagram
         } op_mne;
    
endpackage // definitions
