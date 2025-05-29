`timescale 1ns/10ps

module alu (
    input [63:0] A, B,
    input [2:0]  cntrl,
    output [63:0] result,
    output negative, zero, overflow, carry_out
);

    wire [63:0] B_inverted;
    wire [63:0] sum;
    wire [63:0] carry;

    wire select_addsub;
    wire initial_carry_in;

    // Wires for decoding cntrl
    wire n_cntrl0, n_cntrl1, n_cntrl2;
    wire is_000;

    wire [63:0] and_result, or_result, xor_result;

    // Invert control signals
    not #(0.05) (n_cntrl0, cntrl[0]);
    not #(0.05) (n_cntrl1, cntrl[1]);
    not #(0.05) (n_cntrl2, cntrl[2]);

    // Detect control logic
    and #(0.05) (select_addsub, n_cntrl2, cntrl[1]);
    and #(0.05) (initial_carry_in, n_cntrl2, cntrl[1], cntrl[0]);

    and #(0.05) (is_000, n_cntrl0, n_cntrl1, n_cntrl2);

    // Invert B if needed for subtraction
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin: invert_B
            xor #(0.05)(B_inverted[i], B[i], cntrl[0]);
        end
    endgenerate

    // Adder chain
    generate
        for (i = 0; i < 64; i = i + 1) begin: adder_chain
            if (i == 0) begin
                OneBitAdder adder (.A(A[i]),.B(B_inverted[i]),.carry_in(initial_carry_in),.carry_out(carry[i]),.Sum(sum[i]));
            end else begin
                OneBitAdder adder (.A(A[i]),.B(B_inverted[i]),.carry_in(carry[i-1]),.carry_out(carry[i]),.Sum(sum[i]));
            end
        end
    endgenerate

    // Bitwise operations
    bitwiseAnd doAnd (.A(A), .B(B), .result(and_result));
    bitwiseOr  doOr  (.A(A), .B(B), .result(or_result));
    bitwiseXor doXor (.A(A), .B(B), .result(xor_result));

    // One-hot control lines for 6 operations
	wire sel_b, sel_addsub, sel_and, sel_or, sel_xor, sel_zero;

	assign sel_b      =  (cntrl == 3'b000); // Output = B
	assign sel_addsub = ((cntrl == 3'b010) || (cntrl == 3'b011)); // Add or Sub
	assign sel_and    =  (cntrl == 3'b100);
	assign sel_or     =  (cntrl == 3'b101);
	assign sel_xor    =  (cntrl == 3'b110);
	assign sel_zero   =  (cntrl == 3'b111);

	generate
		 for (i = 0; i < 64; i = i + 1) begin: result_mux

			  wire mux0_out, mux1_out, mux2_out, mux3_out, mux4_out;

			  // mux2_1(sel, x, y, out) -> out = sel ? y : x;

			  mux2_1 m0 (.x(1'b0),        .y(B[i]),         .sel(sel_b),      .out(mux0_out));
			  mux2_1 m1 (.x(mux0_out),    .y(sum[i]),       .sel(sel_addsub), .out(mux1_out));
			  mux2_1 m2 (.x(mux1_out),    .y(and_result[i]),.sel(sel_and),    .out(mux2_out));
			  mux2_1 m3 (.x(mux2_out),    .y(or_result[i]), .sel(sel_or),     .out(mux3_out));
			  mux2_1 m4 (.x(mux3_out),    .y(xor_result[i]),.sel(sel_xor),    .out(mux4_out));
			  mux2_1 m5 (.x(mux4_out),    .y(1'b0),         .sel(sel_zero),   .out(result[i]));

		 end
	endgenerate


    // Status signals
    assign carry_out = carry[63];
    assign negative  = result[63];

    checkforZero check (.result(result), .isZero(zero));

    wire overflow_temp;
    xor #(0.05) overflow_xor (overflow_temp, carry[62], carry[63]);
    and #(0.05) overflow_gate (overflow, overflow_temp, select_addsub);

endmodule
