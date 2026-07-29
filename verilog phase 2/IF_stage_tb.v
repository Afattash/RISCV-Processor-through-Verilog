`timescale 1ns / 1ps

`include "IF_stage.v"
`timescale 1ns/1ps

module If_stage_tb;

  reg clk;
  reg reset;
  reg [31:0] pc_branch_target;
  reg branch_taken;

  wire [31:0] instruction;
  wire [31:0] pc_plus4;
  wire [31:0] pc_current;

  IF_stage uut (
    .clk(clk),
    .reset(reset),
    .pc_branch_target(pc_branch_target),
    .branch_taken(branch_taken),
    .instruction(instruction),
    .pc_plus4(pc_plus4),
    .pc_current(pc_current)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  initial begin
    $display("Starting IF_stage Testbench...");

    reset = 1;
    pc_branch_target = 0;
    branch_taken = 0;
    #10;

    reset = 0;
    #10;

    branch_taken = 0;
    #10;
    $display("PC = %h, PC+4 = %h, Instruction = %h", pc_current, pc_plus4, instruction);

    #10;
    $display("PC = %h, PC+4 = %h, Instruction = %h", pc_current, pc_plus4, instruction);

    branch_taken = 1;
    pc_branch_target = 32'h00000020; 
    #10;
    $display("Branch taken -> PC = %h, PC+4 = %h, Instruction = %h", pc_current, pc_plus4, instruction);

    branch_taken = 0;
    #10;
    $display("PC = %h, PC+4 = %h, Instruction = %h", pc_current, pc_plus4, instruction);

    $display("IF_stage Testbench Finished!");
    $stop;
  end

endmodule
