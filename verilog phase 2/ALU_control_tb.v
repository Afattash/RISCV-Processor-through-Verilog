`timescale 1ns / 1ps
`include "ALU_control.v"
module ALU_Control_tb;

    reg  [1:0] ALUOp;
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire [3:0] ALU_Ctrl;

    ALU_Control dut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_Ctrl(ALU_Ctrl)
    );

    initial begin
        $display("ALUOp funct7 funct3 | ALU_Ctrl");
        $display("-------------------------------");

        // Test Load/Store (ADD)
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (ADD)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test Branch (SUB)
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (SUB for BEQ)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: ADD
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (ADD)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: SUB
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'b0100000; #5;
        $display("%b    %b   %b    | %b (SUB)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: AND
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (AND)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: OR
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (OR)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: XOR
        ALUOp = 2'b10; funct3 = 3'b100; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (XOR)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: SLL
        ALUOp = 2'b10; funct3 = 3'b001; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (SLL)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: SRL
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (SRL)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test R-Type: SLT
        ALUOp = 2'b10; funct3 = 3'b010; funct7 = 7'b0000000; #5;
        $display("%b    %b   %b    | %b (SLT)", ALUOp, funct7, funct3, ALU_Ctrl);

        // Test Invalid
        ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b1111111; #5;
        $display("%b    %b   %b    | %b (INVALID)", ALUOp, funct7, funct3, ALU_Ctrl);

        $display("-------------------------------");
        $finish;
    end

endmodule
