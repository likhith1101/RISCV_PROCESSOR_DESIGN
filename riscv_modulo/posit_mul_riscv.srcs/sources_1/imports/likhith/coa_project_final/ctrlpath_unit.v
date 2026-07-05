`timescale 1ns / 1ps
//============================================================
// Module: ctrlpath_unit
// Description: Generates control signals for the datapath 
//              based on the instruction opcode in a RISC-V CPU.
//
// This module decodes the 7-bit instruction opcode and outputs 
// the appropriate control signals for register file, ALU, memory,
// and branching/jumping logic. Also handles "stall" conditions.
//============================================================

module ctrlpath_unit(
    input [6:0] opcode,     // 7-bit RISC-V opcode from IF/ID stage
    input stall,            // Stall signal from hazard detection unit
    
    // Control signal outputs
    output reg reg_write,   // Enable register file write
    output reg [1:0] imm_sel, // Immediate type selector
    output reg alu_src,     // ALU source select: 0=reg, 1=immediate
    output reg [1:0] alu_op,// ALU operation type
    output reg mem_read,    // Enable data memory read
    output reg mem_write,   // Enable data memory write
    output reg mem_to_reg,  // Write-back select: 1=memory data, 0=ALU result
    output reg branch,      // Branch control signal
    output reg jump,        // Jump control signal
    output reg jalr , 
    output reg p       // JALR control signal
);


always @ (opcode, stall) begin
    //============================================================
    // If pipeline is stalled, disable all writes and control signals
    //============================================================
    if (stall) begin
        reg_write   = 0;
        imm_sel     = 2'b00;
        alu_src     = 0;
        alu_op      = 2'b00;
        mem_read    = 0;
        mem_write   = 0;
        mem_to_reg  = 0;
        branch      = 0;
        jump        = 0;
        jalr        = 0;
    end
    else begin
        //============================================================
        // Opcode decoding (RISC-V base ISA types)
        //============================================================

        // R-Type: Register-Register operations (ADD, SUB, AND, OR, etc.)
        if (opcode == 7'b0110011) begin
            reg_write   = 1;
            imm_sel     = 2'bxx; // No immediate used
            alu_src     = 0;     // Operand comes from register
            alu_op      = 2'b10; // ALU control will decode funct fields
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 0;     // Write ALU result to register
            branch      = 0;
            jump        = 0;
            jalr        = 0;
        end
        
        // I-Type (except load and JALR): Immediate-Register ALU ops (ADDI, ANDI, etc.)
        else if (opcode == 7'b0010011) begin
            reg_write   = 1;
            imm_sel     = 2'b00; // I-type immediate
            alu_src     = 1;     // Second operand from immediate
            alu_op      = 2'b01; // ALU control for I-type
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 0;
            branch      = 0;
            jump        = 0;
            jalr        = 0;
            p = 1;
        end
        
        // Load (e.g., LW)
        else if (opcode == 7'b0000011) begin
            reg_write   = 1;
            imm_sel     = 2'b00; // I-type immediate for address offset
            alu_src     = 1;     // Base register + offset
            alu_op      = 2'b00; // Add for address calculation
            mem_read    = 1;     // Enable memory read
            mem_write   = 0;
            mem_to_reg  = 1;     // Write memory data to register
            branch      = 0;
            jump        = 0;
            jalr        = 0;
        end
        
        // S-Type: Store (e.g., SW)
        else if (opcode == 7'b0100011) begin
            reg_write   = 0;     // No register write
            imm_sel     = 2'b01; // S-type immediate
            alu_src     = 1;     // Base register + offset
            alu_op      = 2'b00; // Add for address calculation
            mem_read    = 0;
            mem_write   = 1;     // Enable memory write
            mem_to_reg  = 0;     // N/A
            branch      = 0;
            jump        = 0;
            jalr        = 0;
        end
        
        // B-Type: Branch (BEQ, BNE, etc.)
        else if (opcode == 7'b1100011) begin
            reg_write   = 0;     // No register write
            imm_sel     = 2'b10; // B-type immediate
            alu_src     = 0;     // Compare two registers
            alu_op      = 2'b11; // ALU does comparison
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 1'bx;  // Don't care
            branch      = 1;     // Branch decision logic
            jump        = 0;
            jalr        = 0;
        end
        
        // JAL: Jump and Link
        else if (opcode == 7'b1101111) begin
            reg_write   = 1;     // Store return address
            imm_sel     = 2'b11; // J-type immediate
            alu_src     = 1'bx;  // Don't care
            alu_op      = 2'bxx; // ALU not used
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 1'bx;  // Return address comes from PC+4
            branch      = 0;
            jump        = 1;     // Jump enable
            jalr        = 0;
        end
        
        // JALR: Jump and Link Register
        else if (opcode == 7'b1100111) begin
            reg_write   = 1;
            imm_sel     = 2'b00; // I-type immediate
            alu_src     = 1'bx;  // Don't care
            alu_op      = 2'bxx; // ALU not used
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 1'bx;  // Return address comes from PC+4
            branch      = 0;
            jump        = 1;     // Jump enable
            jalr        = 1;     // JALR specific flag
        end
        
        
        
        //barrett modulo multiplication
        
        else if (opcode == 7'b1111111) begin
           reg_write   = 1;
            imm_sel     = 2'bxx; // No immediate used
            alu_src     = 0;     // Operand comes from register
            alu_op      = 2'b10; // ALU control will decode funct fields
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 0;     // Write ALU result to register
            branch      = 0;
            jump        = 0;
            jalr        = 0;
            p = 0;
        end
        
         else if (opcode == 7'b1111110) begin
             reg_write   = 1;
            imm_sel     = 2'b00; // I-type immediate
            alu_src     = 1;     // Second operand from immediate
            alu_op      = 2'b01; // ALU control for I-type
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 0;
            branch      = 0;
            jump        = 0;
            jalr        = 0;
            p=0;
        end
        // Default: Invalid/unsupported instruction
        else begin
            reg_write   = 0;
            imm_sel     = 2'b00;
            alu_src     = 0;
            alu_op      = 2'b00;
            mem_read    = 0;
            mem_write   = 0;
            mem_to_reg  = 0;
            branch      = 0;
            jump        = 0;
            jalr        = 0;
        end
    end
end

endmodule
