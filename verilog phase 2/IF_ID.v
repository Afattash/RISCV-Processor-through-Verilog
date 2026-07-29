module IF_ID (
    input         clk,
    input         reset,
    input         flush,
    input         write,           // Only declare once!
    input  [31:0] instr_in,
    input  [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            instr_out <= 32'b0;
            pc_out    <= 32'b0;
        end else if (write) begin
            instr_out <= instr_in;
            pc_out    <= pc_in;
        end
        // If write == 0, retain previous instr_out and pc_out (stall)
    end

endmodule
