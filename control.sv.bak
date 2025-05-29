`timescale 1ns/10ps
module control(clk, instruction, Reg2Loc, ALUsrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUop, shift, fwd_math, direction, math, srcType, negative, zero, overflow, carry_out, fwdr1, Rd_e, Rn_r, Rd_m, Rd_r, Ab, fwdr2, zero_br, Rm_r); 
	input logic clk;
	input logic [31:0] instruction; 
	input logic negative, zero, overflow, carry_out, zero_br; 
	input logic [4:0] Rd_e, Rn_r, Rd_m, Rd_r, Ab, Rm_r;
	output logic Reg2Loc, ALUsrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, shift, direction, math, srcType, fwd_math;
	output logic [2:0] ALUop; 
	output logic [1:0] fwdr1, fwdr2;
	
	logic neg, over, zerof, carryO, s_type, s_type_del;
	logic [31:0] instruction_d;
	
	always_comb begin	
		s_type = 1'b0; 
		fwd_math = 1'b0;
		
		if(instruction[31:22] == 10'b1001000100) begin // ADDI
//			Reg2Loc <= 1'bx;
			ALUsrc = 1'b1; 
			MemToReg = 1'b0; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
			ALUop = 3'b010; // add
//			shift <= 1'bx;
//			direction <= 1'bx;
			math = 1'b0;
			srcType = 1'b1;
			
			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0))) begin
				fwdr1 = 2'b00;
			end else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b10101011000) begin // ADDS
			s_type = 1'b1; 
			Reg2Loc = 1'b1; 
			ALUsrc = 1'b0; 
			MemToReg = 1'b0; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
			ALUop = 3'b010; // add 
//			shift <= 1'bx;
//			direction <= 1'bx;
			math = 1'b0;
			srcType = 1'b0;
			
			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0))) begin
				fwdr1 = 2'b00;
			end else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
			
			// fwding Rm
			if (Rm_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr2 = 2'b00;
			else if(Rd_e == Rm_r) begin 
				fwdr2 = 2'b01; 
			end else if (Rd_m == Rm_r) begin 
				fwdr2 = 2'b10;
			end else if (Rd_r == Rm_r) begin 
				fwdr2 = 2'b11;
			end else begin 
				fwdr2 = 2'b00;
			end  
		end else if(instruction[31:26] == 6'b000101) begin // B
//			Reg2Loc <= 1'bx; 
//			ALUsrc <= 1'bx; 
//			MemToReg <= 1'bx; 
			RegWrite = 1'b0; 
			MemWrite = 1'b0; 
			BrTaken = 1'b1;
			UncondBr = 1'b1;
//			ALUop <= 3'b010;
//			shift <= 1'bx;
//			direction <= 1'bx;
//			math <= 1'bx;
//			srcType <= 1'bx;
		end else if(instruction[31:24] == 8'b01010100 && instruction[4:0] == 5'b01011) begin // B.LT
//			Reg2Loc <= 1'bx; 
//			ALUsrc <= 1'bx; 
//			MemToReg <= 1'bx; 
			RegWrite = 1'b0; 
			MemWrite = 1'b0; 
			BrTaken = s_type_del ? (negative != overflow) : (neg != over); 
			UncondBr = 1'b0;
//			ALUop <= 3'b010;
//			shift <= 1'bx;
//			direction <= 1'bx;
//			math <= 1'bx;
//			srcType <= 1'bx;
		end else if(instruction[31:24] == 8'b10110100) begin // CBZ
			Reg2Loc = 1'b0; 
			ALUsrc = 1'b0; 
//			MemToReg <= 1'bx; 
			RegWrite = 1'b0; 
			MemWrite = 1'b0; 
			BrTaken = zero_br;
			UncondBr = 1'b0;
			ALUop = 3'b000; // bypass
//			shift <= 1'bx;
//			direction <= 1'bx;
//			math <= 1'bx;
//			srcType <= 1'bx;
			
			// fwding Rm
			if(Ab == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr2 = 2'b00;
			else if(Rd_e == Ab) begin 
				fwdr2 = 2'b01; 
			end else if (Rd_m == Ab) begin 
				fwdr2 = 2'b10;
			end else if (Rd_r == Ab) begin 
				fwdr2 = 2'b11;
			end else begin 
				fwdr2 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b11111000010 && instruction[11:10] == 2'b0) begin // LDUR
//			Reg2Loc <= 1'bx; 
			ALUsrc = 1'b1; 
			MemToReg = 1'b1; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
			ALUop = 3'b010; // add
//			shift <= 1'bx;
//			direction <= 1'bx;
			math = 1'b0;
			srcType = 1'b0;
			
			// fwding Rn
			if(Rn_r == 5'd31) 
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else begin 
				fwdr1 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b11010011011 && instruction[20:16] == 5'b0) begin // LSL
			fwd_math = 1'b1;
//			Reg2Loc <= 1'bx;
//			ALUsrc <= 1'bx; 
//			MemToReg <= 1'b1; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
//			ALUop <= 3'b010; // add
			shift = 1'b1;
			direction = 1'b0;
			math = 1'b1;
//			srcType <= 1'b0;
			
			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin 
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b11010011010 && instruction[20:16] == 5'b0) begin // LSR
			fwd_math = 1'b1;
//			Reg2Loc <= 1'bx;
//			ALUsrc <= 1'bx; 
//			MemToReg <= 1'b1; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
//			ALUop <= 3'b010; // add
			shift = 1'b1;
			direction = 1'b1;
			math = 1'b1;
//			srcType <= 1'b0;

			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin 
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b10011011000 && instruction[15:10] == 6'h1F) begin // MUL
			fwd_math = 1'b1;
			Reg2Loc = 1'b1;
//			ALUsrc <= 1'bx; 
//			MemToReg <= 1'b1; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
//			ALUop <= 3'b010; // add
			shift = 1'b0;
//			direction <= 1'b0;
			math = 1'b1;
//			srcType <= 1'b0;

			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin 
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
			
			// fwding Rm
			if (Rm_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr2 = 2'b00;
			else if(Rd_e == Rm_r) begin 
				fwdr2 = 2'b01; 
			end else if (Rd_m == Rm_r) begin 
				fwdr2 = 2'b10;
			end else if (Rd_r == Rm_r) begin 
				fwdr2 = 2'b11;
			end else begin 
				fwdr2 = 2'b00;
			end  
		end else if(instruction[31:21] == 11'b11111000000 && instruction[11:10] == 2'b0) begin // STUR
			Reg2Loc = 1'b0;
			ALUsrc = 1'b1; 
//			MemToReg <= 1'b1; 
			RegWrite = 1'b0; 
			MemWrite = 1'b1; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
			ALUop = 3'b010; // add
//			shift <= 1'b1;
//			direction <= 1'b0;
			math = 1'b0;
			srcType = 1'b0;
//
			// fwding Rn
			if(Rn_r == 5'd31)
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin 
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
			
			// fwding Rm
			if(Ab == 5'd31)
				fwdr2 = 2'b00;
			else if(Rd_e == Ab) begin 
				fwdr2 = 2'b01; 
			end else if (Rd_m == Ab) begin 
				fwdr2 = 2'b10;
			end else if (Rd_r == Ab) begin 
				fwdr2 = 2'b11;
			end else begin 
				fwdr2 = 2'b00;
			end 
		end else if(instruction[31:21] == 11'b11101011000 && instruction[15:10] == 6'b0) begin // SUBS
			s_type = 1'b1; 
			Reg2Loc = 1'b1;
			ALUsrc = 1'b0; 
			MemToReg = 1'b0; 
			RegWrite = 1'b1; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
//			UncondBr <= 1'bx;
			ALUop = 3'b011; // sub
//			shift <= 1'b1;
//			direction <= 1'b0;
			math = 1'b0;
//			srcType <= 1'b0;

			// fwding Rn
			if(Rn_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr1 = 2'b00;
			else if(Rd_e == Rn_r) begin 
				fwdr1 = 2'b01; 
			end else if (Rd_m == Rn_r) begin 
				fwdr1 = 2'b10;
			end else if (Rd_r == Rn_r) begin 
				fwdr1 = 2'b11;
			end else begin 
				fwdr1 = 2'b00;
			end 
			
			// fwding Rm
			if (Rm_r == 5'd31 | ((instruction_d[31:21] == 11'b11111000000 && instruction_d[11:10] == 2'b0)))
				fwdr2 = 2'b00;
			else if(Rd_e == Rm_r) begin 
				fwdr2 = 2'b01; 
			end else if (Rd_m == Rm_r) begin 
				fwdr2 = 2'b10;
			end else if (Rd_r == Rm_r) begin 
				fwdr2 = 2'b11;
			end else begin 
				fwdr2 = 2'b00;
			end  
		end else begin 			
			Reg2Loc = 1'bx; 
			ALUsrc = 1'bx; 
			MemToReg = 1'bx; 
			RegWrite = 1'b0; 
			MemWrite = 1'b0; 
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUop = 3'bxxx; // add
			shift = 1'bx;
			direction = 1'bx;
			math = 1'bx;
			fwdr1 = 2'b00;
		end	
	end 
	
	always_ff @(posedge clk) begin 
		instruction_d <= instruction;
		s_type_del <= s_type;
	end 
	
	always_ff @(posedge clk) begin 
		if((instruction_d[31:21] == 11'b10101011000) || (instruction_d[31:21] == 11'b11101011000 && instruction_d[15:10] == 6'b0)) begin
			neg <= negative;
			over <= overflow; 
			zerof <= zero;
			carryO <= carry_out; 
		end else begin 
			neg <= neg;
			over <= over; 
			zerof <= zerof;
			carryO <= carryO; 
		end 
	end
//	always_comb begin	
//		if(s_type_del == 1'b1) begin
//			neg = negative;
//			over = overflow; 
//			zerof = zero;
//			carryO = carry_out; 
//		end else begin 
//			neg = neg;
//			over = over; 
//			zerof = zerof;
//			carryO = carryO; 
//		end 
//	end 
	
	

endmodule 