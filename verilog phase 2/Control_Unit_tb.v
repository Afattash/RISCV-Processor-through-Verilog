`timescale 1ns/1ps
`include "Control_Unit.v"

module Control_Unit_tb();

    reg [6:0] OPcode;

    wire branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUop;

    Control_Unit DUT (
        .OPcode(OPcode),
        .branch(branch),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUop(ALUop)
    );

    initial begin
        $display("Starting Control Unit Testbench...");

        // Test R-type (0110011)
        OPcode = 7'b0110011;
        #10;
        $display("R-Type: branch=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b, ALUop=%b",
                 branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite, ALUop);

        // Test Load (0000011)
        OPcode = 7'b0000011;
        #10;
        $display("Load: branch=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b, ALUop=%b",
                 branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite, ALUop);

        // Test Store (0100011)
        OPcode = 7'b0100011;
        #10;
        $display("Store: branch=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b, ALUop=%b",
                 branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite, ALUop);

        // Test Branch (1100011)
        OPcode = 7'b1100011;
        #10;
        $display("Branch: branch=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b, ALUop=%b",
                 branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite, ALUop);

        
        OPcode = 7'b1111111;
        #10;
        $display("Default (Invalid OPcode): branch=%b, MemtoReg=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b, ALUop=%b",
                 branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite, ALUop);

        $display("Testbench Finished!");
        $finish;
    end

endmodule
