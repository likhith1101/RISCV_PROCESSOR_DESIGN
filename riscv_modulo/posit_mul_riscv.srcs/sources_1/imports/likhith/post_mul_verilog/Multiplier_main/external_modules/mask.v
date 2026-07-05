// Masks bits based on mask M
module mask #(parameter SIZE=16)( input [SIZE-1:0]N , input [SIZE-1:0]m , output [SIZE-1:0]masked);
    genvar i;
    generate
        for ( i = 0 ; i < SIZE ; i = i + 1 ) begin
            xor xor1(masked[i], N[i] , m[i]);
        end
    endgenerate
endmodule
