import definitions::*;

module alu_tb();
  bit clk;
  logic reset = 1;

logic  [7:0]       rs_i ;	
logic  [7:0]       rt_i	;	
logic              ov_i ;	
logic  [8:0]       op_i	;	
wire   [7:0]       result_o;
wire               ov_o;
wire               alu_z_o;
wire               neg_o;

alu alu1 (
  .in_a     (rs_i     )      ,	
  .in_acc	 	(rt_i	  )	  	 ,	
  .ci     (ov_i     )      ,	
  .op	    (op_i	  )      ,	
  .acc	(result_o )	     ,
  .co     (ov_o     )      ,
  .z	(alu_z_o),
  .neg (neg_o));


  always begin
    #5ns clk = 1;
	#5ns clk = 0;
  end

  initial begin
     rs_i = 16;
	 rt_i = 24;
	 ov_i =  1;
	 op_i = SHL;
    #20ns reset = 0;
    #10ns rs_i++;
	  rt_i--;
	  ov_i = ~ov_i;
	  op_i = ADD; 
	forever begin
	  #10ns rs_i = $random;
	  rt_i = $random;
	  op_i = op_i + 1;
    end
  end

initial #5000ns $stop;
endmodule