module adder(
input [31:0] input1,input2,
output[31:0] sum,
output cout
);
assign {cout,sum} = input1 + input2;

endmodule

    
