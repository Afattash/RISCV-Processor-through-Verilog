`timescale 1ns / 1ps
`include "IF_ID.v"

module IF_ID_tb;

    reg clk, reset, flush, write;
    reg [31:0] instr_in, pc_in;
    wire [31:0] instr_out, pc_out;

    IF_ID uut (
        .clk(clk),
        .reset(reset),
        .flush(flush),
        .write(write),
        .instr_in(instr_in),
        .pc_in(pc_in),
        .instr_out(instr_out),
        .pc_out(pc_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; flush = 0; write = 0;
        instr_in = 32'h00000000; pc_in = 32'h00000000;
        #10;

        $display("Time | reset flush write | instr_in      pc_in      | instr_out     pc_out");
        $display("-------------------------------------------------------------------------");

        // Release reset, write enabled (add x1, x2, x3 @ PC=4)
        reset = 0; flush = 0; write = 1;
        instr_in = 32'b0000000_00011_00010_000_00001_0110011; // add x1, x2, x3
        pc_in    = 32'h00000004;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (add)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        // Write disabled (should hold previous value)
        write = 0;
        instr_in = 32'b0100000_00011_00010_000_00001_0110011; // sub x1, x2, x3
        pc_in    = 32'h00000008;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (hold)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        // Write enabled again (should update with sub)
        write = 1;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (sub)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        // Flush asserted (should clear)
        flush = 1; write = 1;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (flush)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        // Flush deasserted, new instruction (addi x4, x0, 10 @ PC=0x0C)
        flush = 0; write = 1;
        instr_in = 32'b000000000101_00000_000_00100_0010011; // addi x4, x0, 5
        pc_in    = 32'h0000000C;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (addi)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        // Assert reset (should clear)
        reset = 1;
        @(negedge clk);
        $display("%4t |   %b     %b     %b   | %h  %h | %h %h (reset)", $time, reset, flush, write, instr_in, pc_in, instr_out, pc_out);

        $finish;
    end

endmodule
