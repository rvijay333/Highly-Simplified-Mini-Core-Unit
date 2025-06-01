```verilog
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
