// CSE141L Winter 2018 in-class demo
// decoder block activates load and store instruction wires by
//  decoding them from opcode
import definitions::*;
module ls_dec(
  input[3:0] op,
  output logic str,
               ldr);

  always_comb str = op==kMST;   // iff kSTR selected, str goes high
  always_comb ldr = op==kMLD;
// all other opcode cases: str=ldr=0

endmodule
  
