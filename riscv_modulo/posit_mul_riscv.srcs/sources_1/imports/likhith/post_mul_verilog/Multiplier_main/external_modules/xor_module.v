module xor_module  #( parameter N = 15 ) ( input [N-1:0]A , input Xor_in, output [N-1:0]B );
  genvar i;
  generate 
    for ( i = 0 ; i < N ; i = i + 1 )
      xor ( B[i] , A[i] , Xor_in );
  endgenerate
endmodule
