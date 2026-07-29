`timescale 1ns/1ps
`include "PC.v"  

module PC_tb();

    reg clk, reset;
    reg [31:0] PC_in;

    wire [31:0] PC_out;

    PC uut (
        .clk(clk),
        .reset(reset),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period 10ns
    end

    initial begin
        $display("Starting PC Test...");

        // Apply reset
        reset = 1;
        PC_in = 32'h12345678;  // Some random value
        #10;

        reset = 0;  // Release reset

        // Test 1: Load 0x4 into PC
        PC_in = 32'h00000004;
        #10;
        $display("PC_out = %h", PC_out);

        // Test 2: Load 0x8 into PC
        PC_in = 32'h00000008;
        #10;
        $display("PC_out = %h", PC_out);

        // Test 3: Load 0xC into PC
        PC_in = 32'h0000000C;
        #10;
        $display("PC_out = %h", PC_out);

        // Test Reset Again
        reset = 1;
        #10;
        $display("PC_out after reset = %h", PC_out);

        $finish;
    end

endmodule

