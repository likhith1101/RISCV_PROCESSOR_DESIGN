`timescale 1ns / 1ps
//===============================================================
// Module: riscv_top
// Description: 
//   Top-level module for a pipelined RISC-V processor. 
//   This module instantiates and connects the main building blocks:
//   - Datapath Unit (registers, ALU, memory interface, etc.)
//   - Control Path Unit (control signal generation from opcode)
//   - Branch Control Unit (decides if a branch/jump should occur)
//   - Forwarding Unit (resolves data hazards via forwarding)
//   - Stall Unit (inserts pipeline stalls to resolve hazards)
//===============================================================

module riscv_top(input rst, input clk);

// -------------------
// Internal signal wires
// -------------------

// Execution results and control flags
wire id_ex_zero;       // ALU zero flag from ID/EX stage
wire id_ex_neg;        // ALU negative flag from ID/EX stage

// Control signals generated in IF/ID stage
wire if_id_reg_write;  // Enable register file write-back
wire if_id_alu_src;    // ALU operand source selection (reg vs immediate)
wire if_id_mem_read;   // Memory read enable
wire if_id_mem_write;  // Memory write enable
wire if_id_mem_to_reg; // Write-back data select (memory or ALU)
wire if_id_branch;     // Branch instruction indicator
wire if_id_jump;       // Unconditional jump indicator
wire if_id_jalr;       // JALR jump indicator

// Control signals generated in ID/EX stage
wire id_ex_pc_src;     // Decides whether to use branch/jump target PC
wire id_ex_branch;     
wire id_ex_jump;
wire id_ex_jalr;

// Register write enables from later stages
wire ex_mem_reg_write; 
wire mem_wb_reg_write;

// Memory read signal from ID/EX stage (needed for hazard detection)
wire id_ex_mem_read;

// Pipeline stall and flush control
wire stall;            // Stall the pipeline
wire flush;            // Flush pipeline stage(s) after branch/jump

// ALU/Immediate control selection
wire [1:0] if_id_imm_sel;  // Selects which immediate type to use
wire [1:0] if_id_alu_op;   // ALU operation code

// Forwarding control (for hazard resolution)
wire [1:0] forward_rs1;    // Forwarding select for source register 1
wire [1:0] forward_rs2;    // Forwarding select for source register 2

// Instruction fields
wire [2:0] id_ex_f3;       // funct3 field in ID/EX stage
wire [4:0] id_ex_rs1;      // Source register 1 ID/EX stage
wire [4:0] id_ex_rs2;      // Source register 2 ID/EX stage
wire [4:0] ex_mem_rd;      // Destination register in EX/MEM stage
wire [4:0] mem_wb_rd;      // Destination register in MEM/WB stage
wire [4:0] id_ex_rd;       // Destination register in ID/EX stage
wire [4:0] if_id_rs1;      // Source register 1 in IF/ID stage
wire [4:0] if_id_rs2;      // Source register 2 in IF/ID stage

wire [6:0] if_id_opcode;   // Instruction opcode from IF/ID stage
wire [31:0] instr;         // Fetched instruction (not used directly here)
wire if_id_p;
// -------------------
// Control logic for flush
// -------------------
// Flush occurs if the branch control unit selects PC from branch target
assign flush = id_ex_pc_src;

// -------------------
// Module Instantiations
// -------------------

//---------------------------------------------------------------
// Datapath Unit
// - Implements the 5 pipeline stages (IF, ID, EX, MEM, WB)
// - Contains register file, ALU, pipeline registers, memory interfaces
//---------------------------------------------------------------
datapath_unit dp (
    rst, clk,
    if_id_reg_write, if_id_alu_src,if_id_p, if_id_mem_read, if_id_mem_write,
    if_id_mem_to_reg, if_id_imm_sel, if_id_alu_op,
    forward_rs1, forward_rs2,
    if_id_branch, if_id_jump, if_id_jalr,
    id_ex_pc_src, stall, flush,
    if_id_opcode, id_ex_f3,
    id_ex_branch, id_ex_jump, id_ex_jalr,
    id_ex_zero, id_ex_neg,
    id_ex_rs1, id_ex_rs2,
    ex_mem_rd, mem_wb_rd,
    ex_mem_reg_write, mem_wb_reg_write,
    id_ex_mem_read, id_ex_rd,
    if_id_rs1, if_id_rs2
);

//---------------------------------------------------------------
// Control Path Unit
// - Decodes the instruction opcode
// - Generates control signals for ALU, memory, and branching
//---------------------------------------------------------------
ctrlpath_unit cp (
    if_id_opcode, stall,
    if_id_reg_write, if_id_imm_sel, if_id_alu_src, if_id_alu_op,
    if_id_mem_read, if_id_mem_write, if_id_mem_to_reg,
    if_id_branch, if_id_jump, if_id_jalr,if_id_p
);

//---------------------------------------------------------------
// Branch Control Unit
// - Uses branch/jump signals and ALU flags (zero/neg)
// - Decides whether PC should branch/jump or continue sequentially
//---------------------------------------------------------------
branch_ctrl_unit bcu (
    id_ex_f3, id_ex_branch, id_ex_jump,
    id_ex_zero, id_ex_neg,
    id_ex_pc_src
);

//---------------------------------------------------------------
// Forwarding Unit
// - Resolves data hazards by forwarding results from later stages
//   back to EX stage without stalling
//---------------------------------------------------------------
fwd_unit fdu (
    id_ex_rs1, id_ex_rs2,
    ex_mem_rd, mem_wb_rd,
    ex_mem_reg_write, mem_wb_reg_write,
    forward_rs1, forward_rs2
);

//---------------------------------------------------------------
// Stall Unit
// - Detects load-use hazards and inserts stalls to prevent
//   incorrect data usage in EX stage
//---------------------------------------------------------------
stall_unit su (
    rst,
    if_id_mem_read, id_ex_mem_read,
    id_ex_rd, if_id_rs1, if_id_rs2,
    stall
);



    
 
endmodule
