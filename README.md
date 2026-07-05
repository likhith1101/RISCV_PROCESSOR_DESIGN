# RISC-V Pipelined Processor with Modulo Multiplier Unit

[![Language](https://img.shields.io/badge/HDL-Verilog-00C8D7?style=flat-square)]()
[![Simulator](https://img.shields.io/badge/Simulator-Vivado%20XSim-0D2137?style=flat-square)]()
[![Pipeline](https://img.shields.io/badge/Pipeline-5--Stage-00D68F?style=flat-square)]()
[![Hazards](https://img.shields.io/badge/Hazards-Forwarding%20%2B%20Stall-FFB830?style=flat-square)]()

A fully pipelined **5-stage RISC-V RV32I processor** implemented in Verilog, extended with a custom **Modulo Multiplier hardware unit** as an application-specific accelerator. Simulated and verified in Vivado XSim.

---

## Repository Structure

```
riscv-processor-design/
│
├── README.md
│
├── rtl/
│   ├── riscv_top.v              # Top-level: connects all pipeline units
│   ├── datapath_unit.v          # Pipeline registers + ALU + memory interface
│   ├── ctrlpath_unit.v          # Control signal generation from opcode
│   ├── branch_ctrl_unit.v       # Branch/jump resolution
│   ├── fwd_unit.v               # Data hazard forwarding unit
│   ├── stall_unit.v             # Load-use hazard stall unit
│   ├── datapath_subunits.v      # ALU, register file, immediate generator
│   └── mod_mult_clk.v           # Custom modulo multiplier unit
│
├── rtl/posit/                   # Posit arithmetic support modules
│   ├── posit_decoder.v
│   ├── posit_encoder.v
│   ├── f_multiplier.v
│   ├── PLAM.v                   # Posit Linear Approximation Multiplier
│   ├── adder.v
│   ├── lod.v / lod_encoder_15bit.v
│   ├── L_Shifter.sv / R_Shifter.sv / shifterR.sv
│   └── mux2_1_posit.v
│
├── testbench/
│   └── riscv_tb.v               # Top-level testbench with program memory
│
├── simulation/
│   ├── prog.mem                 # Test program (machine code)
│   └── riscv_tb_behav.wcfg     # Vivado waveform config
│
└── docs/
    └── pipeline_diagram.md      # Detailed pipeline description
```

---

## Architecture Overview

### 5-Stage Pipeline

```
    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐
    │  IF  │ →  │  ID  │ →  │  EX  │ →  │  MEM │ →  │  WB  │
    │Fetch │    │Decode│    │Execute    │Memory│    │Write │
    │      │    │      │    │  ALU │    │Access│    │ Back │
    └──────┘    └──────┘    └──────┘    └──────┘    └──────┘
        ↑                       │                       │
        │    ┌──────────────────┘                       │
        │    │   Forwarding Unit (EX/MEM → EX)          │
        │    └──────────────────────────────────────────┘
        │
        └── Stall Unit (load-use hazard detection)
```

### Module Hierarchy

```
riscv_top
├── datapath_unit        ← pipeline registers, ALU, register file, memory
├── ctrlpath_unit        ← opcode → control signals (reg_write, alu_src, branch…)
├── branch_ctrl_unit     ← computes branch taken/not taken from ALU flags
├── fwd_unit             ← 2-bit forward_rs1 / forward_rs2 select signals
└── stall_unit           ← detects load-use hazard, asserts stall + flush
```

---

## Hazard Handling

### Data Hazards — Forwarding Unit (`fwd_unit.v`)

Resolves RAW (Read After Write) hazards by forwarding results from later pipeline stages back to the EX stage — eliminating stalls for most ALU-ALU dependencies.

```
forward_rs1 / forward_rs2 encoding:
  2'b00  → No forwarding  (use register file read output)
  2'b01  → Forward from EX/MEM stage  (just-computed ALU result)
  2'b10  → Forward from MEM/WB stage  (loaded data or earlier ALU result)
```

Forwarding conditions:
```verilog
// EX/MEM forwarding: ex_mem_rd == id_ex_rs1 AND ex_mem_reg_write
// MEM/WB forwarding: mem_wb_rd == id_ex_rs1 AND mem_wb_reg_write
// Priority: EX/MEM over MEM/WB (most recent result wins)
```

### Load-Use Hazard — Stall Unit (`stall_unit.v`)

When a `LOAD` instruction is followed immediately by an instruction that uses the loaded value, forwarding alone cannot resolve the hazard (memory data is not available until end of MEM stage). The stall unit inserts **one pipeline bubble**:

```
Condition: id_ex_mem_read == 1
           AND (id_ex_rd == if_id_rs1 OR id_ex_rd == if_id_rs2)

Action:    stall = 1  → freeze IF/ID register, freeze PC
           flush = 1  → clear ID/EX register (insert NOP bubble)
```

### Control Hazards — Branch Resolution

Branch outcome is resolved at the **end of EX stage**. On a taken branch, the instruction fetched into IF and the instruction in ID are flushed (2-cycle branch penalty).

---

## Supported Instructions (RV32I Subset)

| Type | Instructions |
|---|---|
| R-type | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SLT` |
| I-type | `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `LW` |
| S-type | `SW` |
| B-type | `BEQ`, `BNE`, `BLT`, `BGE` |
| J-type | `JAL`, `JALR` |

---

## Custom Hardware Unit — Modulo Multiplier (`mod_mult_clk.v`)

An application-specific hardware accelerator implementing **Montgomery-style modulo multiplication** for use in cryptographic and arithmetic-intensive workloads.

### Algorithm

Implements the **classic modular multiplication** algorithm:

```
Inputs : x [15:0], y [15:0], M [15:0]
Output : result = (x × y) mod M

Parameters:
  N = 12    (operand width)
  m = 4     (digit width)
  r = 16    (radix = 2^m)
  d = 5     (number of reduction steps)
  mu = 3050 (pre-computed constant for Barrett reduction)
```

### Digit-Serial Architecture

The multiplier processes `y` in 4-bit digits (`yp0`–`yp4`) and iteratively accumulates partial products, performing modular reduction at each step to keep intermediate results bounded.

```
y is split into digits:  yp0=y(-2)=0, yp1=y(-1)=0, yp2=y[3:0], yp3=y[7:4], yp4=y[11:8]
Partial product accumulation + Barrett reduction per digit
Final result: (x × y) mod M, 16-bit output
```

### Interface

```verilog
module mod_mult_clk (
    input  [15:0] x,       // Multiplicand
    input  [15:0] y,       // Multiplier
    input  [15:0] M,       // Modulus
    output reg [15:0] result  // (x × y) mod M
);
```

---

## Simulation & Verification

### Running in Vivado

```tcl
# Open project
vivado posit_mul_riscv/posit_mul_riscv.xpr

# Run simulation
launch_simulation
run all

# View waveforms
open_wave_config posit_mul_riscv.srcs/sim_1/imports/coa_project/riscv_tb_behav.wcfg
```

### Running XSim from command line

```bash
cd posit_mul_riscv.sim/sim_1/behav/xsim
bash compile.sh
bash elaborate.sh
bash simulate.sh
```

### Test Program

`simulation/prog.mem` contains a hand-assembled RISC-V test program that exercises:
- Arithmetic instructions (ADD, ADDI, SUB)
- Load/store (LW, SW)
- Branches (BEQ, BNE) including taken and not-taken cases
- Jump instructions (JAL)
- Load-use hazard sequences (verifies stall insertion)
- Forwarding paths (EX/MEM and MEM/WB)

---

## Control Path — Signal Summary

| Signal | Source | Destination | Function |
|---|---|---|---|
| `reg_write` | ctrlpath | WB stage | Enable register file write |
| `alu_src` | ctrlpath | EX stage | 0=reg, 1=immediate |
| `mem_read` | ctrlpath | MEM stage | Enable data memory read |
| `mem_write` | ctrlpath | MEM stage | Enable data memory write |
| `mem_to_reg` | ctrlpath | WB stage | 0=ALU result, 1=memory data |
| `branch` | ctrlpath | branch_ctrl | This is a branch instruction |
| `jump` | ctrlpath | datapath | Unconditional jump (JAL) |
| `jalr` | ctrlpath | datapath | Register-indirect jump |
| `alu_op[1:0]` | ctrlpath | EX stage | ALU operation class |
| `imm_sel[1:0]` | ctrlpath | ID stage | Immediate type (I/S/B/U/J) |
| `stall` | stall_unit | IF+ID | Freeze pipeline stages |
| `flush` | branch_ctrl | ID/EX | Clear pipeline register |
| `forward_rs1[1:0]` | fwd_unit | EX MUX | Source for operand A |
| `forward_rs2[1:0]` | fwd_unit | EX MUX | Source for operand B |

---

## Tools

| Tool | Version | Purpose |
|---|---|---|
| Vivado | 2022.2 | Synthesis, simulation, waveform viewing |
| XSim | bundled | Behavioural simulation |
| Verilog | IEEE 1364-2001 | RTL implementation |

---

## Future Work

- Add `MUL`/`DIV` instructions (RV32M extension) using the modulo multiplier unit
- Implement branch predictor (static/dynamic) to reduce branch penalty
- Integrate with FPGA memory-mapped I/O for bare-metal program loading
- Carry out FPGA synthesis and report resource utilisation on Artix-7
