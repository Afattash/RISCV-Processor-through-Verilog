`include "processor.v"
module load_use_hazard_tb;
    reg clk, reset;
    Processor DUT (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $display("Running Load-Use Hazard test...");
        reset = 1; #10; reset = 0;

        // Initialize data memory if needed
        DUT.MEM.RAM.RAM_memory[100] = 32'h0000000A; // memory[x1] = 10

        #200;
        $display("x1 = %h, x2  = %h, x5=%h", DUT.register_file.registers[1], DUT.register_file.registers[2],DUT.register_file.registers[5]);
        $finish;
    end
endmodule
