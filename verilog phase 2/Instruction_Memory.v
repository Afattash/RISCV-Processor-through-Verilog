module Instruction_Memory (
    input  wire [7:0]  read_address,        // Supports 256 instructions
    output wire [31:0] instruction_out
);
    reg [31:0] memory_array [0:255];
    integer i; // <-- Declare here, outside initial!

    assign instruction_out = memory_array[read_address];

    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory_array[i] = 32'b0; // Clear all to NOP
        $readmemh("test.hex", memory_array); // Load program
    end
endmodule
