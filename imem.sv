// CSE141L Winter 2018  
// in class demo -- instruction memory ROM
// This is the case statement (if ... else if ... else if ...) version;
//   good for small lookup tables and arrays, awkward for larger ones, perhaps
module imem(
  input       [7:0] PC,      // program counter = pointer to imem
  output logic[8:0] inst);	 // machine code values (yours are 9 bits; my demo is only 7)
  always_comb case(PC)
    0: inst = 'b001_00_00;   // CLR R0  //R0=0  
    1: inst = 'b001_11_00;   // CLR R3  //R3=0
    2: inst = 'b000_01_00;   // LDR R1, 3  (LUTm[0] = 3)  R1 = mem[3]
    3: inst = 'b000_10_01;   // LDR R2, 4  (LUTm[1] = 4)  R2 = mem[4]
    4: inst = 'b010_00_01;   // ACC R0, R1                R0 = R0 + R1  
    5: inst = 'b011_10_01;   // ACI R2, -1 (LUTi[1] = -1) R2 = R2 - 1
    6: inst = 'b101_10_01;   // BZA R2, 8  (LUTp[1] =  8) PC = 8 if R2=0
    7: inst = 'b100_11_10;   // BZR R3, -3 (LUTp[2] = -3) PC = PC-3 if R3=0 
    8: inst = 'b110_00_10;   // STR R0, 5  (LUTm[2] =  5) mem[5] = R0
    9: inst = 'b111_11_11;   // halt
	default: inst = 'b111_11_11; // covers all cases not included in the above list
  endcase
endmodule