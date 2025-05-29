`timescale 1ns/10ps

module register(WriteData, regEnable, dataOut, clk);
	input logic regEnable, clk;
	input logic [63:0] WriteData;
	output logic [63:0] dataOut; 
	
	logic [63:0] muxout;
	logic s; 
	
//	and #(0.05) (s, regEnable, clk);
	
	genvar i; 
	
	generate 
		for (i = 0; i < 64; i++) begin : eachFlip
			mux2_1 wren (.x(dataOut[i]), .y(WriteData[i]), .sel(regEnable), .out(muxout[i]));
			D_FF flipflop (.q(dataOut[i]), .d(muxout[i]), .reset(1'b0), .clk);
		end
	endgenerate 
	
endmodule 
