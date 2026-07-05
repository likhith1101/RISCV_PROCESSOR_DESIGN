// Accepts the two 11 bit Mantissas and outputs resultant mantissa and carry that needs to be added to exponent in case the multiplication is > 2
module PLAM ( input [10:0]fa,  input [10:0]fb,  output [10:0]result ,output exp_carry);

    // Generates First partial product. Tries to approximate fa * fb and also returns fa1 and fb1 ( fa and fb with leading bit bit masked ) 
    wire [7:0]fa1,fb1,pp1;
    f_multiplier #(8,8) m1( fa[10:3] , fb[10:3] , pp1 , fa1 , fb1 );
    
    // Generates First partial product. Tries to approximate fa1 * fb1 and also returns fa2 and fb2 ( fa1 and fb1 with leading bit bit masked ) 
    wire [7:0]fa2,fb2,pp2;
    f_multiplier #(8,8) m2( fa1 , fb1 , pp2 , fa2, fb2);

    wire [10:0]sum_of_all_pp;
    wire [1:0]extra;

    // Sum of partial Products is generated and padded with 3 0's on the right as it is of length 8 and not 11
    wire [7:0]pp_sum = pp1 + pp2 ;
    assign {extra , sum_of_all_pp } = {1'b1,fa} + fb + { pp_sum , 3'b0};

    // Checks if exponent carry exists and shifts fractional bit accordingly
    assign exp_carry = extra[1];
    mux_nbit #(11) mux_final ( sum_of_all_pp, {extra[0],sum_of_all_pp[10:1]} , extra[1], result );
    
endmodule
