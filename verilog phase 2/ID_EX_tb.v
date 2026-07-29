`timescale 1ns / 1ps
`include "ID_EX.v"
module ID_EX_tb;

    reg clk, reset, bubble, flush;
    reg [31:0] pc_in, reg1_in, reg2_in, imm_in;
    reg [4:0] rs1_in, rs2_in, rd_in;
    reg branch_in, regWrite_in, memRead_in, memWrite_in, memToReg_in;
    reg [1:0] ALUop_in;
    reg ALUSrc_in;

    wire [31:0] pc_out, reg1_out, reg2_out, imm_out;
    wire [4:0] rs1_out, rs2_out, rd_out;
    wire branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out;
    wire [1:0] ALUop_out;
    wire ALUSrc_out;

    // Instantiate DUT
    ID_EX uut (
        .clk(clk),
        .reset(reset),
        .bubble(bubble),
        .flush(flush),
        .pc_in(pc_in),
        .reg1_in(reg1_in),
        .reg2_in(reg2_in),
        .imm_in(imm_in),
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .rd_in(rd_in),
        .branch_in(branch_in),
        .regWrite_in(regWrite_in),
        .memRead_in(memRead_in),
        .memWrite_in(memWrite_in),
        .memToReg_in(memToReg_in),
        .ALUop_in(ALUop_in),
        .ALUSrc_in(ALUSrc_in),
        .pc_out(pc_out),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out),
        .imm_out(imm_out),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .rd_out(rd_out),
        .branch_out(branch_out),
        .regWrite_out(regWrite_out),
        .memRead_out(memRead_out),
        .memWrite_out(memWrite_out),
        .memToReg_out(memToReg_out),
        .ALUop_out(ALUop_out),
        .ALUSrc_out(ALUSrc_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; flush = 0; bubble = 0;
        pc_in = 32'h00000004; reg1_in = 32'h11111111; reg2_in = 32'h22222222; imm_in = 32'h33333333;
        rs1_in = 5'd5; rs2_in = 5'd6; rd_in = 5'd7;
        branch_in = 1; regWrite_in = 1; memRead_in = 0; memWrite_in = 1; memToReg_in = 0; ALUop_in = 2'b10; ALUSrc_in = 1;
        #10; // Apply reset

        $display("Time | reset flush bubble | pc_out   reg1_out   reg2_out   imm_out   rs1_out rs2_out rd_out branch regWrite memRead memWrite memToReg ALUop ALUSrc");

        // Release reset, normal operation
        reset = 0; flush = 0; bubble = 0;
        @(negedge clk);
        $display("%4t |   %b     %b     %b    | %h %h %h %h %2d %2d %2d   %b      %b      %b      %b       %b     %2b     %b (write)", 
                $time, reset, flush, bubble, pc_out, reg1_out, reg2_out, imm_out, rs1_out, rs2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out, ALUop_out, ALUSrc_out);

        // Change input, hold (no write)
        pc_in = 32'h00000008; reg1_in = 32'hA1A1A1A1; reg2_in = 32'hB2B2B2B2; imm_in = 32'hC3C3C3C3;
        rs1_in = 5'd8; rs2_in = 5'd9; rd_in = 5'd10;
        branch_in = 0; regWrite_in = 0; memRead_in = 1; memWrite_in = 0; memToReg_in = 1; ALUop_in = 2'b01; ALUSrc_in = 0;
        @(negedge clk);
        $display("%4t |   %b     %b     %b    | %h %h %h %h %2d %2d %2d   %b      %b      %b      %b       %b     %2b     %b (updated)", 
                $time, reset, flush, bubble, pc_out, reg1_out, reg2_out, imm_out, rs1_out, rs2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out, ALUop_out, ALUSrc_out);

        // Flush (should clear outputs)
        flush = 1;
        @(negedge clk);
        $display("%4t |   %b     %b     %b    | %h %h %h %h %2d %2d %2d   %b      %b      %b      %b       %b     %2b     %b (flush)", 
                $time, reset, flush, bubble, pc_out, reg1_out, reg2_out, imm_out, rs1_out, rs2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out, ALUop_out, ALUSrc_out);

        // Bubble (should clear outputs)
        flush = 0; bubble = 1;
        @(negedge clk);
        $display("%4t |   %b     %b     %b    | %h %h %h %h %2d %2d %2d   %b      %b      %b      %b       %b     %2b     %b (bubble)", 
                $time, reset, flush, bubble, pc_out, reg1_out, reg2_out, imm_out, rs1_out, rs2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out, ALUop_out, ALUSrc_out);

        // Normal write after bubble
        bubble = 0;
        @(negedge clk);
        $display("%4t |   %b     %b     %b    | %h %h %h %h %2d %2d %2d   %b      %b      %b      %b       %b     %2b     %b (write again)", 
                $time, reset, flush, bubble, pc_out, reg1_out, reg2_out, imm_out, rs1_out, rs2_out, rd_out, branch_out, regWrite_out, memRead_out, memWrite_out, memToReg_out, ALUop_out, ALUSrc_out);

        $finish;
    end

endmodule
