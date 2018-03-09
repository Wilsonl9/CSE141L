module program_all(
  input clk,
        init,
  output logic done);

  wire[3:1] dones;

  logic[7:0] data_ram_all[256];
//  logic[1:0] rotator = 0;

// three separate DUT cores, one per program
//  you will have only one 
  program_1 pr1(.clk, .init, .done(dones[1]));
  program_2 pr2(.clk, .init, .done(dones[2]));
  program_3 pr3(.clk, .init, .done(dones[3]));

// load the data memories of the three cores
  always @(posedge clk) if(init) begin
//    if(rotator==3) rotator <= 1;
//    else           rotator <= rotator + 1;  
    for(int i=1; i<4; i++) 
	  pr1.data_ram[i] <= data_ram_all[i];
	  pr2.data_ram[6] <= data_ram_all[6];
	for(int j=32; j<96; j++)
	  pr2.data_ram[j] <= data_ram_all[j];
	for(int k=128; k<148; k++)
	  pr3.data_ram[k] <= data_ram_all[k];     
  end
    
  always_comb done = &dones;
//  assign done = dones[rotator];

endmodule