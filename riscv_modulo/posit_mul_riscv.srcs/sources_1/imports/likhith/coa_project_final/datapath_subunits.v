
`timescale 1ns / 1ps

module mux_21(input [31:0] in0, input [31:0] in1, input sel, output reg [31:0] out);

always@(in0, in1, sel)
begin
    case(sel)
        0 : out = in0;
        1 : out = in1;
        default : out = in0;
    endcase
end


endmodule

`timescale 1ns / 1ps

module pc( input rst, input clk, input stall, input [31:0] pc_in, output reg [31:0] pc_out);

always@( posedge clk)
begin
    if (stall)
    begin
        pc_out <= pc_out;
    end
    else
    begin
        if (rst == 1)
        begin
            pc_out = 0;
        end
        else
        begin
            pc_out = pc_in;
        end   
    end
end
endmodule



`timescale 1ns / 1ps

module adder_32bit(input [31:0] in1, input [31:0] in2, output reg [31:0] sum);

always@(in1, in2)
begin
    sum = in1 + in2;
end

endmodule



`timescale 1ns / 10ps

module instr_mem( input rst, input [31:0] read_addr, output reg [31:0]instr);

reg [7:0] instr_mem [99:0];



always@(rst, read_addr)
begin
    if (rst)
    begin
    
//    {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'hfd010113;
//{instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'h00812023;
//{instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'h00912223;
//{instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'h01212423;
//{instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'h01312623;
//{instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'h01412823;
//{instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'h01512a23;
//{instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 32'h01612c23;
//{instr_mem[35], instr_mem[34], instr_mem[33], instr_mem[32]} = 32'h01712e23;
//{instr_mem[39], instr_mem[38], instr_mem[37], instr_mem[36]} = 32'h03812023;
    
