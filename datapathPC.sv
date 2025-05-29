`timescale 1ns/10ps
module datapathPC(clk, reset, instruction, pcVal, BrTaken, UncondBr); 
	input clk, reset, BrTaken, UncondBr;
	input [31:0] instruction;
	output [63:0] pcVal;

	logic [63:0] pc_next, branch_offset, pc_branch_target, pc_plus_4, pc_stored;
	logic neg_br, zero_br, ovf_br, carry_br;
	logic neg_4, zero_4, ovf_4, carry_4;

	// Immediate extraction and sign-extension
	logic [63:0] sign_ext_btype, sign_ext_utype;
	assign sign_ext_btype = {{45{instruction[23]}}, instruction[23:5]};
	assign sign_ext_utype = {{38{instruction[25]}}, instruction[25:0]};

	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : mux_branch_offset
			mux2_1 mux_inst (.x(sign_ext_btype[i]), .y(sign_ext_utype[i]), .sel(UncondBr), .out(branch_offset[i]));
		end
	endgenerate

	// Store current PC value
	register pc_register (.WriteData(pcVal), .clk, .regEnable(1'b1), .dataOut(pc_stored));

	// Compute PC + branch offset
	alu add_branch (
		.A(pc_stored), 
		.B({branch_offset[61:0], 2'b00}), 
		.cntrl(3'b010), 
		.result(pc_branch_target), 
		.negative(neg_br), 
		.zero(zero_br), 
		.overflow(ovf_br), 
		.carry_out(carry_br));

	// Compute PC + 4
	alu add_four (
		.A(pcVal), 
		.B(64'd4), 
		.cntrl(3'b010), 
		.result(pc_plus_4), 
		.negative(neg_4), 
		.zero(zero_4), 
		.overflow(ovf_4), 
		.carry_out(carry_4));

	// Mux to select next PC
	genvar k;
	generate
		for (k = 0; k < 64; k++) begin : pc_mux
			mux2_1 pc_sel (.x(pc_plus_4[k]), .y(pc_branch_target[k]), .sel(BrTaken), .out(pc_next[k]));
		end
	endgenerate

	// Store next PC
	genvar j;
	generate 
		for (j = 0; j < 64; j++) begin : pc_pipeline
			D_FF pc_flip (.q(pcVal[j]), .d(pc_next[j]), .reset, .clk);
		end
	endgenerate
endmodule
