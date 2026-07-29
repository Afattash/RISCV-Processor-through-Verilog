
`include "processor.v"
`timescale 1ns/1ps

module branch_data_hazard_tb;
    reg clk = 0;
    reg reset = 1;

    // Instantiate processor
    Processor uut(
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #15;
        reset = 0;

        // Run long enough for pipeline to process
        #200;

        // Show key register results (assuming reg file display is in design)
        $display("x1 = %h, x2= %h, x4=%h", uut.register_file.registers[1], uut.register_file.registers[2], uut.register_file.registers[4]);

        $finish;
    end

endmodule
