`timescale 1ns/1ps
`include "Instruction_Memory.v"
module instruction_memory_tb;

  reg reset;
  reg [5:0] read_address;

  wire [31:0] instruction_out;

  Instruction_Memory uut (
    .reset(reset),
    .read_address(read_address),
    .instruction_out(instruction_out)
  );

  initial begin
    $display("Starting Instruction_Memory Testbench...");

    reset = 1;
    read_address = 0;
    #10;
    reset = 0;
    read_address = 0;
    #5;
    $display("Instruction at address 0 after reset = %h", instruction_out);

    read_address = 10;
    #5;
    $display("Instruction at address 10 after reset = %h", instruction_out);

    read_address = 20;
    #5;
    $display("Instruction at address 20 after reset = %h", instruction_out);


    $display("Instruction_Memory Testbench Finished!");
    $stop;
  end

endmodule
