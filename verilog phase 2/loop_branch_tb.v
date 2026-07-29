`include "processor.v"
module loop_branch_tb;
    reg clk, reset;
    Processor DUT (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $display("Running Loop/Branch test...");
        reset = 1; #20; reset = 0;
        #1200; // More cycles for loops

        // Display values of x1, x2, x3
        $display("x1 = %h", DUT.register_file.registers[1]);
        $display("x2 = %h (should match expected loop result)", DUT.register_file.registers[2]);
        $display("x3 = %h", DUT.register_file.registers[3]);

        $finish;
    end
endmodule
