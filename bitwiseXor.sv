`timescale 1ns/10ps
module bitwiseXor( A, B, result) ;

input logic [63:0] A, B;
output logic [63:0] result;

generate
		genvar i;
		for (i = 0; i < 64; i = i + 1) begin : bitXor
			xor #(0.05)(result[i], A[i], B[i]); 
		end
	endgenerate
	
endmodule 