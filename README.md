# Highly-Simplified-Mini-Core-Unit
This is a starting steps , of my larger goal to build a GPU .  This consists of simplified unit of a very low basic GPU
# Mini Shader Core – RTL Design (Simplified GPU Component)

This project is a simplified RTL implementation of a **shader core**, a key component in a GPU (Graphics Processing Unit). It demonstrates how a basic data path is constructed using a **Register File**, an **Arithmetic Logic Unit (ALU)**, and simple instruction decoding logic.

---

## 📌 What This Project Does

- Reads 16-bit instructions with opcode and register addresses.
- Fetches operands from a register file.
- Executes ALU operations based on the 3-bit opcode.
- Stores results back into a register.
- Simulates and displays waveforms using GTKWave.

---

## ⚙️ Instruction Format (16-bit)

[15:13] - Opcode (3 bits)
[12:10] - Read Register A
[9:7] - Read Register B
[6:4] - Write Register
[3:0] - Unused (reserved)


For example:  
Opcode `3'b000` means **ADD**  
Opcode `3'b001` means **SUB**

---

## 🧮 Supported ALU Operations

| Opcode | Operation | Description         |
|--------|-----------|---------------------|
| 000    | ADD       | Add two numbers     |
| 001    | SUB       | Subtract            |
| 010    | AND       | Bitwise AND         |
| 011    | OR        | Bitwise OR          |
| 100    | XOR       | Bitwise XOR         |
| 101    | MUL       | Multiply            |
| 110    | SHL       | Shift Left          |
| 111    | SHR       | Shift Right         |

---


## 🧪 Simulation Steps

```bash
# Compile everything using Icarus Verilog
iverilog -o shader_core_tb.vvp code/.v/shader_core.v code/.v/reg_file.v code/.v/alu.v code/.v/tb_shader_core.v

# Run simulation
vvp shader_core_tb.vvp

# View waveform
gtkwave dump.vcd

## RESULTS :
### For tb_shader_core.v




### For tb_shader_core1.v


