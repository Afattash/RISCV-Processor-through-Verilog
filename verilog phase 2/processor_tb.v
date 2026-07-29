`timescale 1ns/1ps

module Processor_tb;

    reg clk;
    reg reset;

    // Instantiate your processor
    Processor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset logic and simulation control
    initial begin
        // Optionally dump VCD file for waveform viewing
        $dumpfile("Processor_tb.vcd");
        $dumpvars(0, Processor_tb);

        // Initialize signals
        reset = 1'b1;
        #15;             // Hold reset for a few cycles
        reset = 1'b0;

        // Wait for a few instructions to execute
        #500;            // Run for 500ns (adjust as needed for your program)
        
        // Optionally, check registers, memory, etc.

        $display("Test finished.");
        $finish;
    end

    // Optionally monitor a few important signals
    initial begin
        $monitor("Time=%0t | PC=%h | instr=%h | WB_rd=%0d, WB_data=%h, WB_regWrite=%b",
            $time,
            uut.pc_current,
            uut.instruction,
            uut.MEM_WB_rd_out,
            uut.write_back_data,
            uut.MEM_WB_regWrite_out
        );
    end

endmodule
