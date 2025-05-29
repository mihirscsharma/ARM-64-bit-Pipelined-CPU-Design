`timescale 1ns/10ps
module cpu(clk, reset);
	input logic clk, reset;

	logic [31:0] instr_fetched, instr_piped;
	logic [63:0] pc_out, pc_piped;
	logic reg2loc_sel, alusrc_sel, mem_to_reg, reg_wr, mem_wr;
	logic branch_taken, uncond_branch, shift_en, dir_flag, is_math, is_src_type, is_zero_br, fwd_math_flag;
	logic [1:0] fwd_reg1, fwd_reg2;
	logic [2:0] alu_ctrl;
	logic flag_neg, flag_zero, flag_ovf, flag_carry;
	logic [4:0] rd_exec, rn_read, rd_mem, rd_wb, addrB, rm_read;

	datapathPC pc_logic (
		.clk, .reset, 
		.instruction(instr_piped), 
		.pcVal(pc_out), 
		.BrTaken(branch_taken), 
		.UncondBr(uncond_branch));

	instructmem imem (
		.address(pc_out), 
		.instruction(instr_fetched), 
		.clk);

	genvar i;
	generate 
		for (i = 0; i < 32; i++) begin : pipeline_reg
			D_FF instr_ff (.q(instr_piped[i]), .d(instr_fetched[i]), .reset, .clk);
		end
	endgenerate  

	control control_unit (
		.clk, 
		.instruction(instr_piped), 
		.Reg2Loc(reg2loc_sel), .ALUsrc(alusrc_sel), .MemToReg(mem_to_reg), .RegWrite(reg_wr), .MemWrite(mem_wr), 
		.BrTaken(branch_taken), .UncondBr(uncond_branch), .ALUop(alu_ctrl), 
		.shift(shift_en), .direction(dir_flag), .math(is_math), .srcType(is_src_type), 
		.negative(flag_neg), .zero(flag_zero), .overflow(flag_ovf), .carry_out(flag_carry), 
		.fwdr1(fwd_reg1), .Rd_e(rd_exec), .Rn_r(rn_read), .Rd_m(rd_mem), .Rd_r(rd_wb), 
		.fwdr2(fwd_reg2), .Ab(addrB), .zero_br(is_zero_br), .Rm_r(rm_read), 
		.fwd_math(fwd_math_flag));

		datapath core_datapath (
		.clk(clk), .reset(reset), 
		.instruction(instr_piped), 
		.Reg2Loc(reg2loc_sel), 
		.ALUsrc(alusrc_sel), 
		.MemToReg(mem_to_reg), 
		.RegWrite(reg_wr), 
		.MemWrite(mem_wr), 
		.ALUop(alu_ctrl), 
		.shift(shift_en), 
		.direction(dir_flag), 
		.math(is_math), 
		.srcType(is_src_type), 
		.negative(flag_neg), 
		.zero(flag_zero), 
		.overflow(flag_ovf), 
		.carry_out(flag_carry), 
		.fwdr1(fwd_reg1), 
		.fwdr2(fwd_reg2), 
		.fwd_math(fwd_math_flag), 
		.zero_br(is_zero_br), 
		.rd_exe(rd_exec), 
		.rd_mem(rd_mem), 
		.rd_wb(rd_wb), 
		.rn_read(rn_read), 
		.rm_read(rm_read), 
		.regB_sel(addrB)
	);

endmodule
