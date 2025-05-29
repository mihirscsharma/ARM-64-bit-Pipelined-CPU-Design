`timescale 1ns/10ps
module datapath(
	input logic clk, reset,
	input logic [31:0] instruction,
	input logic Reg2Loc, ALUsrc, MemToReg, RegWrite, MemWrite, shift, direction, math, srcType, fwd_math,
	input logic [1:0] fwdr1, fwdr2,
	input logic [2:0] ALUop,
	output logic negative, zero, overflow, carry_out, zero_br, 
	output logic [4:0] rd_exe, rd_mem, rd_wb, rm_read,
	output logic [4:0] regB_sel, rn_read
	);
	
	logic [4:0] rd;
	logic [11:0] imm12;
	logic [5:0] shamt_raw;
	logic [8:0] imm9; 

	assign rd = instruction[4:0];
	assign rn_read = instruction[9:5]; 
	assign rm_read = instruction[20:16];  
	
	assign imm12 = instruction[21:10];
	assign imm9 = instruction[20:12]; 
	assign shamt_raw = instruction[15:10];
	
	logic [63:0] regA, regB, regW, imm_mux_out, alu_input, alu_result, mem_read, mem_mux_out, mul_out, mul_high, shift_out, math_out, alu_final_out;
	
	logic regwrite_exe, regwrite_wb; 
	logic alusrc_exe, memwrite_exe, memtoreg_exe, shift_exe, dir_exe, math_exe, fwd_math_exe; 
	logic [2:0] aluop_exe; 
	
	logic [4:0] rn_exe, rm_exe;
	logic [5:0] shamt_exe;
	
	logic [63:0] regA_exe, regB_exe, imm_exe, regW_wb;
	
	logic [63:0] fwd_regA, fwd_regB;

	genvar l;
	generate
	for (l = 0; l < 5; l++) begin : regB_mux
		mux2_1 mux_regB (.x(rd[l]), .y(rm_read[l]), .sel(Reg2Loc), .out(regB_sel[l]));
	end
	endgenerate

	regfile rf (.ReadData1(regA), .ReadData2(regB), .WriteData(regW_wb), .ReadRegister1(rn_read), .ReadRegister2(regB_sel), .WriteRegister(rd_wb), .RegWrite(regwrite_wb), .clk);

	logic [63:0] se_imm9, ze_imm12;
	assign se_imm9 = {{55{imm9[8]}}, imm9};
	assign ze_imm12 = {52'b0, imm12};

	generate
		for (l = 0; l < 64; l++) begin : imm_mux
			mux2_1 mux_imm (.x(se_imm9[l]), .y(ze_imm12[l]), .sel(srcType), .out(imm_mux_out[l]));
		end
	endgenerate

	D_FF dff1 (.q(alusrc_exe), .d(ALUsrc), .reset, .clk);
	D_FF dff2 (.q(memwrite_exe), .d(MemWrite), .reset, .clk);
	D_FF dff3 (.q(memtoreg_exe), .d(MemToReg), .reset, .clk);
	D_FF dff4 (.q(shift_exe), .d(shift), .reset, .clk);
	D_FF dff5 (.q(dir_exe), .d(direction), .reset, .clk);
	D_FF dff6 (.q(math_exe), .d(math), .reset, .clk);
	D_FF dff7 (.q(regwrite_exe), .d(RegWrite), .reset, .clk);
	D_FF dff8 (.q(fwd_math_exe), .d(fwd_math), .reset, .clk);

	generate
		for (l = 0; l < 3; l++) begin : aluop_pipe
			D_FF dff_aluop (.q(aluop_exe[l]), .d(ALUop[l]), .reset, .clk);
		end
		for (l = 0; l < 5; l++) begin : reg_pipe
			D_FF dff_rd (.q(rd_exe[l]), .d(rd[l]), .reset, .clk);
			D_FF dff_rn (.q(rn_exe[l]), .d(rn_read[l]), .reset, .clk);
			D_FF dff_rm (.q(rm_exe[l]), .d(regB_sel[l]), .reset, .clk);
		end
		for (l = 0; l < 6; l++) begin : shamt_pipe
			D_FF dff_shamt (.q(shamt_exe[l]), .d(shamt_raw[l]), .reset, .clk);
		end
		for (l = 0; l < 64; l++) begin : fwd_mux
			mux4_1 muxA (.s0(fwdr1[0]), .s1(fwdr1[1]), .i0(regA[l]), .i1(alu_final_out[l]), .i2(regW[l]), .i3(regW_wb[l]), .out(fwd_regA[l]));
			mux4_1 muxB (.s0(fwdr2[0]), .s1(fwdr2[1]), .i0(regB[l]), .i1(alu_final_out[l]), .i2(regW[l]), .i3(regW_wb[l]), .out(fwd_regB[l]));
		end
	endgenerate

	register regA_pipe (.WriteData(fwd_regA), .regEnable(1'b1), .dataOut(regA_exe), .clk);
	register regB_pipe (.WriteData(fwd_regB), .regEnable(1'b1), .dataOut(regB_exe), .clk);
	register imm_pipe (.WriteData(imm_mux_out), .regEnable(1'b1), .dataOut(imm_exe), .clk);

	checkforZero zero_check (.result(fwd_regB), .isZero(zero_br));

	assign alu_input = alusrc_exe ? imm_exe : regB_exe;
	alu alu_unit (.A(regA_exe), .B(alu_input), .cntrl(aluop_exe), .result(alu_result), .negative, .zero, .overflow, .carry_out);
	mult mult_unit (.A(regA_exe), .B(regB_exe), .doSigned(1'b1), .mult_low(mul_out), .mult_high(mul_high));
	shifter shft (.value(regA_exe), .direction(dir_exe), .distance(shamt_exe), .result(shift_out));

	generate
		for (l = 0; l < 64; l++) begin : math_sel
			mux2_1 mux_math (.x(mul_out[l]), .y(shift_out[l]), .sel(shift_exe), .out(math_out[l]));
			mux2_1 mux_final (.x(alu_result[l]), .y(math_out[l]), .sel(fwd_math_exe), .out(alu_final_out[l]));
		end
	endgenerate

	logic memwrite_mem, memtoreg_mem, regwrite_mem;
	D_FF dff_memw (.q(memwrite_mem), .d(memwrite_exe), .reset, .clk);
	D_FF dff_m2r (.q(memtoreg_mem), .d(memtoreg_exe), .reset, .clk);
	D_FF dff_regw (.q(regwrite_mem), .d(regwrite_exe), .reset, .clk);

	generate
		for (l = 0; l < 5; l++) begin : reg_pipe_mem
			D_FF dff_rd_mem (.q(rd_mem[l]), .d(rd_exe[l]), .reset, .clk);
		end
	endgenerate

	logic [63:0] regB_mem, mul_low_mem, mul_high_mem, shift_mem, alu_mem, math_mem;
	register rB_mem (.WriteData(regB_exe), .regEnable(1'b1), .dataOut(regB_mem), .clk);
	register mul_low_reg (.WriteData(mul_out), .regEnable(1'b1), .dataOut(mul_low_mem), .clk);
	register mul_high_reg (.WriteData(mul_high), .regEnable(1'b1), .dataOut(mul_high_mem), .clk);
	register shift_reg (.WriteData(shift_out), .regEnable(1'b1), .dataOut(shift_mem), .clk);
	register alu_reg (.WriteData(alu_result), .regEnable(1'b1), .dataOut(alu_mem), .clk);
	register math_reg (.WriteData(math_out), .regEnable(1'b1), .dataOut(math_mem), .clk);

	datamem dmem (.address(alu_mem), .write_enable(memwrite_mem), .read_enable(1'b1), .write_data(regB_mem), .clk, .xfer_size(4'd8), .read_data(mem_read));

	generate
		for (l = 0; l < 64; l++) begin : mem_mux
			mux2_1 mux_mem (.x(alu_mem[l]), .y(mem_read[l]), .sel(memtoreg_mem), .out(mem_mux_out[l]));
		end
	endgenerate

	generate
		for (l = 0; l < 64; l++) begin : wb_mux
			mux2_1 mux_wb (.x(mem_mux_out[l]), .y(math_mem[l]), .sel(math_exe), .out(regW[l]));
		end
	endgenerate

	D_FF dff_wr_final (.q(regwrite_wb), .d(regwrite_mem), .reset, .clk);
	generate
		for (l = 0; l < 5; l++) begin : reg_pipe_wb
			D_FF dff_rd_wb (.q(rd_wb[l]), .d(rd_mem[l]), .reset, .clk);
		end
	endgenerate

	register wb_reg (.WriteData(regW), .regEnable(1'b1), .dataOut(regW_wb), .clk);

endmodule
 