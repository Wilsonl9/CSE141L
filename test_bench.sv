// testbench for in-class demo
// CSE141L Winter 2018
module test_bench;

logic clk, reset;					 	  // to design
wire  done;							 	  // from design

top t1(.*);	                              // shorthand for .clk(clk),.reset(reset),done

always begin					          // clock generator -- arbitrarily set to 10ns period 
       clk = 1'b0;
  #5ns clk = 1'b1;
  #5ns;
end

initial begin
           t1.dm1.guts[3] = 4;			  // load incoming operands into data_mem 3 and 4
           t1.dm1.guts[4] = 6; 
           reset = 'b1;
  #20ns    reset = 'b0;					  // release reset -- start operation
  #20000ns $display("no done received");  // safety stop if no done flag generated
           $stop;						  //   regard as error condition
end

initial begin
  wait(done); 						      // watch for done flag from DUT
  #10ns $display("ops = %d %d",t1.dm1.guts[3],t1.dm1.guts[4]);
  #10ns $display("rslt = %d",t1.dm1.guts[5]); // print results to console/transcript
  #10ns $stop;
end


endmodule