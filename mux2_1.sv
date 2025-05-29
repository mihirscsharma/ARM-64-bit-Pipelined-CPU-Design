`timescale 1ns/10ps
//Selects between x and y based on the select signal.
module mux2_1(input logic x, y, sel, output logic out); 
	
	logic a, b, inv;
	
	not #(0.05) (inv, sel); //Invert select
	and #(0.05) (a, x, inv);	//If sel = 0, then inv = 1 and a = x, 
										//If sel = 1, then inv = 0 → a = 0
	and #(0.05) (b, y, sel); //If sel = 1, then b = y, 
										  //If sel = 0, then b = 0
	or #(0.05) (out, a, b); //Only one of them is active, so out = x or y depending on select.

endmodule 