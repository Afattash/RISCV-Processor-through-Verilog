module Data_memory (
    input wire clk,
    input wire [31:0] addr,         // Full byte address (from ALU)
    input wire mem_write,
    input wire mem_read,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] RAM_memory [0:1023]; // 4 KB, word-addressable

    wire [9:0] word_addr = addr[11:2]; // Word address (ignore lowest 2 bits)

    // Optional: initialize first few locations
    initial begin
        RAM_memory[0] <= 32'hFFFFFFFF;
        RAM_memory[1] <= 32'hFFFFFFFF;
        RAM_memory[2] <= 32'hFFFFFFFF;
        RAM_memory[3] <= 32'hFFFFFFFF;
    end

    // Write on rising clock
    always @(posedge clk) begin
        if (mem_write) begin
            RAM_memory[word_addr] <= write_data;
        end
    end

    // Read combinationally
    always @(*) begin
        if (mem_read) begin
            read_data = RAM_memory[word_addr];
        end else begin
            read_data = 32'b0;
        end
    end

endmodule
