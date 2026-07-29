`timescale 1ns / 1ps
`include"EX_MEM.v"
module EX_MEM_tb;

    reg clk, reset;
    reg [31:0] alu_result_in, reg2_in;
    reg [4:0] rd_in;
    reg branch_in, regWrite_in, memRead_in, memWrite_in, memToReg_in;

    wire [31:0] alu_result_out, reg2_out;
    wire [4:0] rd_out;
    wire branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out;

    EX_MEM uut (
        .clk(clk),
        .reset(reset),
        .alu_result_in(alu_result_in),
        .reg2_in(reg2_in),
        .rd_in(rd_in),
        .branch_in(branch_in),
        .regWrite_in(regWrite_in),
        .memRead_in(memRead_in),
        .memWrite_in(memWrite_in),
        .memToReg_in(memToReg_in),
        .alu_result_out(alu_result_out),
        .reg2_out(reg2_out),
        .rd_out(rd_out),
        .branch_out(branch_out),
        .regWrite_out(regWrite_out),
        .memRead_out(memRead_out),
        .memWrite_out(memWrite_out),
        .memToReg_out(memToReg_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        alu_result_in = 32'h12345678; reg2_in = 32'h9ABCDEF0; rd_in = 5'd12;
        branch_in = 1; regWrite_in = 1; memRead_in = 0; memWrite_in = 1; memToReg_in = 0;
        #10;

        $display("Time | alu_result_out reg2_out rd_out branch regWrite memRead memWrite memToReg");

        // After reset, outputs should be zero
        $display("%4t | %h %h %2d   %b     %b       %b      %b       %b (reset)", 
                 $time, alu_result_out, reg2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out);

        // Release reset, clock in first set
        reset = 0;
        @(negedge clk);
        $display("%4t | %h %h %2d   %b     %b       %b      %b       %b (normal)", 
                 $time, alu_result_out, reg2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out);

        // Change input, clock in new set
        alu_result_in = 32'hDEADBEAD; reg2_in = 32'hFEEDBEEF; rd_in = 5'd5;
        branch_in = 0; regWrite_in = 0; memRead_in = 1; memWrite_in = 0; memToReg_in = 1;
        @(negedge clk);
        $display("%4t | %h %h %2d   %b     %b       %b      %b       %b (updated)", 
                 $time, alu_result_out, reg2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out);

        $finish;
    end

endmodule
