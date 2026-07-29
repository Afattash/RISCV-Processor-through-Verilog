`include "adder.v"  

module adder_testbench; 

    reg [31:0] input1, input2;
    wire [31:0] sum;
    wire cout;

    adder DUT (
        .input1(input1),
        .input2(input2),
        .sum(sum),     
        .cout(cout)
    );


    initial begin
  
        input1 = 4'b1111; 
        input2 = 4'b0001;
        #10;  
        $display("Input1 = %b, Input2 = %b, Sum = %b, Cout = %b", 
                 input1, input2, sum, cout);

        $finish;
    end
endmodule