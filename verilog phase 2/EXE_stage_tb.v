`timescale 1ns/1ps
`include "EXE_stage.v"
module EXE_stage_tb();

    reg [31:0] read_data1;
    reg [31:0] read_data2;
    reg [31:0] imm;
    reg [1:0] ALUSrc;
    reg [2:0] ALUOp;
    reg clock;
    reg reset;
    
    
    wire [31:0] alu_result;
    
    EXE_stage uut (
        .read_data1(read_data1),
        .read_data2(read_data2),
        .imm(imm),
        .ALUSrc(ALUSrc),
        .ALUOp(ALUOp),
        .clock(clock),
        .reset(reset),
        .alu_result(alu_result)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    
    initial begin
       
        reset = 1;
        read_data1 = 32'hA;
        read_data2 = 32'h5;
        imm = 32'h3;
        ALUSrc = 2'b00;
        ALUOp = 3'b000;
        
        #20 reset = 0;
        
        
        #10 ALUOp = 3'b000; ALUSrc = 2'b00;  
        #20 $display("ADD (reg+reg): %d + %d = %d", read_data1, read_data2, alu_result);
        
        #10 ALUSrc = 2'b01; 
        #20 $display("ADD (reg+imm): %d + %d = %d", read_data1, imm, alu_result);
        
        #10 ALUOp = 3'b001; ALUSrc = 2'b00;  
        #20 $display("SUB (reg-reg): %d - %d = %d", read_data1, read_data2, alu_result);
        
        #10 ALUOp = 3'b011; 
        #20 $display("AND: %h & %h = %h", read_data1, read_data2, alu_result);
        
        #10 ALUOp = 3'b010; ALUSrc = 2'b01; 
        #20 $display("OR (reg|imm): %h | %h = %h", read_data1, imm, alu_result);
        
        #10 ALUOp = 3'b100; ALUSrc = 2'b00; 
        #20 $display("XOR: %h ^ %h = %h", read_data1, read_data2, alu_result);
        
        #10 ALUOp = 3'b111;  
        #20 $display("DEFAULT CASE: result = %h", alu_result);
        
        #10 $finish;
    end
endmodule