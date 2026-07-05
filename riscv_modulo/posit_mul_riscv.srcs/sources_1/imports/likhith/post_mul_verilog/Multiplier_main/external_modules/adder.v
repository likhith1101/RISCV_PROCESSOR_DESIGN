module n_bit_incrementer #(parameter N = 16) (
    input  [N-1:0] A,    // N-bit input number
    output [N-1:0] Sum  // N-bit output sum
);
    wire [N:0] carry;    // Carry bits

    // Initial carry-in is 1 since we are adding 1
    assign carry[0] = 1'b1;

    not ( Sum[0] , A[0] );
    assign carry[1] = A[0];
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : bit_adder
            xor (Sum[i], A[i], carry[i]);
            and (carry[i+1], A[i], carry[i]);
        end
    endgenerate

endmodule

module n_bit_incrementer_c #(parameter N = 16) (
    input [N-1:0] A,    // N-bit input number
    input carry_bit,
    output [N-1:0] Sum  // N-bit output sum
);
    wire [N:0] carry;    // Carry bits

    // Initial carry-in is 1 since we are adding 1
    assign carry[0] = carry_bit;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_adder
            xor (Sum[i], A[i], carry[i]);
            and (carry[i+1], A[i], carry[i]);
        end
    endgenerate

endmodule
