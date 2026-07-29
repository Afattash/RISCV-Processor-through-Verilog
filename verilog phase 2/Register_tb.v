`timescale 1ns/1ps
`include "Register.v"  

module Register_file_tb();
    reg clk, reset;
    reg [4:0] Rs1, Rs2, Rd;
    reg [31:0] Write_data;
    reg RegWrite;
    wire [31:0] Read_data1, Read_data2;

    Register_file uut (
        .clk(clk),
        .reset(reset),
        .Rs1(Rs1),
        .Rs2(Rs2),
        .Rd(Rd),
        .Write_data(Write_data),
        .RegWrite(RegWrite),
        .Read_data1(Read_data1),
        .Read_data2(Read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    initial begin
        $display("Starting Register File Test...");

        reset = 1;
        RegWrite = 0;
        #10;
        reset = 0;

         Rd = 5;
        Write_data = 32'hA5A5A5A5;
        RegWrite = 1;
        #10;

     
        Rd = 10;
        Write_data = 32'h5A5A5A5A;
        RegWrite = 1;
        #10;

     
        RegWrite = 0;

        
        Rs1 = 5;
        Rs2 = 10;
        #10;
        $display("Read_data1 (R5) = %h", Read_data1);
        $display("Read_data2 (R10) = %h", Read_data2);

        Rs1 = 0;
        Rs2 = 0;
        #10;
        $display("Read_data1 (R0) = %h", Read_data1);
        $display("Read_data2 (R0) = %h", Read_data2);

        $finish;
    end

endmodule
