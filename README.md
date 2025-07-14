# 🧠 Mini Pipelined CPU (Verilog)

This is my **first CPU core**, built entirely in Verilog from scratch. It implements a **5-stage pipelined architecture** 
using a **2-phase clocking scheme (clk1 and clk2)**. The design executes a small set of ALU instructions like `ADD`, `SUB`, `MUL`, `AND`, `OR`, 
and their immediate counterparts (`ADDI`, `SUBI`).

---

## 📜 Project Objective

- Simulate a classic 5-stage CPU pipeline:
  - **IF**: Instruction Fetch
  - **ID**: Instruction Decode / Register Read
  - **EX**: Execute
  - **MEM**: Memory Access
  - **WB**: Write Back
- Use a **dual-phase clock** (clk1, clk2) to separate alternate stages.
- Observe and understand **pipeline hazards**, especially RAW (Read After Write).

---

## 🏗️ Architecture Overview

### 🔁 Clock Phases
- `clk1`: Drives IF, EX, WB stages.
- `clk2`: Drives ID, MEM stages.

### 📦 Registers
- `Reg[0:31]`: 32 general-purpose 32-bit registers.
- `Mem[0:1023]`: Instruction memory.

### 🔧 Supported Instructions

| Mnemonic | Opcode   | Type | Description                 |
|----------|----------|------|-----------------------------|
| ADD      | 000000   | R    | `Rd = Rs + Rt`              |
| SUB      | 000001   | R    | `Rd = Rs - Rt`              |
| MUL      | 000010   | R    | `Rd = Rs * Rt`              |
| AND      | 000011   | R    | `Rd = Rs & Rt`              |
| OR       | 000100   | R    | `Rd = Rs | Rt`              |
| ADDI     | 000101   | I    | `Rt = Rs + Imm`             |
| SUBI     | 000110   | I    | `Rt = Rs - Imm`             |
| NOP      | 11CE7000 | N/A  | Used to pad pipeline        |

---

## 🚧 Limitations & Learnings

> ❗ **This CPU does not handle pipeline hazards.**

- **RAW hazards** occur due to data dependencies between close instructions.
- No forwarding or stalling logic is implemented — this was intentional to visualize hazards.
- This CPU is a perfect base to implement:
  - Hazard detection units
  - Forwarding paths
  - Pipeline flushing for branches

---

## 🔍 Sample Output (Verilog Testbench)

```verilog
DUT.Mem[0] = 32'h14010005; // ADDI R1, R0, 5
DUT.Mem[1] = 32'h14020007; // ADDI R2, R0, 7
DUT.Mem[7] = 32'h00221804; // ADD R4, R1, R2 => Expected 12
```
📘 Lessons Learned:
-Understood each stage of CPU pipelining
-Saw the effects of missing hazard resolution
-Gained confidence in writing structured Verilog
-Learned how to debug using monitor, $dumpvars, and GTKWave

🛠️ Tools Used
--Verilog (Icarus Verilog)
--GTKWave
--VS Code
--GitHub

