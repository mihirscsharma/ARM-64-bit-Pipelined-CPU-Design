`timescale 1ns/10ps
// zero detection for a 64‑bit result
module checkforZero (
    input  wire [63:0] result,
    output wire isZero
);

    // First we OR together bit 0 and bit 1
    wire [62:0] checkZero;
    or  #(0.05) (checkZero[0], result[0], result[1]);
    // Then ripple that result through the rest of the bits
    genvar i;
    generate
      for (i = 1; i < 63; i = i + 1) begin : orCheck
        // checkZero[i] = checkZero[i‑1]  OR  result[i+1]
        or #(0.05) (checkZero[i], checkZero[i-1], result[i+1]);
      end
    endgenerate

    // If ANY bit was a 1, or_chain[62] will be 1.
    // So invert it to get isZero = 1 only when all bits are 0.
    not #(0.05) (isZero, checkZero[62]);

endmodule 