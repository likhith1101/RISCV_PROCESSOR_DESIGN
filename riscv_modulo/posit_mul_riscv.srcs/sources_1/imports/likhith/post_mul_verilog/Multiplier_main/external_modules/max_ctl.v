module max_ctl ( input [4:0]A ,output [3:0]Out );
  or (Out[0],A[0],A[4]);
  or (Out[1],A[1],A[4]);
  or (Out[2],A[2],A[4]);
  or (Out[3],A[3],A[4]);
endmodule
