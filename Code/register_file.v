```verilog
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
