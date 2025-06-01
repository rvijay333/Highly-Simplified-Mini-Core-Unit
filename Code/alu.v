```verilog
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
