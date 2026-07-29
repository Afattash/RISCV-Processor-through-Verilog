`include "processor.v"
module alu_forwarding_tb;
    reg clk, reset;
    Processor DUT (.clk(clk), .reset(reset));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $display("Running ALU-ALU forwarding test...");
        reset = 1; #10; reset = 0;

        // Wait enough cycles for forwarding to show
        #200;

        // Display x1, x2, x3, x4
        $display("x1 = %08x", DUT.register_file.registers[1]);
        $display("x2 = %08x", DUT.register_file.registers[2]);
        $display("x3 = %08x", DUT.register_file.registers[3]);
        $display("x4 = %08x", DUT.register_file.registers[4]);

        $finish;
    end
endmodule
