`timescale 1ns/10ps
module decoder(RegWrite, WriteRegister, regNum);
	input logic RegWrite; 
	input logic [4:0] WriteRegister;
	output logic [31:0] regNum; 
	
	logic [3:0] regOut2_4;
	
	demux2_4 two4 (.a(WriteRegister[4]), .b(WriteRegister[3]), .enable(RegWrite), .regOut(regOut2_4)); 
	
	demux3_8 three80 (.a(WriteRegister[2]), .b(WriteRegister[1]), .c(WriteRegister[0]), .enable(regOut2_4[0]), .regOut(regNum[7:0])); 
	demux3_8 three81 (.a(WriteRegister[2]), .b(WriteRegister[1]), .c(WriteRegister[0]), .enable(regOut2_4[1]), .regOut(regNum[15:8]));
	demux3_8 three82 (.a(WriteRegister[2]), .b(WriteRegister[1]), .c(WriteRegister[0]), .enable(regOut2_4[2]), .regOut(regNum[23:16]));
	demux3_8 three83 (.a(WriteRegister[2]), .b(WriteRegister[1]), .c(WriteRegister[0]), .enable(regOut2_4[3]), .regOut(regNum[31:24]));
endmodule 