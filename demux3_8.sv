`timescale 1ns/10ps

module demux3_8(a, b, c, enable, regOut);

	input logic a, b, c, enable; 
	output logic [7:0] regOut;

	logic na, nb, nc;  	
	
	not #(0.05) (na, a); 
	not #(0.05) (nb, b); 
	not #(0.05) (nc, c); 
	
	and #(0.05) (regOut[0], na, nb, nc, enable);
	and #(0.05) (regOut[1], na, nb, c, enable);
	and #(0.05) (regOut[2], na, b, nc, enable);
	and #(0.05) (regOut[3], na, b, c, enable);
	and #(0.05) (regOut[4], a, nb, nc, enable);
	and #(0.05) (regOut[5], a, nb, c, enable);
	and #(0.05) (regOut[6], a, b, nc, enable);
	and #(0.05) (regOut[7], a, b, c, enable);

endmodule 