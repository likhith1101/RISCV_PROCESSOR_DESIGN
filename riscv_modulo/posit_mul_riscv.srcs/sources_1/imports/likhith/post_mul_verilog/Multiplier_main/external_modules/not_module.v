module not_module  #( parameter N = 15 ) ( input [N-1:0]A , output [N-1:0]B );
  genvar i;
  generate 
    for ( i = 0 ; i < N ; i = i + 1 )
      not ( B[i] , A[i] );
  endgenerate
endmodule
