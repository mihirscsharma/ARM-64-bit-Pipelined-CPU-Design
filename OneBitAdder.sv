`timescale 1ns/10ps
module OneBitAdder(A, B, carry_in, carry_out, Sum) ;

input A, B, carry_in;
output Sum, carry_out;

wire temp1, temp2, temp3;

xor #(0.05) (temp1, A,B);
xor #(0.05) (Sum, temp1, carry_in);
and #(0.05) (temp2, A, B);
and #(0.05) (temp3, temp1, carry_in);
or #(0.05) (carry_out, temp2, temp3);

endmodule 