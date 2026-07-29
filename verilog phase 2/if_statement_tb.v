`include"processor.v"
module if_statement_tb;
    reg clk, reset;
    Processor DUT (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        $display("Running If-statement/branch test...");
        reset = 1; #10; reset = 0;
        #200;
        $display("x1 = %h, x2 = %h, x4=%h", DUT.register_file.registers[1], DUT.register_file.registers[2], DUT.register_file.registers[4]);
        $finish;
    end
endmodule
