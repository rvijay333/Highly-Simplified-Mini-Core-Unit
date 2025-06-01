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
```
## THE CODE:
### ALU :
```
module alu (
    input [2:0] opcode,
    input [15:0] a, b,
    output reg [15:0] result
);
    always @(*) begin
        case (opcode)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = a * b;
            3'b110: result = a << 1;
            3'b111: result = a >> 1;
            default: result = 0;
        endcase
    end
endmodule
```

### INSTRUCTION DECODER :
```
module instr_decoder (
    input [15:0] instr,
    output [2:0] opcode,
    output [2:0] ra, rb, wa
);
    assign opcode = instr[15:13];
    assign ra     = instr[12:10]; // first operand address
    assign rb     = instr[9:7];   // second operand address
    assign wa     = instr[6:4];   // write address
endmodule

```
### REGISTER FILE :
```
module reg_file (
    input clk,
    input [2:0] ra, rb, wa,         // ra=address of a , rb = addresss of b , wa = whcih address to write into 
    input [15:0] wd,                // data to write 
    input we,                      // writing can be done only if we=1 , write enable 
    output [15:0] rd_a, rd_b       // data ouput of the regs , ie; data from a and b
);
    reg [15:0] regs [7:0];        // we have 8 , 16bit regs
 
    assign rd_a = regs[ra];       // output of a (first operand) = is present at address given in ra
    assign rd_b = regs[rb];       // output of b (second operand) = is present at address given in rb

    always @(posedge clk) begin
        if (we)                   // if we==1
            regs[wa] <= wd;      // only then u can write data into the registers , else you are only allowed to read data 
    end
endmodule

