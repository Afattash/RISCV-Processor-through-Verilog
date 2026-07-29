`include "subtractor.v"
module Subtractor_tb();
    reg [31:0] input1,input2;
    wire [31:0] difference;
    wire cout;

    subtractor DUT (
        .input1(input1),
        .input2(input2),
        .difference(difference),     
        .cout(cout)
    );


    initial begin
  
        input1 = 4'b1111; 
        input2 = 4'b0001;
        #10;  
        $display("Input1 = %b, Input2 = %b, difference = %b, Cout = %b", 
                 input1, input2, difference, cout);

        $finish;
    end

endmodule