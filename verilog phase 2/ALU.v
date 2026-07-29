`include "adder.v"
`include"subtractor.v"

module ALU #(
    parameter ADD_OP = 4'b0000,
    parameter SUB_OP = 4'b0001,
    parameter OR_OP  = 4'b0010,
    parameter AND_OP = 4'b0011,
    parameter XOR_OP = 4'b0100
)(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0]  operation,  // Updated to 4-bit
    output reg [31:0] result
);

    wire [31:0] add_result, sub_result;

    adder adder1 (
        .input1(input1),
        .input2(input2),
        .sum(add_result)
    );

    subtractor subtractor1 (
        .input1(input1),
        .input2(input2),
        .difference(sub_result)
    );

    always @(*) begin
        case (operation)
            ADD_OP: result = add_result;
            SUB_OP: result = sub_result;
            OR_OP:  result = input1 | input2;
            AND_OP: result = input1 & input2;
            XOR_OP: result = input1 ^ input2;
            default: result = 32'b0;
        endcase
    end

endmodule
