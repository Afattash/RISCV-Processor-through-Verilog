module Register_file(
    input         clk,
    input         reset,
    input  [4:0]  Rs1,
    input  [4:0]  Rs2,
    input  [4:0]  Rd,
    input         RegWrite,
    input  [31:0] Write_data,
    output [31:0] Read_data1,
    output [31:0] Read_data2
);
    reg [31:0] registers [0:31];
    integer i;
    // Read ports (combinational)
    assign Read_data1 = registers[Rs1];
    assign Read_data2 = registers[Rs2];

    // Synchronous write port
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Optionally clear all registers except x0
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (RegWrite && Rd != 0) begin
            registers[Rd] <= Write_data;
            $display("WRITE: x%0d <= %h at time %0t", Rd, Write_data, $time);
        end
    end
endmodule
