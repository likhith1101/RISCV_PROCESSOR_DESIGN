module twoscompliment #(parameter N = 15 )( input [N-1:0]A , input compliment , output [N-1:0]Out );
  wire [N-1:0]xor_A;
  xor_module #(N) xor_module_A ( A,compliment , xor_A );
  n_bit_incrementer_c #(N) compiment_adder ( xor_A , compliment, Out);
endmodule

