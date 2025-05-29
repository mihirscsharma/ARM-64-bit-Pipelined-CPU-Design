`timescale 1ns/10ps
module mux4_1(s0, s1, i0, i1, i2, i3, out); 
	input logic s0, s1, i0, i1, i2, i3; 
	output logic out; 
	
	logic ns0, ns1, a0, a1, a2, a3; 
	
	not #(0.05) (ns0, s0); 
	not #(0.05) (ns1, s1); 
	
	and #(0.05) (a0, ns1, ns0, i0);
	and #(0.05) (a1, ns1, s0, i1);
	and #(0.05) (a2, s1, ns0, i2);
	and #(0.05) (a3, s1, s0, i3);
	
	or #(0.05) (out, a0, a1, a2, a3); 
endmodule 