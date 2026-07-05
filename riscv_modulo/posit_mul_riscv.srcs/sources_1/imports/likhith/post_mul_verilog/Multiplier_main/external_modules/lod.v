// Keeps Leading one from the left as 1 and all other bits 0
module lod #( parameter SIZE = 15  ) ( input [SIZE-1:0] a , output [SIZE-1:0] out );
    wire [SIZE-2:0]and2_in1;
    assign out[SIZE-1] = a[SIZE-1];
    wire [SIZE-1:0]not_a ;
    not_module #(SIZE-1) not_a_module ( a[SIZE-1:1] , not_a[SIZE-1:1] );

    genvar i;
    generate 
        for ( i = 0; i < SIZE - 1 ; i = i + 1 ) begin
            and (out[i],and2_in1[i],a[i]);
        end
    endgenerate

    assign and2_in1[SIZE-2] = not_a[SIZE-1];
    generate 
        for ( i = 0 ; i < SIZE - 2 ; i = i + 1 ) begin
            and ( and2_in1[i] , and2_in1[i+1], not_a[i+1] );
        end
    endgenerate
endmodule
