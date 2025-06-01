```verilog
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
