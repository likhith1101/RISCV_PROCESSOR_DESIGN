`timescale 1ns / 1ps


module riscv_tb();

reg rst, clk;
riscv_top DUT(rst, clk);

initial clk = 0;
always #5 clk = ~clk;

initial begin
rst = 1;
#7 rst = 0;
//#1000 $finish;
#100000 $finish;
end
endmodule


//`timescale 1ns / 1ps

//module riscv_tb();

//reg rst, clk;
//reg start;

//riscv_top DUT(
//    .rst(rst),
//    .clk(clk)
//    // make sure start is connected inside your top module!
//);

//// Clock generation
//initial clk = 0;
//always #5 clk = ~clk;

//// Stimulus
//initial begin
//    rst = 1;
//    start = 0;

//    #7 rst = 0;

//    // Wait until inputs (x,y,M) are valid (~30ns from waveform)
//    #25;

//    // Align with clock edge
//    @(posedge clk);
//    start = 1;

//    // Keep start HIGH for 1 cycle only
//    @(posedge clk);
//    start = 0;

//    // Wait for result
//    #100;

//    $finish;
//end

//endmodule