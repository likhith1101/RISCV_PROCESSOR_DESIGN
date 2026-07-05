module log_shifter_R #(parameter N = 3, parameter t = 8)(input [t-1:0] Y, input [N-1:0] shift, output [n-1:0] F);
    localparam n = 2**N; 
    genvar i,j;
    wire [N:0][n-1:0]layer;
    assign layer[0][n-1:n-t] = Y;
    assign F = layer[N];
    wire [N-1:0]not_shift;
    generate
        for ( j = 0 ; j < N ; j = j + 1 ) begin
            not not1(not_shift[j] , shift[j] );
        end
        for ( j = 0 ; j < N ; j = j + 1 ) begin
            for ( i = 0 ; i < n ; i = i + 1 ) begin
                if ( i < 2**j ) 
                    and and1( layer[j+1][n-1-i],  layer[j][n-1-i] , not_shift[j]);
                else if ( i < 2**j + t - 1 ) 
                    mux mux1(  layer[j][n-1-i] , layer[j][n-1-i+2**j] , shift[j] , layer[j+1][n-1-i] );
                else if ( i < 2**j + t + 2**j - 1 ) 
                    and and2( layer[j+1][n-1-i],  layer[j][n-1-i+2**j] , shift[j]);
            end
        end
    endgenerate
endmodule
