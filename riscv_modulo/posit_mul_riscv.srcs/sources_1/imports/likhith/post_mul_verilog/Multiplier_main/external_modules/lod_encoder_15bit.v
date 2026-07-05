// 15 Bit encoder used after LoD
module lod_encoder ( input  [14:0] a, output [3:0] pos );

    assign pos[3] = |a[6:0];
    assign pos[2] = |a[2:0] | |a[10:7];
    assign pos[1] = a[0] | |a[4:3] | |a[8:7] | |a[12:11];
    assign pos[0] = a[13] | a[11] | a[9] | a[7] | a[5] | a[3] | a[1];

endmodule
