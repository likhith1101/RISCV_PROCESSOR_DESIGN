`timescale 1ns / 1ps


//module mod_mult_clk(input [15:0]opd_a , input [15:0]opd_b,output [15:0] product);
//    wire sign_a,sign_b,sign_c;
//    xor ( sign_c,sign_a,sign_b );
//    wire [7:0] reg_ep_a,reg_ep_b;
//    wire [7:0]reg_ep_c;
//    assign reg_ep_a[7] = reg_ep_a[6];
//    assign reg_ep_b[7] = reg_ep_b[6];
//    wire [10:0] frac_opd_a,frac_opd_b,frac_opd_c;
//    wire exp1;
//    decoder decoder_A( opd_a , sign_a , reg_ep_a[6:0] , frac_opd_a );
//    decoder decoder_B( opd_b , sign_b , reg_ep_b[6:0] , frac_opd_b );
//    PLAM Posit_fact_multiplier( frac_opd_a ,  frac_opd_b,  frac_opd_c , exp1 );

//    assign reg_ep_c = reg_ep_a + reg_ep_b + exp1 ;
//    encoder encoder_Out( reg_ep_c , frac_opd_c , sign_c , product);
//endmodule


//// for classic
module mod_mult_clk  (
    input  [15:0] x,
    input  [15:0] y,
    input  [15:0] M,
    output reg [15:0] result
);

    // Parameters
    parameter mu=3050;
    parameter N = 12;
    parameter m = 4;
    parameter r = 16;   // 2^m
    parameter d = 5;

    // ----------------------------------------------------------------
    // Extract y digits (combinational, no clock needed)
    // y_parts[2] = y[0], y_parts[3] = y[1], y_parts[4] = y[2]
    // y_parts[0] = y(-2) = 0, y_parts[1] = y(-1) = 0
    // ----------------------------------------------------------------
    wire [3:0] yp0 = 4'd0;          // y(-2)
    wire [3:0] yp1 = 4'd0;          // y(-1)
    wire [3:0] yp2 = y[3:0];        // y(0)
    wire [3:0] yp3 = y[7:4];        // y(1)
    wire [3:0] yp4 = y[11:8];       // y(2)

    // ----------------------------------------------------------------
    // Initial Z[5] = 0, q[5] = 0  (pipeline seed)
    // ----------------------------------------------------------------
    wire signed [31:0] Z5 = 32'sd0;
    wire signed [31:0] q5 = 32'sd0;

    // ----------------------------------------------------------------
    // STEP 2  (was state STEP2, index 5->4)
    // ----------------------------------------------------------------
    wire signed [31:0] temp1_s2;
    wire signed [31:0] g_s2;
    wire signed [31:0] q4;
    wire signed [31:0] Z4;

    assign temp1_s2 = Z5 >>> (N - 3);                          // Z[5] >>> 9
    assign g_s2     = ((temp1_s2 * $signed(mu)) + 32'sd8192) >>> 14;
    assign q4       = g_s2 - (q5 * $signed(r));
    assign Z4       = ((Z5 - q5 * $signed(M) * $signed(r)) * $signed(r))
                      + $signed(x) * $signed({28'd0, yp4});

    // ----------------------------------------------------------------
    // STEP 1  (index 4->3)
    // ----------------------------------------------------------------
    wire signed [31:0] temp1_s1;
    wire signed [31:0] g_s1;
    wire signed [31:0] q3;
    wire signed [31:0] Z3;

    assign temp1_s1 = Z4 >>> (N - 3);
    assign g_s1     = ((temp1_s1 * $signed(mu)) + 32'sd8192) >>> 14;
    assign q3       = g_s1 - (q4 * $signed(r));
    assign Z3       = ((Z4 - q4 * $signed(M) * $signed(r)) * $signed(r))
                      + $signed(x) * $signed({28'd0, yp3});

    // ----------------------------------------------------------------
    // STEP 0  (index 3->2)
    // ----------------------------------------------------------------
    wire signed [31:0] temp1_s0;
    wire signed [31:0] g_s0;
    wire signed [31:0] q2;
    wire signed [31:0] Z2;

    assign temp1_s0 = Z3 >>> (N - 3);
    assign g_s0     = ((temp1_s0 * $signed(mu)) + 32'sd8192) >>> 14;
    assign q2       = g_s0 - (q3 * $signed(r));
    assign Z2       = ((Z3 - q3 * $signed(M) * $signed(r)) * $signed(r))
                      + $signed(x) * $signed({28'd0, yp2});

    // ----------------------------------------------------------------
    // STEP -1  (index 2->1, y(-1)=0 so no x*y term)
    // ----------------------------------------------------------------
    wire signed [31:0] temp1_sn1;
    wire signed [31:0] g_sn1;
    wire signed [31:0] q1;
    wire signed [31:0] Z1;

    assign temp1_sn1 = Z2 >>> (N - 3);
    assign g_sn1     = ((temp1_sn1 * $signed(mu)) + 32'sd8192) >>> 14;
    assign q1        = g_sn1 - (q2 * $signed(r));
    assign Z1        = (Z2 - q2 * $signed(M) * $signed(r)) * $signed(r);
    // y(-1) = 0, so no "+ x * yp1" term

    // ----------------------------------------------------------------
    // STEP -2  (index 1->0, y(-2)=0 so no x*y term)
    // ----------------------------------------------------------------
    wire signed [31:0] temp1_sn2;
    wire signed [31:0] g_sn2;
    wire signed [31:0] q0;
    wire signed [31:0] Z0;

    assign temp1_sn2 = Z1 >>> (N - 3);
    assign g_sn2     = ((temp1_sn2 * $signed(mu)) + 32'sd8192) >>> 14;
    assign q0        = g_sn2 - (q1 * $signed(r));
    assign Z0        = (Z1 - q1 * $signed(M) * $signed(r)) * $signed(r);
    // y(-2) = 0, so no "+ x * yp0" term

    // ----------------------------------------------------------------
    // FINAL - divide by r^2 (= >>8 for r=16) and correct if negative
    // ----------------------------------------------------------------
    wire signed [31:0] Z0_scaled;
    assign Z0_scaled = Z0 >>> (2 * m);   // divide by r^2 = 256 = >>8

    always @(*) begin
        if (Z0_scaled < 32'sd0)
            result = Z0_scaled[15:0] + M;
        else
            result = Z0_scaled[15:0];
    end

endmodule



// FOR BASIC

//module mod_mult_clk  (
//    input  [15:0] x,
//    input  [15:0] y,
//    input  [15:0] M,
//    output reg [15:0] result
//);

//    // Parameters
//    parameter N = 12;
//    parameter m = 4;
//    parameter r = 16;   // 2^m
//    parameter d = 5;
//    parameter mu = 3050;

//    // ----------------------------------------------------------------
//    // Extract Y digits (combinational, no clock needed)
//    // Y_parts[2] = Y[0], Y_parts[3] = Y[1], Y_parts[4] = Y[2]
//    // Y_parts[0] = Y(-2) = 0, Y_parts[1] = Y(-1) = 0
//    // ----------------------------------------------------------------
//    wire [3:0] Yp0 = 4'd0;          // Y(-2)
//    wire [3:0] Yp1 = 4'd0;          // Y(-1)
//    wire [3:0] Yp2 = y[3:0];        // Y(0)
//    wire [3:0] Yp3 = y[7:4];        // Y(1)
//    wire [3:0] Yp4 = y[11:8];       // Y(2)

//    // ----------------------------------------------------------------
//    // Initial Z[5] = 0, q[5] = 0  (pipeline seed)
//    // ----------------------------------------------------------------
//    wire signed [31:0] Z5 = 32'sd0;
//    wire signed [31:0] q5 = 32'sd0;

//    // ----------------------------------------------------------------
//    // STEP 2  (was state STEP2, index 5->4)
//    // ----------------------------------------------------------------
//    wire signed [31:0] temp1_s2;
//    wire signed [31:0] g_s2;
//    wire signed [31:0] q4;
//    wire signed [31:0] Z4;

//    assign temp1_s2 = Z5 >>> (N - 3);                          // Z[5] >>> 9
//    assign g_s2     = ((temp1_s2 * $signed(mu)) + 32'sd8192) >>> 14;
//    assign q4       = g_s2 - (q5 * $signed(r));
//    assign Z4       = ((Z5 - q5 * $signed(M) * $signed(r)) * $signed(r))
//                      + $signed(x) * $signed({28'd0, Yp4});

//    // ----------------------------------------------------------------
//    // STEP 1  (index 4->3)
//    // ----------------------------------------------------------------
//    wire signed [31:0] temp1_s1;
//    wire signed [31:0] g_s1;
//    wire signed [31:0] q3;
//    wire signed [31:0] Z3;

//    assign temp1_s1 = Z4 >>> (N - 3);
//    assign g_s1     = ((temp1_s1 * $signed(mu)) + 32'sd8192) >>> 14;
//    assign q3       = g_s1 - (q4 * $signed(r));
//    assign Z3       = ((Z4 - q4 * $signed(M) * $signed(r)) * $signed(r))
//                      + $signed(x) * $signed({28'd0, Yp3});

//    // ----------------------------------------------------------------
//    // STEP 0  (index 3->2)
//    // ----------------------------------------------------------------
//    wire signed [31:0] temp1_s0;
//    wire signed [31:0] g_s0;
//    wire signed [31:0] q2;
//    wire signed [31:0] Z2;

//    assign temp1_s0 = Z3 >>> (N - 3);
//    assign g_s0     = ((temp1_s0 * $signed(mu)) + 32'sd8192) >>> 14;
//    assign q2       = g_s0 - (q3 * $signed(r));
//    assign Z2       = ((Z3 - q3 * $signed(M) * $signed(r)) * $signed(r))
//                      + $signed(x) * $signed({28'd0, Yp2});

//    // ----------------------------------------------------------------
//    // STEP -1  (index 2->1, Y(-1)=0 so no X*Y term)
//    // ----------------------------------------------------------------
//    wire signed [31:0] temp1_sn1;
//    wire signed [31:0] g_sn1;
//    wire signed [31:0] q1;
//    wire signed [31:0] Z1;

//    assign temp1_sn1 = Z2 >>> (N - 3);
//    assign g_sn1     = ((temp1_sn1 * $signed(mu)) + 32'sd8192) >>> 14;
//    assign q1        = g_sn1 - (q2 * $signed(r));
//    assign Z1        = (Z2 - q2 * $signed(M) * $signed(r)) * $signed(r);
//    // Y(-1) = 0, so no "+ X * Yp1" term

//    // ----------------------------------------------------------------
//    // STEP -2  (index 1->0, Y(-2)=0 so no X*Y term)
//    // ----------------------------------------------------------------
//    wire signed [31:0] temp1_sn2;
//    wire signed [31:0] g_sn2;
//    wire signed [31:0] q0;
//    wire signed [31:0] Z0;

//    assign temp1_sn2 = Z1 >>> (N - 3);
//    assign g_sn2     = ((temp1_sn2 * $signed(mu)) + 32'sd8192) >>> 14;
//    assign q0        = g_sn2 - (q1 * $signed(r));
//    assign Z0        = (Z1 - q1 * $signed(M) * $signed(r)) * $signed(r);
//    // Y(-2) = 0, so no "+ X * Yp0" term

//    // ----------------------------------------------------------------
//    // FINAL - divide by r^2 (= >>8 for r=16) and correct if negative
//    // ----------------------------------------------------------------
//    wire signed [31:0] Z0_scaled;
//    assign Z0_scaled = Z0 >>> (2 * m);   // divide by r^2 = 256 = >>8

//    always @(*) begin
//        if (Z0_scaled < 32'sd0)
//            result = Z0_scaled[15:0] + M;
//        else
//            result = Z0_scaled[15:0];
//    end

//endmodule







//module mod_mult_clk (
//    input [15:0] x,
//    input [15:0] y,
//    input [31:0] M,
//    output reg [31:0] result
//);

//    reg [31:0] mult;

//    always @(*) begin
//        // Stage 1: Multiply
//        mult = x * y;

//        // Stage 2 + 3: Direct modulo
//        if (M != 0)
//            result = mult % M;
//        else
//            result = 32'd0;
//    end

//endmodule