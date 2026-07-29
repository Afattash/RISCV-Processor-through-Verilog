`timescale 1ns / 1ps
`include "WB_stage.v"
module WB_stage_tb;
  
    reg [31:0] alu_result;
    reg [31:0] mem_data;
    reg MemtoReg;
   
    wire [31:0] write_data;
    
    WB_stage uut (
        .alu_result(alu_result),
        .mem_data(mem_data),
        .MemtoReg(MemtoReg),
        .write_data(write_data)
    );
    
    initial begin

        alu_result = 0;
        mem_data = 0;
        MemtoReg = 0;
  
        $monitor("Time=%0t: MemtoReg=%b ALU_result=%h MEM_data=%h WB_data=%h", 
                $time, MemtoReg, alu_result, mem_data, write_data);
        
        $display("\nTest Case 1: ALU result selected (MemtoReg = 0)");
        alu_result = 32'h12345678;
        mem_data = 32'h9ABCDEF0;
        MemtoReg = 1'b0;
        #10;
        if (write_data !== alu_result) begin
            $display("ERROR: Expected %h, got %h", alu_result, write_data);
        end else begin
            $display("PASS: ALU result correctly selected");
        end
   
        $display("\nTest Case 2: Memory data selected (MemtoReg = 1)");
        alu_result = 32'h11111111;
        mem_data = 32'h22222222;
        MemtoReg = 1'b1;
        #10;
        if (write_data !== mem_data) begin
            $display("ERROR: Expected %h, got %h", mem_data, write_data);
        end else begin
            $display("PASS: Memory data correctly selected");
        end
        
        $display("\nTest Case 3: ALU result with zero memory data");
        alu_result = 32'hFFFFFFFF;
        mem_data = 32'h00000000;
        MemtoReg = 1'b0;
        #10;
        if (write_data !== alu_result) begin
            $display("ERROR: Expected %h, got %h", alu_result, write_data);
        end else begin
            $display("PASS: ALU result correctly selected with zero memory");
        end
        
        $display("\nTest Case 4: Memory data with zero ALU result");
        alu_result = 32'h00000000;
        mem_data = 32'h55555555;
        MemtoReg = 1'b1;
        #10;
        if (write_data !== mem_data) begin
            $display("ERROR: Expected %h, got %h", mem_data, write_data);
        end else begin
            $display("PASS: Memory data correctly selected with zero ALU");
        end
        
        $display("\nTest Case 5: Rapid switching between sources");
        alu_result = 32'hA5A5A5A5;
        mem_data = 32'h5A5A5A5A;
        
        MemtoReg = 1'b0;
        #5;
        if (write_data !== alu_result) begin
            $display("ERROR: Expected %h, got %h", alu_result, write_data);
        end
        
        MemtoReg = 1'b1;
        #5;
        if (write_data !== mem_data) begin
            $display("ERROR: Expected %h, got %h", mem_data, write_data);
        end
        
        MemtoReg = 1'b0;
        #5;
        if (write_data !== alu_result) begin
            $display("ERROR: Expected %h, got %h", alu_result, write_data);
        end
        
        $display("PASS: Rapid switching test completed");
        
        $display("\nTest Case 6: Maximum values test");
        alu_result = 32'hFFFFFFFF;
        mem_data = 32'hFFFFFFFF;
        MemtoReg = 1'b0;
        #5;
        if (write_data !== alu_result) begin
            $display("ERROR: Expected %h, got %h", alu_result, write_data);
        end
        
        MemtoReg = 1'b1;
        #5;
        if (write_data !== mem_data) begin
            $display("ERROR: Expected %h, got %h", mem_data, write_data);
        end
        
        $display("PASS: Maximum values test completed");
    
        $display("\nWB_stage test completed");
        #10 $finish;
    end
endmodule