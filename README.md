\# RISC-V Pipelined Processor with Modulo Multiplier Unit



\[!\[Language](https://img.shields.io/badge/HDL-Verilog-00C8D7?style=flat-square)]()

\[!\[Simulator](https://img.shields.io/badge/Simulator-Vivado%20XSim-0D2137?style=flat-square)]()

\[!\[Pipeline](https://img.shields.io/badge/Pipeline-5--Stage-00D68F?style=flat-square)]()

\[!\[Hazards](https://img.shields.io/badge/Hazards-Forwarding%20%2B%20Stall-FFB830?style=flat-square)]()



A fully pipelined \*\*5-stage RISC-V RV32I processor\*\* implemented in Verilog, extended with a custom \*\*Modulo Multiplier hardware unit\*\* as an application-specific accelerator. Simulated and verified in Vivado XSim.



\---



\## Repository Structure



```

riscv-processor-design/

│

├── README.md

│

├── rtl/

│   ├── riscv\_top.v              # Top-level: connects all pipeline units

│   ├── datapath\_unit.v          # Pipeline registers + ALU + memory interface

│   ├── ctrlpath\_unit.v          # Control signal generation from opcode

│   ├── branch\_ctrl\_unit.v       # Branch/jump resolution

│   ├── fwd\_unit.v               # Data hazard forwarding unit

│   ├── stall\_unit.v             # Load-use hazard stall unit

│   ├── datapath\_subunits.v      # ALU, register file, immediate generator

│   └── mod\_mult\_clk.v           # Custom modulo multiplier unit

│

├── rtl/posit/                   # Posit arithmetic support modules

│   ├── posit\_decoder.v

│   ├── posit\_encoder.v

│   ├── f\_multiplier.v

│   ├── PLAM.v                   # Posit Linear Approximation Multiplier

│   ├── adder.v

│   ├── lod.v / lod\_encoder\_15bit.v

│   ├── L\_Shifter.sv / R\_Shifter.sv / shifterR.sv

│   └── mux2\_1\_posit.v

│

├── testbench/

│   └── riscv\_tb.v               # Top-level testbench with program memory

│

├── simulation/

│   ├── prog.mem                 # Test program (machine code)

│   └── riscv\_tb\_behav.wcfg     # Vivado waveform config

│

└── docs/

&#x20;   └── pipeline\_diagram.md      # Detailed pipeline description

```



\---



\## Architecture Overview



\### 5-Stage Pipeline



```

&#x20;   ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐    ┌──────┐

&#x20;   │  IF  │ →  │  ID  │ →  │  EX  │ →  │  MEM │ →  │  WB  │

&#x20;   │Fetch │    │Decode│    │Execute    │Memory│    │Write │

&#x20;   │      │    │      │    │  ALU │    │Access│    │ Back │

&#x20;   └──────┘    └──────┘    └──────┘    └──────┘    └──────┘

&#x20;       ↑                       │                       │

&#x20;       │    ┌──────────────────┘                       │

&#x20;       │    │   Forwarding Unit (EX/MEM → EX)          │

&#x20;       │    └──────────────────────────────────────────┘

&#x20;       │

&#x20;       └── Stall Unit (load-use hazard detection)

```



\### Module Hierarchy



```

riscv\_top

├── datapath\_unit        ← pipeline registers, ALU, register file, memory

├── ctrlpath\_unit        ← opcode → control signals (reg\_write, alu\_src, branch…)

├── branch\_ctrl\_unit     ← computes branch taken/not taken from ALU flags

├── fwd\_unit             ← 2-bit forward\_rs1 / forward\_rs2 select signals

└── stall\_unit           ← detects load-use hazard, asserts stall + flush

```



\---



\## Hazard Handling



\### Data Hazards — Forwarding Unit (`fwd\_unit.v`)



Resolves RAW (Read After Write) hazards by forwarding results from later pipeline stages back to the EX stage — eliminating stalls for most ALU-ALU dependencies.



```

forward\_rs1 / forward\_rs2 encoding:

&#x20; 2'b00  → No forwarding  (use register file read output)

&#x20; 2'b01  → Forward from EX/MEM stage  (just-computed ALU result)

&#x20; 2'b10  → Forward from MEM/WB stage  (loaded data or earlier ALU result)

```



Forwarding conditions:

```verilog

// EX/MEM forwarding: ex\_mem\_rd == id\_ex\_rs1 AND ex\_mem\_reg\_write

// MEM/WB forwarding: mem\_wb\_rd == id\_ex\_rs1 AND mem\_wb\_reg\_write

// Priority: EX/MEM over MEM/WB (most recent result wins)

```



\### Load-Use Hazard — Stall Unit (`stall\_unit.v`)



When a `LOAD` instruction is followed immediately by an instruction that uses the loaded value, forwarding alone cannot resolve the hazard (memory data is not available until end of MEM stage). The stall unit inserts \*\*one pipeline bubble\*\*:



```

Condition: id\_ex\_mem\_read == 1

&#x20;          AND (id\_ex\_rd == if\_id\_rs1 OR id\_ex\_rd == if\_id\_rs2)



Action:    stall = 1  → freeze IF/ID register, freeze PC

&#x20;          flush = 1  → clear ID/EX register (insert NOP bubble)

```



\### Control Hazards — Branch Resolution



Branch outcome is resolved at the \*\*end of EX stage\*\*. On a taken branch, the instruction fetched into IF and the instruction in ID are flushed (2-cycle branch penalty).



\---



\## Supported Instructions (RV32I Subset)



| Type | Instructions |

|---|---|

| R-type | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SLT` |

| I-type | `ADDI`, `ANDI`, `ORI`, `XORI`, `SLTI`, `SLLI`, `SRLI`, `LW` |

| S-type | `SW` |

| B-type | `BEQ`, `BNE`, `BLT`, `BGE` |

| J-type | `JAL`, `JALR` |



\---



\## Custom Hardware Unit — Modulo Multiplier (`mod\_mult\_clk.v`)



An application-specific hardware accelerator implementing \*\*Montgomery-style modulo multiplication\*\* for use in cryptographic and arithmetic-intensive workloads.



\### Algorithm



Implements the \*\*classic modular multiplication\*\* algorithm:



```

Inputs : x \[15:0], y \[15:0], M \[15:0]

Output : result = (x × y) mod M



Parameters:

&#x20; N = 12    (operand width)

&#x20; m = 4     (digit width)

&#x20; r = 16    (radix = 2^m)

&#x20; d = 5     (number of reduction steps)

&#x20; mu = 3050 (pre-computed constant for Barrett reduction)

```



\### Digit-Serial Architecture



The multiplier processes `y` in 4-bit digits (`yp0`–`yp4`) and iteratively accumulates partial products, performing modular reduction at each step to keep intermediate results bounded.



```

y is split into digits:  yp0=y(-2)=0, yp1=y(-1)=0, yp2=y\[3:0], yp3=y\[7:4], yp4=y\[11:8]

Partial product accumulation + Barrett reduction per digit

Final result: (x × y) mod M, 16-bit output

```



\### Interface



```verilog

module mod\_mult\_clk (

&#x20;   input  \[15:0] x,       // Multiplicand

&#x20;   input  \[15:0] y,       // Multiplier

&#x20;   input  \[15:0] M,       // Modulus

&#x20;   output reg \[15:0] result  // (x × y) mod M

);

```



\---



\## Simulation \& Verification



\### Running in Vivado



```tcl

\# Open project

vivado posit\_mul\_riscv/posit\_mul\_riscv.xpr



\# Run simulation

launch\_simulation

run all



\# View waveforms

open\_wave\_config posit\_mul\_riscv.srcs/sim\_1/imports/coa\_project/riscv\_tb\_behav.wcfg

```



\### Running XSim from command line



```bash

cd posit\_mul\_riscv.sim/sim\_1/behav/xsim

bash compile.sh

bash elaborate.sh

bash simulate.sh

```



\### Test Program



`simulation/prog.mem` contains a hand-assembled RISC-V test program that exercises:

\- Arithmetic instructions (ADD, ADDI, SUB)

\- Load/store (LW, SW)

\- Branches (BEQ, BNE) including taken and not-taken cases

\- Jump instructions (JAL)

\- Load-use hazard sequences (verifies stall insertion)

\- Forwarding paths (EX/MEM and MEM/WB)



\---



\## Control Path — Signal Summary



| Signal | Source | Destination | Function |

|---|---|---|---|

| `reg\_write` | ctrlpath | WB stage | Enable register file write |

| `alu\_src` | ctrlpath | EX stage | 0=reg, 1=immediate |

| `mem\_read` | ctrlpath | MEM stage | Enable data memory read |

| `mem\_write` | ctrlpath | MEM stage | Enable data memory write |

| `mem\_to\_reg` | ctrlpath | WB stage | 0=ALU result, 1=memory data |

| `branch` | ctrlpath | branch\_ctrl | This is a branch instruction |

| `jump` | ctrlpath | datapath | Unconditional jump (JAL) |

| `jalr` | ctrlpath | datapath | Register-indirect jump |

| `alu\_op\[1:0]` | ctrlpath | EX stage | ALU operation class |

| `imm\_sel\[1:0]` | ctrlpath | ID stage | Immediate type (I/S/B/U/J) |

| `stall` | stall\_unit | IF+ID | Freeze pipeline stages |

| `flush` | branch\_ctrl | ID/EX | Clear pipeline register |

| `forward\_rs1\[1:0]` | fwd\_unit | EX MUX | Source for operand A |

| `forward\_rs2\[1:0]` | fwd\_unit | EX MUX | Source for operand B |



\---



\## Tools



| Tool | Version | Purpose |

|---|---|---|

| Vivado | 2022.2 | Synthesis, simulation, waveform viewing |

| XSim | bundled | Behavioural simulation |

| Verilog | IEEE 1364-2001 | RTL implementation |



\---



\## Future Work



\- Add `MUL`/`DIV` instructions (RV32M extension) using the modulo multiplier unit

\- Implement branch predictor (static/dynamic) to reduce branch penalty

\- Integrate with FPGA memory-mapped I/O for bare-metal program loading

\- Carry out FPGA synthesis and report resource utilisation on Artix-7

