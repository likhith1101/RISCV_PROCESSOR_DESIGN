`timescale 1ns/1ps
module decoder ( input [15:0]opd , output sign , output [6:0]reg_ep, output [10:0]frac_opd );
  wire [14:0]opd_neg;
  wire [13:0]opd_neg_inv;
  wire [3:0]cnt;
  wire vld;
  wire [12:0]opd_no_rg;
  wire [14:0]LeadingOne;

  assign sign = opd[15];
  twoscompliment #(15) twoscompliment_signbit( opd[14:0] , opd[15] , opd_neg );
  xor_module #(14) xor_module_firstbit( opd_neg[13:0] ,opd_neg[14], opd_neg_inv[13:0] );
  lod #(15) lod_reg ( {opd_neg_inv[13:0],1'b1} , LeadingOne );
  lod_encoder lod_encoder_reg( LeadingOne , cnt );
  L_Shifter L_Shifter_frac_extract ( opd_neg[12:0] , cnt , opd_no_rg );
  
  wire [4:0]cnt_extended = {1'b0,cnt};
  wire [4:0]cnt_ext_not;
  not_module #(5) not_cnt_ext_module ( cnt_extended, cnt_ext_not );
  
  wire [4:0]rg;
  wire [1:0]exp = opd_no_rg[12:11];
  mux_nbit #(5) mux_cnt_pos_neg ( cnt_ext_not , cnt_extended , opd_neg[14] , rg );
  assign reg_ep[6:2] = rg ;
  assign reg_ep[1:0] = exp ;
  // LeadingOne[0] tells if all 0's or all 1's was detected
  assign frac_opd = opd_no_rg[10:0];
  
endmodule
