// CSE141L Winter 2018 in-class demo
// decoder block activates load and store instruction wires by
//  decoding them from opcode
import definitions::*;
module ls_dec(
  input[2:0] op,
  output logic str,
               ldr);

  always_comb str = op==kSTR;   // iff kSTR selected, str goes high
  always_comb ldr = op==kLDR;
// all other opcode cases: str=ldr=0

endmodule
  
