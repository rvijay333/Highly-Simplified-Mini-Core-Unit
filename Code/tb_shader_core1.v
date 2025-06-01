```verilog

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
