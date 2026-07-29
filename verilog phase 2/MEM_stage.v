`include "Data_memory.v"

module MEM_stage (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input [31:0] alu_result,
    input [31:0] write_data,

    output [31:0] mem_read_data
);

    Data_memory RAM (
        .clk(clk),
        .addr(alu_result),        // <-- FIXED: pass full 32-bit address!
        .mem_write(mem_write),
        .mem_read(mem_read),
        .write_data(write_data),
        .read_data(mem_read_data)
    );
    always @(posedge clk) begin
    if (mem_read) $display("MEM_stage: Reading from addr=%h, got data=%h", alu_result, mem_read_data);
    if (mem_write) $display("MEM_stage: Writing %h to addr=%h", write_data, alu_result);
end


endmodule
