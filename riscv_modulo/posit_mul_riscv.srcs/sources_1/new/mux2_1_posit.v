`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2026 03:25:21 AM
// Design Name: 
// Module Name: mux2_1_posit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_21_posit(input [15:0] in0, input [31:0] in1, input sel, output reg [31:0] out);

always@(in0, in1, sel)
begin
    case(sel)
        0 : out = in0;
        1 : out = in1;
        default : out = in0;
    endcase
end


endmodule
