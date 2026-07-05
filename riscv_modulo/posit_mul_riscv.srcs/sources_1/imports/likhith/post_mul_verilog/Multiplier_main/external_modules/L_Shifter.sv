// 13 bit Left Shifter
// Left Shifts X by shift amount and adds 0's to the right
module L_Shifter(input [12:0]X, input [3:0]shift , output [12:0]F);
    
    wire [12:0]Layers[4:0];
    assign Layers[0][12:0] = X[12:0] ;
    assign F = Layers[4][12:0];
  
    wire [3:0]not_shift;
    not_module #(4) not_module_shiftamt(shift,not_shift);
    genvar i,b;
    generate
        for ( b = 1 ;  b <= 4 ; b = b + 1 ) begin
            for ( i = 0 ; i < 13 ; i = i + 1 ) begin
                if ( i < 2**(b-1) )
                    and ( Layers[b][i] , not_shift[b-1] , Layers[b-1][i] );
                else 
                    mux mux_layer( Layers[b-1][i],Layers[b-1][i-2**(b-1)],shift[b-1],Layers[b][i] );
            end
        end
    endgenerate
endmodule
