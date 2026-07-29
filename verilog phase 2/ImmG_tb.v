`timescale 1ns/1ps
`include "ImmG.v"

module ImmGen_tb();

    reg [6:0] opcode;
    reg [31:0] instruction;

    wire [31:0] ImmExt;

    ImmGen uut (
        .opcode(opcode),
        .instruction(instruction),
        .ImmExt(ImmExt)
    );

    initial begin
        $display("Starting ImmGen Testbench...");

        // Test case 1: Load (opcode 0000011)
        opcode = 7'b0000011;
        instruction = 32'b100000000000_00000_000_00000_0000011; // Immediate = 0x800
        #10;
        $display("Load Immediate: %h", ImmExt);

        // Test case 2: Store (opcode 0100011)
        opcode = 7'b0100011;
        instruction = 32'b1000000_00000_00000_000_00000_0100011; // Store Immediate
        #10;
        $display("Store Immediate: %h", ImmExt);

        // Test case 3: Branch (opcode 1100011)
        opcode = 7'b1100011;
        instruction = 32'b1_000000_00000_00000_000_00000_1100011; // Branch Immediate
        #10;
        $display("Branch Immediate: %h", ImmExt);

        // Test case 4: Default (unknown opcode)
        opcode = 7'b1111111;
        instruction = 32'b0;
        #10;
        $display("Default Immediate (should be 0): %h", ImmExt);

        $display("Testbench Finished!");
        $finish;
    end

endmodule
