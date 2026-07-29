`timescale 1ns / 1ps
`include "MEM_WB.v"

module MEM_WB_tb;

    reg clk, reset;
    reg [31:0] mem_data_in, alu_result_in;
    reg [4:0] rd_in;
    reg regWrite_in, memToReg_in;

    wire [31:0] mem_data_out, alu_result_out;
    wire [4:0]  rd_out;
    wire regWrite_out, memToReg_out;

    MEM_WB uut (
        .clk(clk),
        .reset(reset),
        .mem_data_in(mem_data_in),
        .alu_result_in(alu_result_in),
        .rd_in(rd_in),
        .regWrite_in(regWrite_in),
        .memToReg_in(memToReg_in),
        .mem_data_out(mem_data_out),
        .alu_result_out(alu_result_out),
        .rd_out(rd_out),
        .regWrite_out(regWrite_out),
        .memToReg_out(memToReg_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        mem_data_in = 32'h00000010; alu_result_in = 32'h00000020; rd_in = 5'd3;
        regWrite_in = 1; memToReg_in = 0;
        #10;

        $display("Time | mem_data_out alu_result_out rd_out regWrite memToReg");

        // After reset, outputs should be zero
        $display("%4t | %h %h %2d   %b       %b (reset)", 
                 $time, mem_data_out, alu_result_out, rd_out, regWrite_out, memToReg_out);

        // Release reset, clock in first set
        reset = 0;
        @(negedge clk);
        $display("%4t | %h %h %2d   %b       %b (write 1)", 
                 $time, mem_data_out, alu_result_out, rd_out, regWrite_out, memToReg_out);

        // Change input, clock in new set
        mem_data_in = 32'h00000044; alu_result_in = 32'h00000088; rd_in = 5'd15;
        regWrite_in = 0; memToReg_in = 1;
        @(negedge clk);
        $display("%4t | %h %h %2d   %b       %b (write 2)", 
                 $time, mem_data_out, alu_result_out, rd_out, regWrite_out, memToReg_out);

        $finish;
    end

endmodule
