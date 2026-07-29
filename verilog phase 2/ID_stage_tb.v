`timescale 1ns/1ps
`include "ID_stage.v"
module id_stage_tb;

  reg [31:0] instruction;
  reg [31:0] pc_in;


  wire [31:0] read_data1;
  wire [31:0] read_data2;
  wire [31:0] imm;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;

  ID_stage uut (
    .instruction(instruction),
    .pc_in(pc_in),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .imm(imm),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd)
  );

  initial begin
    $display("Starting ID_stage Testbench...");

    // Example 1: R-type instruction (ADD x3, x1, x2)
    instruction = 32'b0000000_00010_00001_000_00011_0110011;
    pc_in = 32'h00000000;
    #10;
    $display("Instruction: %h", instruction);
    $display("rs1: %d, rs2: %d, rd: %d", rs1, rs2, rd);
    $display("ReadData1: %h, ReadData2: %h, Imm: %h", read_data1, read_data2, imm);

    // Example 2: I-type instruction (ADDI x5, x1, 10)
    instruction = 32'b000000000010_00001_000_00101_0010011;
    pc_in = 32'h00000004;
    #10;
    $display("Instruction: %h", instruction);
    $display("rs1: %d, rs2: %d, rd: %d", rs1, rs2, rd);
    $display("ReadData1: %h, ReadData2: %h, Imm: %h", read_data1, read_data2, imm);

    // Example 3: Load instruction (LW x6, 16(x2))
    instruction = 32'b000000001000_00010_010_00110_0000011;
    pc_in = 32'h00000008;
    #10;
    $display("Instruction: %h", instruction);
    $display("rs1: %d, rs2: %d, rd: %d", rs1, rs2, rd);
    $display("ReadData1: %h, ReadData2: %h, Imm: %h", read_data1, read_data2, imm);

    $display("ID_stage Testbench Finished!");
    $stop;
  end

endmodule
