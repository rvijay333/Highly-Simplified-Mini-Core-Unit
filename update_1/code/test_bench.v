module update1_tb_shader_core;
    reg clk, rst;

    // Instantiate the updated shader core
    update1_shader_core uut (
        .clk(clk),
        .reset(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump_update1.vcd");
        $dumpvars(0, update1_tb_shader_core);

        // Initialize operands
        uut.rf.regs[0] = 16'd4;
        uut.rf.regs[1] = 16'd3;


        clk = 0;
        rst = 1;
        #10;
        rst = 0;

        // Run for some clock cycles to execute instructions
        #100;

        // Display register contents after execution
        $display("\nRegister File Contents:");
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


