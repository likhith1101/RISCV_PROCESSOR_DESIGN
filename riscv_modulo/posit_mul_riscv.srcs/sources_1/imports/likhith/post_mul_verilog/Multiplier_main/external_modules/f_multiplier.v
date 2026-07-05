// Fractional Multiplier that uses iterative approch. Generates one parital product 
module f_multiplier #(parameter SIZE = 8 , parameter truncation = 8 )
    ( input [SIZE-1:0]X1, input [SIZE-1:0]X2, output [SIZE-1:0]res, output [SIZE-1:0]masked1, output[SIZE-1:0]masked2 );

    localparam length = $clog2(SIZE);

    wire [SIZE-1:0]l1_exp,l2_exp;
    lod #(SIZE) lod1( X1, l1_exp );
    lod #(SIZE) lod2( X2, l2_exp );

    wire [2:0]l1,l2;
    encoder_8bit encoder1 ( l1_exp , l1 );
    encoder_8bit encoder2 ( l2_exp , l2 );

    mask #(SIZE) mask1 ( X1 , l1_exp , masked1 );
    mask #(SIZE) mask2 ( X2 , l2_exp , masked2 );

    wire [SIZE-1:0]ans1,ans2;
    log_shifter_R #(3,8) shifter1 ( masked1 , l2, ans1);
    log_shifter_R #(3,8) shifter2 ( X2, l1 , ans2);

    assign res = ans1 + ans2 ;
    
endmodule
