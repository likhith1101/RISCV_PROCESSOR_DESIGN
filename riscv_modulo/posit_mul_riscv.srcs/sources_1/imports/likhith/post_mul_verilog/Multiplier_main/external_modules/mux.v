module mux( input a , input b , input s ,  output o);
    wire not_s;
    wire a_and_not_s;
    wire b_and_s;

    not (not_s, s);

    and (a_and_not_s, a, not_s);
    and (b_and_s, b, s);

    or (o, a_and_not_s, b_and_s);
endmodule

module mux_nbit #( parameter N = 16  ) ( input [N-1:0]A , input [N-1:0]B , input S , output [N-1:0]O );
    // If S == 0 ; A ; elif S == 1 ; B;
    genvar i;
    generate
        for ( i = 0 ; i < N ; i = i + 1 ) begin
            mux mux1( A[i] , B[i] , S , O[i] ) ;
        end
    endgenerate
endmodule

