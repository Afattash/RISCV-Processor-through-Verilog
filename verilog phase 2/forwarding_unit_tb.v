`timescale 1ns / 1ps
`include "forwarding_unit.v"
module ForwardingUnit_tb;

    reg [4:0] ID_EX_rs1, ID_EX_rs2;
    reg [4:0] EX_MEM_rd;
    reg       EX_MEM_regWrite;
    reg [4:0] MEM_WB_rd;
    reg       MEM_WB_regWrite;
    wire [1:0] forwardA, forwardB;

    ForwardingUnit uut (
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),
        .EX_MEM_rd(EX_MEM_rd),
        .EX_MEM_regWrite(EX_MEM_regWrite),
        .MEM_WB_rd(MEM_WB_rd),
        .MEM_WB_regWrite(MEM_WB_regWrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    initial begin
        $display("rs1  rs2  EXrd EXWr MEMrd MEMWr | fA  fB");
        $display("------------------------------------------");

        // No forwarding needed
        ID_EX_rs1 = 5'd2; ID_EX_rs2 = 5'd3;
        EX_MEM_rd = 5'd0; EX_MEM_regWrite = 0;
        MEM_WB_rd = 5'd0; MEM_WB_regWrite = 0;
        #5;
        $display("%2d   %2d   %2d   %b   %2d    %b   | %b  %b", 
            ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, EX_MEM_regWrite, MEM_WB_rd, MEM_WB_regWrite, forwardA, forwardB);

        // Forward from EX/MEM to rs1
        ID_EX_rs1 = 5'd4; ID_EX_rs2 = 5'd3;
        EX_MEM_rd = 5'd4; EX_MEM_regWrite = 1;
        MEM_WB_rd = 5'd0; MEM_WB_regWrite = 0;
        #5;
        $display("%2d   %2d   %2d   %b   %2d    %b   | %b  %b (EX/MEM -> rs1)", 
            ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, EX_MEM_regWrite, MEM_WB_rd, MEM_WB_regWrite, forwardA, forwardB);

        // Forward from MEM/WB to rs2 (only)
        ID_EX_rs1 = 5'd4; ID_EX_rs2 = 5'd8;
        EX_MEM_rd = 5'd0; EX_MEM_regWrite = 0;
        MEM_WB_rd = 5'd8; MEM_WB_regWrite = 1;
        #5;
        $display("%2d   %2d   %2d   %b   %2d    %b   | %b  %b (MEM/WB -> rs2)", 
            ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, EX_MEM_regWrite, MEM_WB_rd, MEM_WB_regWrite, forwardA, forwardB);

        // Both hazards: EX/MEM to rs1, MEM/WB to rs2
        ID_EX_rs1 = 5'd6; ID_EX_rs2 = 5'd9;
        EX_MEM_rd = 5'd6; EX_MEM_regWrite = 1;
        MEM_WB_rd = 5'd9; MEM_WB_regWrite = 1;
        #5;
        $display("%2d   %2d   %2d   %b   %2d    %b   | %b  %b (EX/MEM->rs1, MEM/WB->rs2)", 
            ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, EX_MEM_regWrite, MEM_WB_rd, MEM_WB_regWrite, forwardA, forwardB);

        // Prioritize EX/MEM over MEM/WB (EX/MEM match rs1 and MEM/WB also matches)
        ID_EX_rs1 = 5'd7; ID_EX_rs2 = 5'd10;
        EX_MEM_rd = 5'd7; EX_MEM_regWrite = 1;
        MEM_WB_rd = 5'd7; MEM_WB_regWrite = 1;
        #5;
        $display("%2d   %2d   %2d   %b   %2d    %b   | %b  %b (EX/MEM prioritized for rs1)", 
            ID_EX_rs1, ID_EX_rs2, EX_MEM_rd, EX_MEM_regWrite, MEM_WB_rd, MEM_WB_regWrite, forwardA, forwardB);

        $display("------------------------------------------");
        $finish;
    end

endmodule
