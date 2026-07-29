`timescale 1ns / 1ps
`include"hazard_detection_unit.v"
module HazardDetectionUnit_tb;

    reg  [4:0] ID_EX_rd;
    reg        ID_EX_memRead;
    reg  [4:0] IF_ID_rs1, IF_ID_rs2;
    wire       PC_write, IF_ID_write, control_mux;

    HazardDetectionUnit uut (
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_memRead(ID_EX_memRead),
        .IF_ID_rs1(IF_ID_rs1),
        .IF_ID_rs2(IF_ID_rs2),
        .PC_write(PC_write),
        .IF_ID_write(IF_ID_write),
        .control_mux(control_mux)
    );

    initial begin
        $display("ID_EX_rd IF_ID_rs1 IF_ID_rs2 ID_EX_memRead | PC_write IF_ID_write control_mux");
        $display("--------------------------------------------------------");

        // Test: Hazard detected (stall required)
        ID_EX_rd = 5'd3;    // MEM stage will write x3
        ID_EX_memRead = 1;  // It's a load
        IF_ID_rs1 = 5'd3;   // Next instr needs x3 as rs1
        IF_ID_rs2 = 5'd2;   // rs2 is unrelated
        #5;
        $display("%2d      %2d        %2d        %b           |    %b        %b         %b (HAZARD: stall)",
                 ID_EX_rd, IF_ID_rs1, IF_ID_rs2, ID_EX_memRead, PC_write, IF_ID_write, control_mux);

        // Test: Hazard detected on rs2
        ID_EX_rd = 5'd8;
        ID_EX_memRead = 1;
        IF_ID_rs1 = 5'd0;
        IF_ID_rs2 = 5'd8;  // hazard on rs2
        #5;
        $display("%2d      %2d        %2d        %b           |    %b        %b         %b (HAZARD: stall)",
                 ID_EX_rd, IF_ID_rs1, IF_ID_rs2, ID_EX_memRead, PC_write, IF_ID_write, control_mux);

        // Test: No hazard, should proceed
        ID_EX_rd = 5'd4;
        ID_EX_memRead = 0; // Not a load
        IF_ID_rs1 = 5'd4;
        IF_ID_rs2 = 5'd5;
        #5;
        $display("%2d      %2d        %2d        %b           |    %b        %b         %b (NO HAZARD: proceed)",
                 ID_EX_rd, IF_ID_rs1, IF_ID_rs2, ID_EX_memRead, PC_write, IF_ID_write, control_mux);

        // Test: No hazard (different regs)
        ID_EX_rd = 5'd6;
        ID_EX_memRead = 1;
        IF_ID_rs1 = 5'd7;
        IF_ID_rs2 = 5'd8;
        #5;
        $display("%2d      %2d        %2d        %b           |    %b        %b         %b (NO HAZARD: proceed)",
                 ID_EX_rd, IF_ID_rs1, IF_ID_rs2, ID_EX_memRead, PC_write, IF_ID_write, control_mux);

        $finish;
    end

endmodule
