`timescale 1ns/10ps
//Selects 1 out of 32 input bits based on a 5-bit selector 'ch'
module mux32_1(input logic [31:0]x, input logic[4:0]ch, output logic xout);
	//32-bit input vector: x
	// 5-bit select signal to choose which input to route to the output: ch 
	
	 logic [1:0] two;       // Output of 2 muxes in level 4 (4 -> 2)
	 logic [3:0] four;      // Output of 4 muxes in level 3 (8 -> 4)
	 logic [15:0] sixteen;  // Output of 16 muxes in level 1 (32 -> 16)
    logic [7:0] eight;     // Output of 8 muxes in level 2 (16 -> 8)
 
	
	genvar p; 
	 //layers of 2 to 1 muxes to narrow 32 inputs to 1
	 //five levels because 2^5 = 64
	generate 
	
		for(p = 0; p < 32; p += 2) begin : levelone
		  mux2_1 levelo (.x(x[p]), .y(x[p + 1]), .sel(ch[0]), .out(sixteen[p / 2]));
		end
		for(p = 0; p < 16; p += 2) begin : leveltwo
		  mux2_1 levelt (.x(sixteen[p]), .y(sixteen[p + 1]), .sel(ch[1]), .out(eight[p / 2]));
		end
		for(p = 0; p < 8; p += 2) begin : levelthree
		  mux2_1 levelth (.x(eight[p]), .y(eight[p + 1]), .sel(ch[2]), .out(four[p / 2]));
		end
		for(p = 0; p < 4; p += 2) begin : levelfour
		  mux2_1 levelf (.x(four[p]), .y(four[p + 1]), .sel(ch[3]), .out(two[p / 2]));
		end
		// Select bit: s[4]
		//level five
		mux2_1 levelfi (.x(two[0]), .y(two[1]), .sel(ch[4]), .out(xout));
	endgenerate 
endmodule 