//        {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h002083B3;
//        {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'h00702023;
//        {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'h00520393;
//        {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'h00938663;
//        {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'h00002283;
//        {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'h001292B3;
//        {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'h4032D293;
//        {instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 32'h010003EF;
//        {instr_mem[35], instr_mem[34], instr_mem[33], instr_mem[32]} = 32'hFEA5D0E3;
//        {instr_mem[39], instr_mem[38], instr_mem[37], instr_mem[36]} = 32'hFCA5DEE3;
//        {instr_mem[43], instr_mem[42], instr_mem[41], instr_mem[40]} = 32'hFCA5DCE3;
//        {instr_mem[47], instr_mem[46], instr_mem[45], instr_mem[44]} = 32'h009283B3;
//        {instr_mem[51], instr_mem[50], instr_mem[49], instr_mem[48]} = 32'h004003E7;


        // {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h00210C63;
        // //{instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h003100B3;
        // {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'h0062F213;
        // {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'h00002303;
        // {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'h00139413;
        // {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'h00902023;
        // {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'h003100B3;
        // {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'h00C58513;

        // {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h003100B3;
        // //{instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h003100B3;
        // {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'h002080B3;
        // {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'h00308233;
        // {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'h002082B3;

        // {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h00002083;
        // //{instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'h003100B3;
        // {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'h002081B3;
        // {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'h00208233;
        // //{instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'h002082B3;

        // {instr_mem[3] , instr_mem[2] , instr_mem[1] , instr_mem[0] } = 32'b000000001010_00000_000_00011_0010011; // addi x3, x0, 10
        // {instr_mem[7] , instr_mem[6] , instr_mem[5] , instr_mem[4] } = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1
        // {instr_mem[11], instr_mem[10], instr_mem[9] , instr_mem[8] } = 32'b0000000_00001_00111_010_00001_0100011; // sw x1, 1(x7)
        // {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'b0000000_00000_00111_010_00000_0100011; // sw x0, 0(x7)
        // {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'b000000000000_00111_010_00001_0000011; // lw x1, 0(x7)
        // {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b000000000001_00111_010_00010_0000011; // lw x2, 1(x7)
        // {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'b0000000_00000_00011_000_10100_1100011; // beq x3, x0, 20
        // {instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 32'b0000000_00010_00001_000_00100_0110011; // add x4, x1, x2
        // {instr_mem[35], instr_mem[34], instr_mem[33], instr_mem[32]} = 32'b0000000_00100_00111_010_00010_0100011; // sw x4, 2(x7)
        // {instr_mem[39], instr_mem[38], instr_mem[37], instr_mem[36]} = 32'b111111111111_00011_000_00011_0010011; // addi x3, x3, -1
        // {instr_mem[43], instr_mem[42], instr_mem[41], instr_mem[40]} = 32'b000000000001_00111_000_00111_0010011; // addi x7, x7, 1
        // {instr_mem[47], instr_mem[46], instr_mem[45], instr_mem[44]} = 32'b1_1111110000_1_1111111_00101_1101111;     // jal x5, -32
         {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'b11111110000100010111001001111111;
         {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'b11111110100001001111010101111111;
         {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b1111111_01100_01101_111_01110_1111111;
         {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'b1111111_01111_10000_111_10001_1111111;
         {instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 32'b1111111_10010_10011_111_10100_1111111;
//       {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'b11111110000100010111001001111111;
//              {instr_mem[3] , instr_mem[2] , instr_mem[1] , instr_mem[0] } = 32'b000000000010_00000_000_00011_0010011; // addi x3, x0, 2
              
//              {instr_mem[7] , instr_mem[6] , instr_mem[5] , instr_mem[4] } = 32'b000000000010_00011_000_00011_0010011; // addi x3, x3, 2

//            {instr_mem[11], instr_mem[10], instr_mem[9] , instr_mem[8] } = 32'b000000000010_00011_000_00011_0010011; // addi x3, x3, 2
            
//             {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'b000000000010_00011_000_00011_0010011; // addi x3, x3, 2
            
//             {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'b000000000010_00011_000_00011_0010011; // addi x3, x3, 2
             
            
         //  {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b000000000001_00111_010_00010_0000011; // lw x2, 1(x7)

         //  {instr_mem[7] , instr_mem[6] , instr_mem[5] , instr_mem[4] } = 32'b000000000001_00000_000_00001_0010011; // addi x1, x0, 1
            
         //  {instr_mem[11], instr_mem[10], instr_mem[9] , instr_mem[8] } = 32'b0000000_00001_00111_010_00001_0100011; // sw x1, 1(x7)
            
        //   {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'b0000000_00000_00111_010_00000_0100011; // sw x0, 0(x7)
            
        //   {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'b000000000000_00111_010_00001_0000011; // lw x1, 0(x7)
            
         //  {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b000000000001_00111_010_00010_0000011; // lw x2, 1(x7)
            
        //   {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'b0000000_00000_00011_000_10100_1100011; // beq x3, x0, 20
            
        //   {instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 32'b0000000_00010_00001_000_00100_0110011; // add x4, x1, x2
            
//           {instr_mem[35], instr_mem[34], instr_mem[33], instr_mem[32]} = 32'b0000000_00100_00111_010_00010_0100011; // sw x4, 2(x7)
            
//           {instr_mem[39], instr_mem[38], instr_mem[37], instr_mem[36]} = 32'b111111111111_00011_000_00011_0010011; // addi x3, x3, -1
            
//           {instr_mem[43], instr_mem[42], instr_mem[41], instr_mem[40]} = 32'b000000000001_00111_000_00111_0010011; // addi x7, x7, 1
        
//           {instr_mem[47], instr_mem[46], instr_mem[45], instr_mem[44]} = 32'hFE5FF2EF;   //� jal� x5,� 16
        
        instr = {instr_mem[read_addr + 3], instr_mem[read_addr + 2], instr_mem[read_addr + 1], instr_mem[read_addr]};
    end
    else
    begin
        instr = {instr_mem[read_addr + 3], instr_mem[read_addr + 2], instr_mem[read_addr + 1], instr_mem[read_addr]};
    end
end
           
endmodule


// FOR HEX FILE DUMP
//module instr_mem(
//    input rst,
//    input [31:0] read_addr,
//    output reg [31:0] instr
//);

//reg [31:0] instr_mem [0:1023];

//// ✅ Load program
//initial begin
//    $readmemh("prog.mem", instr_mem);
//      $display("First instr = %h", instr_mem[0]);
//end

//// ✅ Instruction fetch
//always @(*) begin
//    instr = instr_mem[read_addr[11:2]];
//end

//endmodule



`timescale 1ns / 1ps
//---------------------------
//============================================================
// Module: IF_ID_Reg
// Description:
// This is the pipeline register between the Instruction Fetch (IF) 
// stage and the Instruction Decode (ID) stage of a pipelined CPU.
// It stores the fetched instruction and related data so that the 
// ID stage can use it in the next clock cycle.
//
// Features:
// - Supports stalling (holding current values)
// - Supports flushing (clearing values, typically after branch/jump)
//============================================================

module IF_ID_Reg(
    input clk,                       // System clock
    input stall,                     // Stall signal (1 = hold current values)
    input flush,                     // Flush signal (1 = reset pipeline register to 0)
    input [31:0] pc_out,              // Program Counter value from IF stage
    input [31:0] instr,               // Instruction fetched from instruction memory

    // Outputs to ID stage
    output reg [31:0] if_id_pc_out,   // Stored PC value
    output reg [31:0] if_id_instr,    // Stored instruction
    output reg [6:0] if_id_opcode,    // Opcode field from instruction
    output reg [4:0] if_id_rs1,       // Source register 1 index
    output reg [4:0] if_id_rs2,       // Source register 2 index
    output reg [4:0] if_id_rd,        // Destination register index
    output reg [6:0] if_id_f7,        // funct7 field (R-type instructions)
    output reg [2:0] if_id_f3         // funct3 field (instruction subtype)
);

//============================================================
// Sequential logic: Runs on the rising edge of the clock
//============================================================
always @(posedge clk) begin

    // ----------------------
    // Case 1: Stall
    // ----------------------
    // If stall is active, hold all current register values
    // This prevents IF stage from overwriting the ID stage data
    if (stall) begin
        if_id_pc_out <= if_id_pc_out;
        if_id_instr  <= if_id_instr;
        if_id_opcode <= if_id_opcode;
        if_id_rs1    <= if_id_rs1;
        if_id_rs2    <= if_id_rs2;
        if_id_rd     <= if_id_rd;
        if_id_f7     <= if_id_f7;
        if_id_f3     <= if_id_f3;
    end

    // ----------------------
    // Case 2: Flush
    // ----------------------
    // If flush is active, clear the pipeline register
    // This is used when a branch/jump changes PC to prevent
    // wrong instructions from executing.
    else if (flush) begin
        if_id_pc_out <= 0;
        if_id_instr  <= 0;
        if_id_opcode <= 0;
        if_id_rs1    <= 0;
        if_id_rs2    <= 0;
        if_id_rd     <= 0;
        if_id_f7     <= 0;
        if_id_f3     <= 0;
    end

    // ----------------------
    // Case 3: Normal operation
    // ----------------------
    // Store new values from the IF stage into the IF/ID register.
    // The instruction fields are extracted here.
    else begin
        if_id_pc_out <= pc_out;         // Store current PC value
        if_id_instr  <= instr;          // Store entire instruction
        if_id_opcode <= instr[6:0];     // Extract opcode (bits [6:0])
        if_id_rs1    <= instr[19:15];   // Extract source register 1 (bits [19:15])
        if_id_rs2    <= instr[24:20];   // Extract source register 2 (bits [24:20])
        if_id_rd     <= instr[11:7];    // Extract destination register (bits [11:7])
        if_id_f7     <= instr[31:25];   // Extract funct7 field (bits [31:25])
        if_id_f3     <= instr[14:12];   // Extract funct3 field (bits [14:12])
    end
end

endmodule

//---------------------------
//============================================================
// Module: reg_file
// Description:
// This is a 32x32-bit register file for a RISC-V CPU.
// It supports two read ports and one write port.
//============================================================
module reg_file(
    input rst,                     // Reset signal (active high)
    input clk,                     // Clock
    input [4:0] read_reg1,          // Index of first register to read
    input [4:0] read_reg2,          // Index of second register to read
    input [4:0] write_reg,          // Index of register to write
    input [31:0] write_data,        // Data to be written
    input reg_write,                // Write enable signal
    output reg [31:0] data1,        // Output data from read_reg1
    output reg [31:0] data2         // Output data from read_reg2
);

    //============================================================
    // Register Memory:
    // reg_mem[0]  = x0 (hardwired to zero in RISC-V, but here 
    //                   it's initialized for simulation purposes)
    // reg_mem[31] = x31
    //============================================================
    reg [31:0] reg_mem [31:0];  
    integer i;

    //============================================================
    // RESET: Initialize registers
    //============================================================
//    always @(rst) begin
//        if (rst) begin
//            // For simulation: Initialize registers with their index value
//            // Example: reg_mem[5] = 5
//            for (i = 0; i < 32; i = i + 1) begin
//                reg_mem[i] = i;  
//            end
//        end
//    end

//always @(rst) begin
//    if (rst) begin
//        // Initialize all registers to 0 (good practice)
//        for (i = 0; i < 32; i = i + 1) begin
//            reg_mem[i] = 32'd0;
//        end

//        // Custom values
//        reg_mem[2] = 32'h015A00F7; // RS1 → (346 | 247)
//        reg_mem[1] = 32'h0000003F; // RS2 → 63
//    end
//end





always @(rst) begin
    if (rst) begin
        reg_mem[0]  = 32'd0;
        
//        // for  classic barett mul
//        reg_mem[1]  = 32'h00000ABE;
//        reg_mem[2]  = 32'h00020023;
        
           // for  basic barett mul
        reg_mem[1]  = 32'd2750;
        reg_mem[2]  = 32'h02A20023;
        
         

//for posit
//        reg_mem[1]  = 'b0000_1010_0110_0100;  //b
//        reg_mem[2]  = 'b0111_1010_1100_0100;  //a
        reg_mem[3]  = 32'd0;
        reg_mem[4]  = 32'h01A26023;
        reg_mem[5]  = 32'd2750;
        reg_mem[6]  = 32'd0;
        reg_mem[7]  = 32'd0;
        reg_mem[8]  = 32'd2750;
        reg_mem[9]  = 32'h02B20043;
        reg_mem[10] = 32'd0;
        reg_mem[11] = 32'd0;
        reg_mem[12] = 32'd2750;
        reg_mem[13] = 32'h02A10013;
        reg_mem[14] = 32'd0;
        reg_mem[15] = 32'd2750;
        reg_mem[16] = 32'h05C10011;
        reg_mem[17] = 32'd0;
        reg_mem[18] = 32'd2750;
        reg_mem[19] = 32'h06A20016;
//reg_mem[3]  = 32'd0;
//        reg_mem[4]  = 32'h0;
//        reg_mem[5]  = 32'd0;
//        reg_mem[6]  = 32'd0;
//        reg_mem[7]  = 32'd0;
//        reg_mem[8]  = 32'd0;
//        reg_mem[9]  = 32'h0;
//        reg_mem[10] = 32'd0;
//        reg_mem[11] = 32'd0;
//        reg_mem[12] = 32'd0;
//        reg_mem[13] = 32'h0;
//        reg_mem[14] = 32'd0;
//        reg_mem[15] = 32'd0;
//        reg_mem[16] = 32'h0;
//        reg_mem[17] = 32'd0;
//        reg_mem[18] = 32'd0;
//        reg_mem[19] = 32'h0;
        reg_mem[20] = 32'd0;
        reg_mem[21] = 32'd0;
        reg_mem[22] = 32'd0;
        reg_mem[23] = 32'd0;
        reg_mem[24] = 32'd0;
        reg_mem[25] = 32'd0;
        reg_mem[26] = 32'd0;
        reg_mem[27] = 32'd0;
        reg_mem[28] = 32'd0;
        reg_mem[29] = 32'd0;
        reg_mem[30] = 32'd0;
        reg_mem[31] = 32'd0;
    end
end






    //============================================================
    // ASYNCHRONOUS READS on negative clock edge
    //============================================================
    always @(negedge clk) begin
        data1 <= reg_mem[read_reg1];  // Read from register read_reg1
        data2 <= reg_mem[read_reg2];  // Read from register read_reg2
    end

    //============================================================
    // WRITE OPERATION (combinational trigger)
    //============================================================
    always @(reg_write, write_data, write_reg) begin
        // Avoid writing to x0 (register 0 is always zero in RISC-V)
        if (write_reg != 0) begin
            if (reg_write == 1) begin
                reg_mem[write_reg] <= write_data; // Write new value
            end
        end
    end

endmodule

//---------------------
`timescale 1ns / 1ps

module imm_gen(input [31:0] instr, input [1:0] imm_sel, output reg [31:0] imm_val);
reg [11:0] imm_isb;

always@(instr, imm_sel)
begin
    if (imm_sel == 2'b00) // I-Type along with Load and JALR
    begin
        imm_isb = instr[31:20];
        imm_val = { {20{imm_isb[11]}}, imm_isb };
    end
    else if (imm_sel == 2'b01) // S-Type
    begin
        imm_isb = { instr[31:25], instr[11:7] };
        imm_val = { {20{imm_isb[11]}}, imm_isb };
    end
    else if (imm_sel == 2'b10) // B-Type
    begin
        imm_isb = {instr[31], instr[7], instr[30:25], instr[11:8]};
        imm_val = { {20{imm_isb[11]}}, imm_isb };
        imm_val = imm_val << 1; // Shift left by 1
    end
    else if (imm_sel == 2'b11) // J-Type
    begin
        imm_isb = {instr[31], instr[19:12], instr[20], instr[30:21]};
        imm_val = { {20{imm_isb[11]}}, imm_isb };
        imm_val = imm_val << 1; // Shift left by 1
    end

end

endmodule

`timescale 1ns / 1ps
//---------------------------
//============================================================
// Module: ID_EX_Reg
// Description:
// This is the pipeline register between the Instruction Decode (ID)
// stage and the Execute (EX) stage in a RISC-V pipeline.
//
// It stores:
// - Register addresses (rs1, rs2, rd)
// - Register data values
// - Immediate values
// - Control signals (for ALU, memory, branching, etc.)
// 
// On every clock edge, it either:
//   * Flushes all values to zero (if flush=1)
//   * Latches new values from ID stage (if flush=0)
//============================================================
module ID_EX_Reg(
    input clk,                        // Clock signal
    input flush,                      // Flush signal (clears pipeline stage)
    // Inputs from IF/ID pipeline register (Decode stage)
    input if_id_p,
    input [31:0] if_id_pc_out,         // Program Counter value
    input [4:0]  if_id_rs1,            // Source register 1 address
    input [4:0]  if_id_rs2,            // Source register 2 address
    input [4:0]  if_id_rd,             // Destination register address
    input [6:0]  if_id_f7,             // funct7 field
    input [2:0]  if_id_f3,             // funct3 field
    input [31:0] if_id_reg_data1,      // Value from source register 1
    input [31:0] if_id_reg_data2,      // Value from source register 2
    input [31:0] if_id_imm_val,        // Immediate value

    // Control signals from ID stage
    input if_id_reg_write,             // Register write enable
    input if_id_alu_src,               // ALU source select
    input [1:0] if_id_alu_op,           // ALU operation code
    input if_id_mem_read,              // Memory read enable
    input if_id_mem_write,             // Memory write enable
    input if_id_mem_to_reg,            // Write-back source: mem or ALU
    input if_id_branch,                // Branch flag
    input if_id_jump,                  // Jump flag
    input if_id_jalr,                  // JALR flag

    // Outputs to EX stage
    output reg [31:0] id_ex_reg_data1, // Register data 1
    output reg [31:0] id_ex_reg_data2, // Register data 2
    output reg [31:0] id_ex_imm_val,   // Immediate value
    output reg [31:0] id_ex_pc_out,    // Program Counter value
    output reg [4:0] id_ex_rs1,        // Source register 1 address
    output reg [4:0] id_ex_rs2,        // Source register 2 address
    output reg [4:0] id_ex_rd,         // Destination register address
    output reg [6:0] id_ex_f7,         // funct7 field
    output reg [2:0] id_ex_f3,         // funct3 field

    // Control signals latched for EX stage
    output reg id_ex_reg_write,        
    output reg id_ex_alu_src,
    output reg [1:0] id_ex_alu_op,
    output reg id_ex_mem_read,
    output reg id_ex_mem_write,
    output reg id_ex_mem_to_reg,
    output reg id_ex_branch,
    output reg id_ex_jump,
    output reg id_ex_jalr,
    output reg id_ex_p
);

    //============================================================
    // Pipeline Register Update
    //============================================================
    always @(posedge clk) begin
        if (flush) begin
            // If flush is asserted, clear all stored values
            id_ex_pc_out      <= 0;
            id_ex_rs1         <= 0;
            id_ex_rs2         <= 0;
            id_ex_rd          <= 0;
            id_ex_f7          <= 0;
            id_ex_f3          <= 0;
            id_ex_reg_data1   <= 0;
            id_ex_reg_data2   <= 0;
            id_ex_imm_val     <= 0;
            id_ex_reg_write   <= 0;
            id_ex_alu_src     <= 0;
            id_ex_alu_op      <= 0;
            id_ex_mem_read    <= 0;
            id_ex_mem_write   <= 0;
            id_ex_mem_to_reg  <= 0;
            id_ex_branch      <= 0;
            id_ex_jump        <= 0;
            id_ex_jalr        <= 0;
             id_ex_p        <= 0;
        end
        else begin
            // Normal operation: pass values from ID stage to EX stage
            id_ex_pc_out      <= if_id_pc_out;
            id_ex_rs1         <= if_id_rs1;
            id_ex_rs2         <= if_id_rs2;
            id_ex_rd          <= if_id_rd;
            id_ex_f7          <= if_id_f7;
            id_ex_f3          <= if_id_f3;
            id_ex_reg_data1   <= if_id_reg_data1;
            id_ex_reg_data2   <= if_id_reg_data2;
            id_ex_imm_val     <= if_id_imm_val;
            id_ex_reg_write   <= if_id_reg_write;
            id_ex_alu_src     <= if_id_alu_src;
            id_ex_alu_op      <= if_id_alu_op;
            id_ex_mem_read    <= if_id_mem_read;
            id_ex_mem_write   <= if_id_mem_write;
            id_ex_mem_to_reg  <= if_id_mem_to_reg;
            id_ex_branch      <= if_id_branch;
            id_ex_jump        <= if_id_jump;
            id_ex_jalr        <= if_id_jalr;
            id_ex_p  <=  if_id_p;
        end
    end

endmodule

//---------------------

`timescale 1ns / 1ps

module mux_41(input [31:0] in0,[31:0]  in1, [31:0]  in2, [31:0]  in3, [1:0] sel, output reg [31:0] out);

always@(in0, in1, in2, in3, sel)
begin
    case(sel)
        0 : out = in0;
        1 : out = in1;
        2 : out = in2;
        3 : out = in3;
        default : out = in0;
    endcase
end
     
endmodule





`timescale 1ns / 1ps

module alu_ctrl_unit( input [1:0] alu_op, input [2:0] f3, input [6:0] f7, output reg [3:0] alu_ctrl );

always@(alu_op, f3, f7)
begin
    if (alu_op == 2'b00)  // Load and Store
    begin
        alu_ctrl = 4'b0010;
    end
    else if (alu_op == 2'b01) // I-Type except Load and Store
    begin
        if (f3 == 3'b101)
        begin
            if (f7 == 7'b0000000)
            begin
                alu_ctrl = 4'b0100; // SRLI
            end
            else if (f7 == 7'b0100000)
            begin
                alu_ctrl = 4'b0101; //SRAI
            end
        end
        else if (f3 == 3'b000 ) 
            begin
                alu_ctrl = 4'b0010; // ADDI
            end
        else if (f3 == 3'b110)
            begin
                alu_ctrl = 4'b0001; // ORI
            end
        else if (f3 == 3'b111)
            begin
                alu_ctrl = 4'b0000; // ANDI
            end
        else if (f3 == 3'b001)
            begin
                alu_ctrl = 4'b0011; // SLLI
            end

    end
    else if (alu_op == 2'b10) //R-Type
    begin
        if (f7 == 7'b0000000) 
        begin
            if (f3 == 3'b000)
            begin
                alu_ctrl = 4'b0010; // ADD
            end
            else if (f3 == 3'b111 ) 
            begin
                alu_ctrl = 4'b0000; // AND
            end
            else if (f3 == 3'b110)
            begin
                alu_ctrl = 4'b0001; // OR
            end
            else if (f3 == 3'b001)
            begin
                alu_ctrl = 4'b0011; // SLL
            end
            else if (f3 == 3'b101)
            begin
                alu_ctrl = 4'b0100; // SRL
            end
        end
        else if (f7 == 7'b0100000)
        begin
            if (f3 == 3'b000)
            begin
                alu_ctrl = 4'b0110; // SUB
            end
            else if (f3 == 3'b101)
            begin
                alu_ctrl = 4'b0101; // SRA
            end
        end
    end
    else if (alu_op == 2'b11)   // B-Type
    begin
        alu_ctrl = 4'b0110;
    end
end
endmodule


`timescale 1ns / 1ps

module alu( input signed [31:0] a, input signed [31:0] b, input [3:0] alu_ctrl, output reg [31:0] alu_result, output zero, neg);
always@(a, b, alu_ctrl)
begin
    case(alu_ctrl)
        4'b0000: alu_result = a & b;         // AND
        4'b0001: alu_result = a | b;         // OR
        4'b0010: alu_result = a + b;         // ADD
        4'b0011: alu_result = a << b[4:0];   // SLL
        4'b0100: alu_result = a >> b[4:0];   // SRL
        4'b0101: alu_result = a >>> b[4:0];  // SRA
        4'b0110: alu_result = a - b;         // SUB    
    endcase

end

assign zero = (alu_result == 0) ? 1 : 0;
assign neg = alu_result[31];

endmodule
//-----------------
// EX/MEM Pipeline Register
// ------------------------
// This module implements the pipeline register between the Execute (EX) 
// stage and the Memory (MEM) stage in a pipelined processor.
// It captures the outputs of the EX stage at every positive clock edge
// and passes them to the MEM stage in the next cycle.

module EX_MEM_Reg(
    input clk,                        // Clock signal

    // Data & control signals from ID/EX stage (Execute stage output)
    input [31:0] id_ex_pc_out,         // Program counter value from EX stage
    input [4:0]  id_ex_rd,             // Destination register address
    input [31:0] id_ex_reg_data2,      // Register data (to be written to memory in case of store)
    input [31:0] id_ex_alu_result,     // Result from ALU computation

    // Control signals from EX stage
    input id_ex_reg_write,             // Enable writing to register file
    input id_ex_mem_read,              // Memory read enable
    input id_ex_mem_write,             // Memory write enable
    input id_ex_mem_to_reg,            // Select between ALU result and memory data for register write
    input id_ex_jump,                  // Jump instruction flag

    // Outputs to MEM stage
    output reg [31:0] ex_mem_pc_out,   // Program counter passed to MEM stage
    output reg [4:0]  ex_mem_rd,       // Destination register address passed to MEM stage
    output reg [31:0] ex_mem_reg_data2,// Register data to be written to memory (for store instructions)
    output reg [31:0] ex_mem_alu_result,// ALU result to be used by MEM or WB stages

    // Control signals passed to MEM stage
    output reg ex_mem_reg_write,       // Enable register write in WB stage
    output reg ex_mem_mem_read,        // Enable memory read in MEM stage
    output reg ex_mem_mem_write,       // Enable memory write in MEM stage
    output reg ex_mem_mem_to_reg,      // Select source of data for WB stage
    output reg ex_mem_jump             // Pass jump flag to MEM stage
);

// On every rising edge of the clock, store EX stage outputs into EX/MEM registers
always @(posedge clk) begin
    ex_mem_pc_out       <= id_ex_pc_out;      // Forward PC
    ex_mem_rd           <= id_ex_rd;          // Forward destination register index
    ex_mem_reg_data2    <= id_ex_reg_data2;   // Forward register data for stores
    ex_mem_alu_result   <= id_ex_alu_result;  // Forward ALU result

    // Forward control signals
    ex_mem_reg_write    <= id_ex_reg_write;   
    ex_mem_mem_read     <= id_ex_mem_read;    
    ex_mem_mem_write    <= id_ex_mem_write;   
    ex_mem_mem_to_reg   <= id_ex_mem_to_reg;  
    ex_mem_jump         <= id_ex_jump;        
end

endmodule

//------------------
`timescale 1ns / 1ps

module data_mem( input rst, input clk, input [31:0] addr, input [31:0] write_data_dm, input mem_read, input mem_write, output reg [31:0] read_data );

reg [31:0] data_mem [99:0];

always@(rst, addr)
//always@(rst, addr)
begin
   if (rst)
   begin
       data_mem[0] = 1;
   end
   else if (mem_read == 1)
   begin
       read_data = data_mem[addr];
   end
end

// always@(posedge rst or negedge clk)
// begin
//     if (rst)
//     begin
//         data_mem[0] = 1;
//     end
//     else if (mem_read == 1)
//     begin
//         read_data = data_mem[addr];
//     end
// end
always@(posedge clk)
begin
    if (mem_write == 1)
    begin
        data_mem[addr] = write_data_dm;
    end
end
endmodule

`timescale 1ns / 1ps
//----------------
// MEM/WB Pipeline Register
// This module transfers data and control signals from the EX/MEM stage to the MEM/WB stage
// in a pipelined processor. It latches the values on the rising edge of the clock.

module MEM_WB_Reg(
    input clk,                               // Clock signal
    // Data inputs from EX/MEM stage
    input [31:0] ex_mem_pc_out,              // Program counter value from EX/MEM stage
    input [4:0]  ex_mem_rd,                  // Destination register address
    input [31:0] ex_mem_read_data,           // Data read from memory
    input [31:0] ex_mem_alu_result,          // Result from ALU
    // Control signals from EX/MEM stage
    input ex_mem_reg_write,                  // Control: write enable for register file
    input ex_mem_mem_to_reg,                 // Control: select between ALU result and memory data
    input ex_mem_jump,                       // Control: jump instruction flag

    // Data outputs to MEM/WB stage
    output reg [31:0] mem_wb_pc_out,         // Program counter value to MEM/WB stage
    output reg [4:0]  mem_wb_rd,             // Destination register address to MEM/WB stage
    output reg [31:0] mem_wb_read_data,      // Data read from memory to MEM/WB stage
    output reg [31:0] mem_wb_alu_result,     // ALU result to MEM/WB stage
    // Control outputs to MEM/WB stage
    output reg mem_wb_reg_write,             // Control: write enable for register file
    output reg mem_wb_mem_to_reg,            // Control: select between ALU result and memory data
    output reg mem_wb_jump                   // Control: jump instruction flag
);

// On each rising edge of the clock, latch the inputs into the MEM/WB stage registers
always @(posedge clk)
begin
    mem_wb_pc_out     <= ex_mem_pc_out;      // Pass PC value to MEM/WB stage
    mem_wb_rd         <= ex_mem_rd;          // Pass destination register address
    mem_wb_read_data  <= ex_mem_read_data;   // Pass memory read data
    mem_wb_alu_result <= ex_mem_alu_result;  // Pass ALU result
    mem_wb_reg_write  <= ex_mem_reg_write;   // Pass register write enable signal
    mem_wb_mem_to_reg <= ex_mem_mem_to_reg;  // Pass memory-to-register selection signal
    mem_wb_jump       <= ex_mem_jump;        // Pass jump control signal
end

endmodule


//-----------------
