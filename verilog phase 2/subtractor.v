module subtractor(
input [31:0] input1,input2,
output[31:0] difference,
output cout
);
assign {cout,difference} = input1 - input2;

endmodule