```

### CORE :
```
module shader_core (
    input clk,
    input [15:0] instr
);
    wire [2:0] opcode, ra, rb, wa;
    wire [15:0] rd_a, rd_b, result;

    instr_decoder decoder (
        .instr(instr),
        .opcode(opcode),
        .ra(ra),
        .rb(rb),
        .wa(wa)
    );

    reg_file rf (
        .clk(clk),
        .ra(ra),
        .rb(rb),
        .wa(wa),
        .wd(result),
        .we(1'b1),       // always writing result for simplicity
        .rd_a(rd_a),
        .rd_b(rd_b)
    );

    alu alu_unit (
        .opcode(opcode),
        .a(rd_a),
        .b(rd_b),
        .result(result)
    );
endmodule

```

### TEST BENCH:
```
module tb_shader_core;
    reg clk;
    reg [15:0] instr;

    // Instantiate shader_core
    shader_core uut (
        .clk(clk),
        .instr(instr)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_shader_core);

        clk = 0;

        // Initialize operands
        uut.rf.regs[0] = 16'd4;
        uut.rf.regs[1] = 16'd3;

        #10;

        // Operation 0: ADD (opcode = 000), reg[2] = reg[0] + reg[1]
        instr = {3'b000, 3'd0, 3'd1, 3'd2, 4'b0001};
        #10;
        $display("ADD: reg[2] = %d (reg[0] + reg[1] = %d + %d)", uut.rf.regs[2], uut.rf.regs[0], uut.rf.regs[1]);

        // Operation 1: SUB, reg[3] = reg[0] - reg[1]
        instr = {3'b001, 3'd0, 3'd1, 3'd3, 4'b0001};
        #10;
        $display("SUB: reg[3] = %d (reg[0] - reg[1] = %d - %d)", uut.rf.regs[3], uut.rf.regs[0], uut.rf.regs[1]);

        // Operation 2: AND, reg[4] = reg[0] & reg[1]
        instr = {3'b010, 3'd0, 3'd1, 3'd4, 4'b0001};
        #10;
        $display("AND: reg[4] = %d (reg[0] & reg[1] = %d & %d)", uut.rf.regs[4], uut.rf.regs[0], uut.rf.regs[1]);

        // Operation 3: OR, reg[5] = reg[0] | reg[1]
        instr = {3'b011, 3'd0, 3'd1, 3'd5, 4'b0001};
        #10;
        $display("OR : reg[5] = %d (reg[0] | reg[1] = %d | %d)", uut.rf.regs[5], uut.rf.regs[0], uut.rf.regs[1]);

        // Operation 4: XOR, reg[6] = reg[0] ^ reg[1]
        instr = {3'b100, 3'd0, 3'd1, 3'd6, 4'b0001};
        #10;
        $display("XOR: reg[6] = %d (reg[0] ^ reg[1] = %d ^ %d)", uut.rf.regs[6], uut.rf.regs[0], uut.rf.regs[1]);

        // Operation 5: MUL, reg[7] = reg[0] * reg[1]
        instr = {3'b101, 3'd0, 3'd1, 3'd7, 4'b0001};
        #10;
        $display("MUL: reg[7] = %d (reg[0] * reg[1] = %d * %d)", uut.rf.regs[7], uut.rf.regs[0], uut.rf.regs[1]);

        // Final full register display
        $display("\nFinal Register Contents:");
        $display("reg[0] = %d", uut.rf.regs[0]);
        $display("reg[1] = %d", uut.rf.regs[1]);
        $display("reg[2] = %d", uut.rf.regs[2]);
        $display("reg[3] = %d", uut.rf.regs[3]);
        $display("reg[4] = %d", uut.rf.regs[4]);
        $display("reg[5] = %d", uut.rf.regs[5]);
        $display("reg[6] = %d", uut.rf.regs[6]);
        $display("reg[7] = %d", uut.rf.regs[7]);

        $finish;
    end
endmodule
// IGNORE THE LAST FOUR BITS OF INSTRUCTION , THEY ARE SERVING NO PURPOSE 
              // WE HAVE BY DEFAULT KEPT WE==1'B1 , SO NO USE OF LAST FOUR BITS 
              // IF WE HAD NOT KEPT WE=1 , THEN MAYBE WE COULD HAVE USED LAST FOUR BITS FOR ENABLING OR DISABLING THE WE(WRITE ENABLE SIGNAL)

```
in this test bench , there are fixed inputs in reg[0] and reg[1] , and results are updated in reg[2] to reg[7]

### TEST BECNCH 1 :
```

// this testbench , has different operands for each instruction 
module tb_shader_core_ops_to_reg7;
    reg clk;
    reg [15:0] instr;

    // Instantiate shader_core
    shader_core uut (
        .clk(clk),
        .instr(instr)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_shader_core_ops_to_reg7);

        clk = 0;

        // Preload operands in reg[0] to reg[6]
        uut.rf.regs[0] = 16'd5;
        uut.rf.regs[1] = 16'd2;
        uut.rf.regs[2] = 16'd15;
        uut.rf.regs[3] = 16'd8;
        uut.rf.regs[4] = 16'd10;
        uut.rf.regs[5] = 16'd6;
        uut.rf.regs[6] = 16'd3;

        #10;

        // ADD reg[7] = reg[0] + reg[1] => 5 + 2 = 7
        instr = {3'b000, 3'd0, 3'd1, 3'd7, 4'b0001}; #10;
        $display("ADD: %0d + %0d = %0d", uut.rf.regs[0], uut.rf.regs[1], uut.rf.regs[7]);

        // SUB reg[7] = reg[2] - reg[3] => 15 - 8 = 7
        instr = {3'b001, 3'd2, 3'd3, 3'd7, 4'b0001}; #10;
        $display("SUB: %0d - %0d = %0d", uut.rf.regs[2], uut.rf.regs[3], uut.rf.regs[7]);

        // AND reg[7] = reg[4] & reg[5] => 10 & 6 = 2
        instr = {3'b010, 3'd4, 3'd5, 3'd7, 4'b0001}; #10;
        $display("AND: %0d & %0d = %0d", uut.rf.regs[4], uut.rf.regs[5], uut.rf.regs[7]);

        // OR reg[7] = reg[1] | reg[6] => 2 | 3 = 3
        instr = {3'b011, 3'd1, 3'd6, 3'd7, 4'b0001}; #10;
        $display("OR: %0d | %0d = %0d", uut.rf.regs[1], uut.rf.regs[6], uut.rf.regs[7]);

        // XOR reg[7] = reg[0] ^ reg[4] => 5 ^ 10 = 15
        instr = {3'b100, 3'd0, 3'd4, 3'd7, 4'b0001}; #10;
        $display("XOR: %0d ^ %0d = %0d", uut.rf.regs[0], uut.rf.regs[4], uut.rf.regs[7]);

        // MUL reg[7] = reg[3] * reg[6] => 8 * 3 = 24
        instr = {3'b101, 3'd3, 3'd6, 3'd7, 4'b0001}; #10;
        $display("MUL: %0d * %0d = %0d", uut.rf.regs[3], uut.rf.regs[6], uut.rf.regs[7]);

        // SLL reg[7] = reg[2] << 1 => 15 << 1 = 30
        instr = {3'b110, 3'd2, 3'd2, 3'd7, 4'b0001}; #10;
        $display("SLL: %0d << 1 = %0d", uut.rf.regs[2], uut.rf.regs[7]);

        // SRL reg[7] = reg[5] >> 1 => 6 >> 1 = 3
        instr = {3'b111, 3'd5, 3'd5, 3'd7, 4'b0001}; #10;
        $display("SRL: %0d >> 1 = %0d", uut.rf.regs[5], uut.rf.regs[7]);

        $finish;
    end
endmodule     // IGNORE THE LAST FOUR BITS OF INSTRUCTION , THEY ARE SERVING NO PURPOSE 
              // WE HAVE BY DEFAULT KEPT WE==1'B1 , SO NO USE OF LAST FOUR BITS 
              // IF WE HAD NOT KEPT WE=1 , THEN MAYBE WE COULD HAVE USED LAST FOUR BITS FOR ENABLING OR DISABLING THE WE(WRITE ENABLE SIGNAL)

```
in this test bench , there are different operands stored in , reg[0] to reg[6] , while reg[7] is updated with result values according to the incoming instruction
## RESULTS :
### For tb_shader_core.v
![simulation result](https://github.com/rvijay333/Highly-Simplified-Mini-Core-Unit/blob/main/Results/testbench_display.png)
![gtkwave result](https://github.com/rvijay333/Highly-Simplified-Mini-Core-Unit/blob/main/Results/project_testbench_gtkwave.png)

### For tb_shader_core1.v
![simulation result](https://github.com/rvijay333/Highly-Simplified-Mini-Core-Unit/blob/main/Results/testbench1_display.png)
![gtkwave result](https://github.com/rvijay333/Highly-Simplified-Mini-Core-Unit/blob/main/Results/project_testbench1_gtkwave.png)


