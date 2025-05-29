`timescale 1ns/10ps
module regfile(ReadData1, ReadData2, WriteData, 
					 ReadRegister1, ReadRegister2, WriteRegister,
					 RegWrite, clk); 
					 
	output logic [63:0] ReadData1, ReadData2; 
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	
	logic [31:0] regNum; 
	logic [31:0][63:0] dataOutGrid;
	logic [63:0][31:0] dataInGrid;
	
//	logic [63:0] totalOut;
	
	decoder decode (.RegWrite, .WriteRegister, .regNum);
	
	genvar i, n;

	generate	
		for (i = 0; i < 31; i++) begin : eachReg
			register Reg (.WriteData, .regEnable(regNum[i]), .dataOut(dataOutGrid[i]), .clk); 
		end
	endgenerate
	
	register Reg31 (.WriteData(64'b0), .regEnable(1'b1), .dataOut(dataOutGrid[31]), .clk);
	
	genvar j, k; 
	generate
		for (j = 0; j < 32; j++) begin : eachrow
			for (k = 0; k < 64; k++) begin : eachcol
				assign dataInGrid[63 - k][j] = dataOutGrid[j][k];
			end 
		end 
	endgenerate
	
	generate 
	for(n = 0; n < 64; n++) begin : each32mux
		mux32_1 read1 (
			.x(dataInGrid[n]),       // 32-bit input
			.ch(ReadRegister1),      // 5-bit selector
			.xout(ReadData1[63 - n]) // 1-bit output
		); 

		mux32_1 read2 (
			.x(dataInGrid[n]),
			.ch(ReadRegister2),
			.xout(ReadData2[63 - n])
		); 
	end 
endgenerate

	
endmodule
