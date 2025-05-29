// A few math subunits.
// The multipler can be used to implement the MUL instruction,
// and the shifter can be used to implement LSL and/or LSR.
// DO NOT USE for any other purpose.

module mult (
	input logic		[63:0]	A, B,
	input logic					doSigned,				// 1: signed multiply 0: unsigned multiply
	output logic	[63:0]	mult_low, mult_high 
	);
	
	logic signed	[63:0]	signedA, signedB;
	logic signed	[127:0]	signedResult;
	logic				[127:0]	unsignedResult;
	
	// --- Signed math ---
	always_comb begin
		signedA = A;
		signedB = B;
		signedResult = signedA * signedB;
	end
	
	// --- Unsigned math ---
	always_comb
		unsignedResult = A * B;
		
	// --- Pick the right output ---
	always_comb
		if (doSigned)
			{mult_high, mult_low} = signedResult;
		else
			{mult_high, mult_low} = unsignedResult;

endmodule

module shifter(
	input logic		[63:0]	value,
	input logic					direction, // 0: left, 1: right
	input	logic		[5:0]		distance,
	output logic	[63:0]	result
	);
	
	always_comb begin
		if (direction == 0)
			result = value << distance;
		else
			result = value >> distance;
	end
endmodule

module shifter_testbench();
	logic	[63:0]	value;
	logic				direction;
	logic [5:0]		distance;
	logic [63:0]	result;
	
	shifter dut (.value, .direction, .distance, .result);
	
	integer i, dir;
	initial begin
		value = 64'hDEADBEEFDECAFBAD;
		for(dir=0; dir<2; dir++) begin
			direction <= dir[0];
			for(i=0; i<64; i++) begin
				distance <= i; #10;
			end
		end
	end
endmodule

module mult_testbench();
	logic [63:0]	A, B;
	logic				doSigned;
	logic	[63:0]	mult_low, mult_high;
	logic	[127:0]	fullVal;
	
	mult dut (.A, .B, .doSigned, .mult_low, .mult_high);
	
	assign fullVal = {mult_high, mult_low};
	
	integer i;
	initial begin
		for(i=0; i<2; i++) begin
			doSigned <= i[0];
		
			A <=  0; B <=  0; #10;
			A <=  1; B <=  2; #10;
			A <= -1; B <=  1; #10;
			A <= -1; B <= -1; #10;
			A <= 5<<35; B <= 6<<35; #10;
		end
	end
endmodule
