`timescale 1ns / 1ps
`include "MEM_stage"
module MEM_stage_tb;

    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] alu_result;
    reg [31:0] write_data;
    
    wire [31:0] mem_read_data;
    
    MEM_stage uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_result(alu_result),
        .write_data(write_data),
        .mem_read_data(mem_read_data)
    );
    
    // Clock generation
    always begin
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
    end
    
    initial begin
        // Initialize Inputs
        mem_read = 0;
        mem_write = 0;
        alu_result = 0;
        write_data = 0;
        
        // Wait for global reset
        #10;
        
        // Test Case 1: Simple write then read
        $display("\nTest Case 1: Write then read from address 0x10");
        mem_write = 1'b1;
        alu_result = 32'h00000010;
        write_data = 32'hA5A5A5A5;
        @(posedge clk); #1;
        mem_write = 1'b0;
        
        mem_read = 1'b1;
        @(posedge clk); #1;
        $display("Write: addr=%h data=%h", alu_result, write_data);
        $display("Read:  addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // Test Case 2: Multiple writes then reads
        $display("\nTest Case 2: Multiple writes then reads");
        mem_write = 1'b1;
        alu_result = 32'h00000020;
        write_data = 32'h12345678;
        @(posedge clk); #1;
        
        alu_result = 32'h00000024;
        write_data = 32'h9ABCDEF0;
        @(posedge clk); #1;
        mem_write = 1'b0;
        
        // Read back values
        mem_read = 1'b1;
        alu_result = 32'h00000020;
        @(posedge clk); #1;
        $display("Read:  addr=%h data=%h", alu_result, mem_read_data);
        
        alu_result = 32'h00000024;
        @(posedge clk); #1;
        $display("Read:  addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // Test Case 3: Read without write (should be unknown or 0)
        $display("\nTest Case 3: Read uninitialized memory");
        mem_read = 1'b1;
        alu_result = 32'h00000030;
        @(posedge clk); #1;
        $display("Read uninitialized: addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // Test Case 4: Write/read at address boundary
        $display("\nTest Case 4: Address boundary test");
        mem_write = 1'b1;
        alu_result = 32'h000003FC;  // Near end of 1024-byte memory (assuming 10-bit address)
        write_data = 32'hDEADBEEF;
        @(posedge clk); #1;
        mem_write = 1'b0;
        
        mem_read = 1'b1;
        @(posedge clk); #1;
        $display("Boundary test: addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // Test Case 5: Back-to-back write and read
        $display("\nTest Case 5: Back-to-back write and read");
        mem_write = 1'b1;
        mem_read = 1'b1;  // Both enabled - behavior depends on your memory implementation
        alu_result = 32'h00000040;
        write_data = 32'h11223344;
        @(posedge clk); #1;
        $display("Simultaneous write/read: addr=%h write_data=%h read_data=%h", 
               alu_result, write_data, mem_read_data);
        mem_write = 1'b0;
        mem_read = 1'b0;
        
        // Test Case 6: Sequential operations
        $display("\nTest Case 6: Sequential operations");
        alu_result = 32'h00000050;
        write_data = 32'h55667788;
        mem_write = 1'b1;
        @(posedge clk); #1;
        mem_write = 1'b0;
        
        mem_read = 1'b1;
        @(posedge clk); #1;
        $display("Sequential read after write: addr=%h data=%h", alu_result, mem_read_data);
        
        write_data = 32'h99AABBCC;
        mem_write = 1'b1;
        @(posedge clk); #1;
        mem_write = 1'b0;
        mem_read = 1'b1;
        @(posedge clk); #1;
        $display("Sequential read after write: addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // Test Case 7: Byte addressable test (if applicable)
        $display("\nTest Case 7: Byte addressable test");
        // Note: This depends on your memory implementation
        mem_write = 1'b1;
        alu_result = 32'h00000060;
        write_data = 32'hA1B2C3D4;
        @(posedge clk); #1;
        mem_write = 1'b0;
        
        // Read same word
        mem_read = 1'b1;
        @(posedge clk); #1;
        $display("Full word read: addr=%h data=%h", alu_result, mem_read_data);
        
        // Read same word with offset (if byte-addressable)
        alu_result = 32'h00000062;
        @(posedge clk); #1;
        $display("Offset read: addr=%h data=%h", alu_result, mem_read_data);
        mem_read = 1'b0;
        
        // End simulation
        $display("\nMEM_stage test completed");
        #20 $finish;
    end
    
    // Monitor to track important signals
    initial begin
        $monitor("Time=%0t: clk=%b mem_read=%b mem_write=%b addr=%h wdata=%h rdata=%h",
                $time, clk, mem_read, mem_write, alu_result, write_data, mem_read_data);
    end
endmodule