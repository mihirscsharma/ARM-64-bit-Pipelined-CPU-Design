`timescale 1ns/10ps
module control(
	input  logic clk,
	input  logic [31:0] instruction, 
	input  logic negative, zero, overflow, carry_out, zero_br, 
	input  logic [4:0] Rd_e, Rn_r, Rd_m, Rd_r, Ab, Rm_r,
	output logic Reg2Loc, ALUsrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, shift, direction, math, srcType, fwd_math,
	output logic [2:0] ALUop, 
	output logic [1:0] fwdr1, fwdr2
);

	logic latched_neg, latched_ovf, latched_zero, latched_carry;
	logic is_s_type, delayed_s_type;
	logic [31:0] delayed_instr;

	always_comb begin
		is_s_type = 1'b0;
		fwd_math = 1'b0;

		if (instruction[31:22] == 10'b1001000100) begin // ADDI
			ALUsrc = 1'b1; 
			MemToReg = 1'b0; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
			ALUop = 3'b010;
			math = 1'b0;
			srcType = 1'b1;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

		end else if (instruction[31:21] == 11'b10101011000) begin // ADDS
			is_s_type = 1'b1;
			Reg2Loc = 1'b1;
			ALUsrc = 1'b0; 
			MemToReg = 1'b0; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
			ALUop = 3'b010;
			math = 1'b0;
			srcType = 1'b0;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

			if (Rm_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr2 = 2'b00;
			else if (Rd_e == Rm_r) fwdr2 = 2'b01;
			else if (Rd_m == Rm_r) fwdr2 = 2'b10;
			else if (Rd_r == Rm_r) fwdr2 = 2'b11;
			else fwdr2 = 2'b00;

		end else if (instruction[31:26] == 6'b000101) begin // B
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;

		end else if (instruction[31:24] == 8'b01010100 && instruction[4:0] == 5'b01011) begin // B.LT
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = delayed_s_type ? (negative != overflow) : (latched_neg != latched_ovf);
			UncondBr = 1'b0;

		end else if (instruction[31:24] == 8'b10110100) begin // CBZ
			Reg2Loc = 1'b0;
			ALUsrc = 1'b0;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = zero_br;
			UncondBr = 1'b0;
			ALUop = 3'b000;

			if (Ab == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr2 = 2'b00;
			else if (Rd_e == Ab) fwdr2 = 2'b01;
			else if (Rd_m == Ab) fwdr2 = 2'b10;
			else if (Rd_r == Ab) fwdr2 = 2'b11;
			else fwdr2 = 2'b00;

		end else if (instruction[31:21] == 11'b11111000010 && instruction[11:10] == 2'b0) begin // LDUR
			ALUsrc = 1'b1;
			MemToReg = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			ALUop = 3'b010;
			math = 1'b0;
			srcType = 1'b0;

			if (Rn_r == 5'd31) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else fwdr1 = 2'b00;

		end else if (instruction[31:21] == 11'b11010011011 && instruction[20:16] == 5'b0) begin // LSL
			fwd_math = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			shift = 1'b1;
			direction = 1'b0;
			math = 1'b1;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

		end else if (instruction[31:21] == 11'b11010011010 && instruction[20:16] == 5'b0) begin // LSR
			fwd_math = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			shift = 1'b1;
			direction = 1'b1;
			math = 1'b1;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

		end else if (instruction[31:21] == 11'b10011011000 && instruction[15:10] == 6'h1F) begin // MUL
			fwd_math = 1'b1;
			Reg2Loc = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			shift = 1'b0;
			math = 1'b1;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

			if (Rm_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr2 = 2'b00;
			else if (Rd_e == Rm_r) fwdr2 = 2'b01;
			else if (Rd_m == Rm_r) fwdr2 = 2'b10;
			else if (Rd_r == Rm_r) fwdr2 = 2'b11;
			else fwdr2 = 2'b00;

		end else if (instruction[31:21] == 11'b11111000000 && instruction[11:10] == 2'b0) begin // STUR
			Reg2Loc = 1'b0;
			ALUsrc = 1'b1;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			BrTaken = 1'b0;
			ALUop = 3'b010;
			math = 1'b0;
			srcType = 1'b0;

			if (Rn_r == 5'd31) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

			if (Ab == 5'd31) fwdr2 = 2'b00;
			else if (Rd_e == Ab) fwdr2 = 2'b01;
			else if (Rd_m == Ab) fwdr2 = 2'b10;
			else if (Rd_r == Ab) fwdr2 = 2'b11;
			else fwdr2 = 2'b00;

		end else if (instruction[31:21] == 11'b11101011000 && instruction[15:10] == 6'b0) begin // SUBS
			is_s_type = 1'b1;
			Reg2Loc = 1'b1;
			ALUsrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			ALUop = 3'b011;
			math = 1'b0;

			if (Rn_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr1 = 2'b00;
			else if (Rd_e == Rn_r) fwdr1 = 2'b01;
			else if (Rd_m == Rn_r) fwdr1 = 2'b10;
			else if (Rd_r == Rn_r) fwdr1 = 2'b11;
			else fwdr1 = 2'b00;

			if (Rm_r == 5'd31 || (delayed_instr[31:21] == 11'b11111000000 && delayed_instr[11:10] == 2'b0)) fwdr2 = 2'b00;
			else if (Rd_e == Rm_r) fwdr2 = 2'b01;
			else if (Rd_m == Rm_r) fwdr2 = 2'b10;
			else if (Rd_r == Rm_r) fwdr2 = 2'b11;
			else fwdr2 = 2'b00;

		end else begin
			Reg2Loc = 1'bx;
			ALUsrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUop = 3'bxxx;
			shift = 1'bx;
			direction = 1'bx;
			math = 1'bx;
			fwdr1 = 2'b00;
		end
	end

	always_ff @(posedge clk) begin
		delayed_instr <= instruction;
		delayed_s_type <= is_s_type;
	end

	always_ff @(posedge clk) begin
		if ((delayed_instr[31:21] == 11'b10101011000) || (delayed_instr[31:21] == 11'b11101011000 && delayed_instr[15:10] == 6'b0)) begin
			latched_neg <= negative;
			latched_ovf <= overflow;
			latched_zero <= zero;
			latched_carry <= carry_out;
		end
	end

endmodule
