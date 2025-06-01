```verilog
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
