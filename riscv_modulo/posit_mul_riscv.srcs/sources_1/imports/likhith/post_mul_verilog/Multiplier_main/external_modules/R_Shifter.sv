// Signed Right Shifter
module R_Shifter(input [14:0]X, input [3:0]shift , output [14:0]F);
    
    wire [4:0][14:0]Layers;
    assign Layers[0][14:0] = X[14:0] ;
    assign F = Layers[4][14:0];
   
    genvar i,b;
    generate
        for ( b = 1 ;  b <= 4 ; b = b + 1 ) begin
            for ( i = 0 ; i < 15 ; i = i + 1 ) begin
                if ( 14-i >= 2**(b-1) )
                    mux mux_layer_first(  Layers[b-1][i], Layers[b-1][i+2**(b-1)] , shift[b-1], Layers[b][i]);
                else if ( i == 14 )
                    assign Layers[b][14] = Layers[0][14];
                else
                    mux mux_layer_second(  Layers[b-1][i], Layers[0][14] , shift[b-1], Layers[b][i]);
            end
        end
    endgenerate
endmodule
