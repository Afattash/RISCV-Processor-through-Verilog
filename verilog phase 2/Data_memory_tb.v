`timescale 1ns/1ps
`include "Data_memory.v"

module Data_memory_tb();

    reg clk;
    reg [9:0] address;
    reg write_enable;
    reg read_enable;
    reg [31:0] write_data;

    wire [31:0] read_data;

    Data_memory uut (
        .clk(clk),
        .address(address),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    initial begin
        $display("Starting Data_memory Testbench...");

      
        address = 10'd0;
        write_enable = 0;
        read_enable = 0;
        write_data = 32'b0;

        #10;

        read_enable = 1;
        address = 10'd0;
        #10;
        $display("Initial read address 0 = %h", read_data);

        address = 10'd1;
        #10;
        $display("Initial read address 1 = %h", read_data);

        read_enable = 0;
        write_enable = 1;
        address = 10'd10;
        write_data = 32'hDEADBEEF;
        #10;  

        write_enable = 0;
        read_enable = 1;
        #10;
        $display("Read back written address 10 = %h", read_data);

     
        write_enable = 1;
        read_enable = 0;
        address = 10'd20;
        write_data = 32'h12345678;
        #10;

        write_enable = 0;
        read_enable = 1;
        address = 10'd20;
        #10;
        $display("Read back written address 20 = %h", read_data);

        address = 10'd30;
        #10;
        $display("Read from unwritten address 30 = %h", read_data);

        $display("Testbench Finished!");
        $finish;
    end

endmodule
