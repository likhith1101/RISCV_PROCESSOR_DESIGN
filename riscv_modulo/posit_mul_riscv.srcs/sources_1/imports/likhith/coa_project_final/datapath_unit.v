`timescale 1ns / 1ps

//===========================================================
// Module: datapath_unit
// Description: Implements the RISC-V processor datapath,
//              including pipeline registers, forwarding, 
//              hazard detection, and memory access.
//===========================================================
module datapath_unit(
    input rst, clk, 
                                  // Reset and clock signals
    input if_id_reg_write, if_id_alu_src,  if_id_p,      // Control signals from IF/ID stage
    input if_id_mem_read, if_id_mem_write,
    input if_id_mem_to_reg,
    input [1:0] if_id_imm_sel,                    // Immediate type selection
    input [1:0] if_id_alu_op,                     // ALU operation type
    input [1:0] forward_rs1, forward_rs2,         // Forwarding control signals
    input if_id_branch, if_id_jump, if_id_jalr,   // Branch/jump control
    input id_ex_pc_src,                           // PC source selection (branch taken)
    input stall, flush,                           // Hazard control signals
    output [6:0] if_id_opcode,                    // Opcode of current instruction
    output [2:0] id_ex_f3,                        // funct3 from instruction
    output id_ex_branch, id_ex_jump, id_ex_jalr,  // Branch/jump control in EX stage
    output id_ex_zero, id_ex_neg,                 // ALU flags
    output [4:0] id_ex_rs1, id_ex_rs2,            // Source registers in EX stage
    output [4:0] ex_mem_rd, mem_wb_rd,            // Destination registers in MEM/WB
    output ex_mem_reg_write, mem_wb_reg_write,    // Register write enables
    output id_ex_mem_read,                        // Load detection for hazard
    output [4:0] id_ex_rd,                        // Destination register in EX
    output [4:0] if_id_rs1, if_id_rs2              // Source registers in IF/ID
    
);

//-----------------------------------------------------------
// Internal signal declarations
//-----------------------------------------------------------
wire id_ex_reg_write, id_ex_alu_src, id_ex_mem_write, id_ex_mem_to_reg;
wire ex_mem_mem_read, ex_mem_mem_write, ex_mem_mem_to_reg, ex_mem_jump;
wire mem_wb_mem_to_reg, mem_wb_jump;
wire [1:0] id_ex_alu_op;
wire [2:0] if_id_f3;
wire [3:0] id_ex_alu_ctrl;
wire [4:0] if_id_rd;
wire [6:0] if_id_f7, id_ex_f7;
wire [31:0] pc_in, pc_out, pc_plus4, pc_in_branch;
wire [31:0] instr;
wire [31:0] mem_wb_write_data, if_id_reg_data1, if_id_reg_data2, if_id_imm_val;
wire [31:0] id_ex_alu_src_mux_out, id_ex_alu_result, zero_flag, read_data;
wire [31:0] mem_wb_rd_mux_in0, id_ex_jump_src_mux_out, id_ex_branch_addr;
wire [31:0] if_id_pc_out, if_id_instr, id_ex_reg_data1, id_ex_reg_data2;
wire [31:0] id_ex_imm_val, id_ex_pc_out, id_ex_pc_plus4;
wire [31:0] ex_mem_pc_out, ex_mem_reg_data2, ex_mem_alu_result, ex_mem_read_data;
wire [31:0] mem_wb_pc_out, mem_wb_read_data, mem_wb_alu_result, mem_wb_pc_plus4;
wire [31:0] fd_mux_rs1_reg_data1, fd_mux_rs2_reg_data2;
wire [31:0]x, y;
wire [31:0]M;
//wire [15:0]result;
wire [31:0]result;
wire [31:0]alu_result;

//-----------------------------------------------------------
// IF Stage: Program Counter Update Logic
//-----------------------------------------------------------
// Select between sequential PC (pc_plus4) or branch target
mux_21 pc_mux (pc_plus4, id_ex_branch_addr, id_ex_pc_src, pc_in);

// Program Counter register (stallable)
pc pc1 (rst, clk, stall, pc_in, pc_out );

// Increment PC by 4
adder_32bit pc_plus4_adder1 (pc_out, 4, pc_plus4);

// Instruction Memory (fetch instruction)
instr_mem i_mem (rst, pc_out, instr);

//-----------------------------------------------------------
// IF/ID Pipeline Register
//-----------------------------------------------------------
IF_ID_Reg if_id_reg (
    clk, stall, flush, 
    pc_out, instr,
    if_id_pc_out, if_id_instr, if_id_opcode, 
    if_id_rs1, if_id_rs2, if_id_rd, 
    if_id_f7, if_id_f3
);

//-----------------------------------------------------------
// Register File (Read in ID Stage)
//-----------------------------------------------------------
reg_file rf1 (
    rst, clk, 
    if_id_rs1, if_id_rs2, 
    mem_wb_rd, mem_wb_write_data, mem_wb_reg_write,
    if_id_reg_data1, if_id_reg_data2
);

// Immediate generator (extracts immediate values from instruction)
imm_gen imm_gen1 (if_id_instr, if_id_imm_sel, if_id_imm_val);

//-----------------------------------------------------------
// ID/EX Pipeline Register
//-----------------------------------------------------------
ID_EX_Reg id_ex_reg (
    clk, flush,if_id_p,
    if_id_pc_out, if_id_rs1, if_id_rs2, if_id_rd, if_id_f7, if_id_f3,
    if_id_reg_data1, if_id_reg_data2, if_id_imm_val,
    if_id_reg_write, if_id_alu_src, if_id_alu_op,
    if_id_mem_read, if_id_mem_write, if_id_mem_to_reg,
    if_id_branch, if_id_jump, if_id_jalr,
    id_ex_reg_data1, id_ex_reg_data2, id_ex_imm_val, id_ex_pc_out,
    id_ex_rs1, id_ex_rs2, id_ex_rd, id_ex_f7, id_ex_f3,
    id_ex_reg_write, id_ex_alu_src, id_ex_alu_op,
    id_ex_mem_read, id_ex_mem_write, id_ex_mem_to_reg,
    id_ex_branch, id_ex_jump, id_ex_jalr,id_ex_p
);

//-----------------------------------------------------------
// EX Stage: Branch Target Calculation
//-----------------------------------------------------------
// Select base for branch target: PC or RS1 value (for JALR)
mux_21 jump_src_mux (id_ex_pc_out, fd_mux_rs1_reg_data1, id_ex_jalr, id_ex_jump_src_mux_out);

// Add immediate to base address to get branch target
adder_32bit branch_adder (id_ex_jump_src_mux_out, id_ex_imm_val, id_ex_branch_addr);

//-----------------------------------------------------------
// Forwarding Logic Muxes for ALU inputs
//-----------------------------------------------------------
mux_41 fd_mux_rs1 (id_ex_reg_data1, ex_mem_alu_result, mem_wb_rd_mux_in0, 0, forward_rs1, fd_mux_rs1_reg_data1);
mux_41 fd_mux_rs2 (id_ex_reg_data2, ex_mem_alu_result, mem_wb_rd_mux_in0, 0, forward_rs2, fd_mux_rs2_reg_data2);

// Select between register value or immediate for ALU second operand
mux_21 alu_src_mux(fd_mux_rs2_reg_data2, id_ex_imm_val, id_ex_alu_src, id_ex_alu_src_mux_out);

// ALU Control Unit (decodes ALU operation)
alu_ctrl_unit alu_control (id_ex_alu_op, id_ex_f3, id_ex_f7, id_ex_alu_ctrl);

// ALU Execution
alu alu1 (fd_mux_rs1_reg_data1, id_ex_alu_src_mux_out, id_ex_alu_ctrl,alu_result, id_ex_zero, id_ex_neg);

//-----------------------------------------------------------
// EX/MEM Pipeline Register
//-----------------------------------------------------------
EX_MEM_Reg ex_mem_reg (
    clk, id_ex_pc_out, id_ex_rd, fd_mux_rs2_reg_data2, id_ex_alu_result,
    id_ex_reg_write, id_ex_mem_read, id_ex_mem_write, id_ex_mem_to_reg, id_ex_jump,
    ex_mem_pc_out, ex_mem_rd, ex_mem_reg_data2, ex_mem_alu_result,
    ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write, ex_mem_mem_to_reg, ex_mem_jump
);

//-----------------------------------------------------------
// MEM Stage: Data Memory Access
//-----------------------------------------------------------
data_mem d_mem (rst, clk, ex_mem_alu_result, ex_mem_reg_data2, ex_mem_mem_read, ex_mem_mem_write, ex_mem_read_data);

//-----------------------------------------------------------
// MEM/WB Pipeline Register
//-----------------------------------------------------------
MEM_WB_Reg mem_wb_reg (
    clk, ex_mem_pc_out, ex_mem_rd, ex_mem_read_data, ex_mem_alu_result,
    ex_mem_reg_write, ex_mem_mem_to_reg, ex_mem_jump,
    mem_wb_pc_out, mem_wb_rd, mem_wb_read_data, mem_wb_alu_result,
    mem_wb_reg_write, mem_wb_mem_to_reg, mem_wb_jump
);

//-----------------------------------------------------------
// WB Stage: Select data to write back to Register File
//-----------------------------------------------------------
mux_21 mem_to_reg_mux (mem_wb_alu_result, mem_wb_read_data, mem_wb_mem_to_reg, mem_wb_rd_mux_in0);

// Increment PC in WB stage for JAL/JALR return address
adder_32bit pc_plus4_adder2 (mem_wb_pc_out, 4, mem_wb_pc_plus4);

// Select between normal result and PC+4 for writing to RD
mux_21 rd_mux (mem_wb_rd_mux_in0, mem_wb_pc_plus4, mem_wb_jump, mem_wb_write_data);


//    mod_mult_clk posit_mul_module (
 
//    .opd_a(fd_mux_rs1_reg_data1),
//    .opd_b(id_ex_alu_src_mux_out),
//    .product(result)
    

        
//    );



mod_mult_clk barret_module (
    .x(x),
    .y(y),
    .M(M),
    .result(result)
);
assign x=fd_mux_rs1_reg_data1[31:16];
assign y=fd_mux_rs1_reg_data1[15:0];
assign M=id_ex_alu_src_mux_out;

//mux_21 barret_sel(result,alu_result,id_ex_p,id_ex_alu_result);

mux_21_posit posit_sel_mux(result,alu_result,id_ex_p,id_ex_alu_result);
endmodule
