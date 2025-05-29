`timescale 1ns/10ps
module mux4_1(s0, s1, i0, i1, i2, i3, out); 
	input logic s0, s1, i0, i1, i2, i3; 
	output logic out; 
	
	logic k0, k1, a0, a1, a2, a3; 
	
	not #(0.05) (k0, s0); 
	not #(0.05) (k1, s1); 
	
	and #(0.05) (a0, k1, k0, i0);
	and #(0.05) (a1, k1, s0, i1);
	and #(0.05) (a2, s1, k0, i2);
	and #(0.05) (a3, s1, s0, i3);
	
	or #(0.05) (out, a0, a1, a2, a3); 
endmodule 