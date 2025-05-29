`timescale 1ns/10ps
module demux2_4(a, b, enable, regOut);
	input logic a, b, enable; 
	output logic [3:0] regOut;

	logic na, nb; 
	
	not #(0.05) (na, a);
	not #(0.05) (nb, b);

	and #(0.05) (regOut[0], na, nb, enable);
	and #(0.05) (regOut[1], na, b, enable);
	and #(0.05) (regOut[2], a, nb, enable);
	and #(0.05) (regOut[3], a, b, enable);
	
endmodule 