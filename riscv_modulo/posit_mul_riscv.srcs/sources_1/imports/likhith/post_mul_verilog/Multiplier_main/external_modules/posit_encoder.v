module encoder ( input [7:0]reg_ep , input [10:0]sum , input sign , output [15:0]product);
  wire [7:0]reg_ep_neg;
  twoscompliment #(6) reg_twoscompliment( reg_ep[7:2] , reg_ep[7] , reg_ep_neg[7:2] );
  
  wire [4:0]reg_abs = reg_ep_neg[6:2];
  wire [1:0]exp = reg_ep[1:0];

  wire [4:0]reg_abs_minusone;
  assign reg_abs_minusone= reg_ep_neg[6:2] - 1 ;

  wire [4:0]r_shift_tmp;
  mux_nbit #(5) mux_reg(  reg_abs ,reg_abs_minusone , reg_ep[7] , r_shift_tmp );

  wire reg_vec;
  wire reg_end = reg_ep[7];
  not not_reg_vec ( reg_vec , reg_ep[7] );
  
  wire [14:0]R_shift_in = { reg_vec , reg_end , exp , sum };
  wire [14:0]posit_pd;
  wire [3:0]r_shift;
  max_ctl max_ctr_shift(r_shift_tmp,r_shift);

  R_Shifter shifter(R_shift_in, r_shift , posit_pd );

  twoscompliment #(15) final_twoscompliment( posit_pd , sign , product[14:0]);
  assign product[15] = sign ;
  
endmodule
