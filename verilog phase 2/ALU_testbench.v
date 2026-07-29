`timescale 1ns/1ps
`include "ALU.v"  

module ALU_tb();

    reg [3:0] input1, input2;
    reg [2:0] operation;
    reg clock, reset;


    wire [3:0] result;
    wire fiveFlag;

    ALU uut (
        .input1(input1),
        .input2(input2),
        .clock(clock),
        .reset(reset),
        .operation(operation),
        .result(result),
        .fiveFlag(fiveFlag)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
 
    initial begin
        $display("Starting ALU Testbench...");

 
        reset = 1;
        input1 = 0;
        input2 = 0;
        operation = 0;
        #10;
        reset = 0;

        input1 = 4'd3;
        input2 = 4'd2;
        operation = 3'b000; 
        #10;
        $display("ADD: %d + %d = %d", input1, input2, result);

        input1 = 4'd7;
        input2 = 4'd4;
        operation = 3'b001;
        #10;
        $display("SUB: %d - %d = %d", input1, input2, result);

        input1 = 4'b1010;
        input2 = 4'b1100;
        operation = 3'b010; 
        #10;
        $display("OR: %b | %b = %b", input1, input2, result);

        input1 = 4'b1010;
        input2 = 4'b1100;
        operation = 3'b011; 
        #10;
        $display("AND: %b & %b = %b", input1, input2, result);

        input1 = 4'b1010;
        input2 = 4'b1100;
        operation = 3'b100; 
        #10;
        $display("XOR: %b ^ %b = %b", input1, input2, result);
  
        input2 = 4'd3;
        operation = 3'b000; 
        #10;
        $display("Check FiveFlag: result = %d, fiveFlag = %b", result, fiveFlag);

        $finish;
    end

endmodule
