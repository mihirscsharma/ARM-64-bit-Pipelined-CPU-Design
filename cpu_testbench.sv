`timescale 1ns/10ps
module cpu_testbench(); 
	logic clk, reset; 
	
	parameter ClockDelay = 20000;
	
	cpu dut (.clk, .reset); 
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	integer i;
	
	initial begin 
		reset <= 1; @(posedge clk); 
		reset <= 0; @(posedge clk); 
		
		for(i = 0; i < 1000; i++) begin 
			@(posedge clk); 
		end 
		
		$stop;
	end
endmodule 