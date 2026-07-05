module encoder_8bit ( input  [7:0] a, output [2:0] pos );

    //for right most bit as 0
    wire [2:0]pos_temp;
    assign pos_temp[2] = |a[4:1] ;
    assign pos_temp[1] = |a[6:5] | |a[2:1] ;
    assign pos_temp[0] = a[7] | a[5] | a[3] | a[1] ;

    wire none = (~pos_temp[2]) & (~pos_temp[1]) & (~pos_temp[0]) ;

    assign pos[2] = none | pos_temp[2];
    assign pos[1] = none | pos_temp[1];
    assign pos[0] = none | pos_temp[0];

endmodule
