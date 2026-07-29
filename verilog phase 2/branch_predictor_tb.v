`timescale 1ns / 1ps
`include "branch_predictor.v"
module BranchPredictor_tb;

    reg clk, reset;
    reg [31:0] PC;
    reg actual_branch, update;
    wire predicted_taken;

    // Instantiate DUT
    BranchPredictor uut (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .actual_branch(actual_branch),
        .update(update),
        .predicted_taken(predicted_taken)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        reset = 1; update = 0; PC = 32'h20; actual_branch = 0;
        #10;
        reset = 0;

        $display("Time | PC   | Actual | Predicted | BTB[index]");
        $display("------------------------------------------------");

        // Simulate several cycles where branch is taken
        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            actual_branch = 1'b1; update = 1'b1;
            @(negedge clk);
            $display("%4t | %h |   %b    |     %b     |   %b", $time, PC, actual_branch, predicted_taken, uut.btb[PC[9:2]]);
        end

        // Now, simulate several cycles where branch is NOT taken
        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            actual_branch = 1'b0; update = 1'b1;
            @(negedge clk);
            $display("%4t | %h |   %b    |     %b     |   %b", $time, PC, actual_branch, predicted_taken, uut.btb[PC[9:2]]);
        end

        $display("------------------------------------------------");
        $finish;
    end

endmodule
