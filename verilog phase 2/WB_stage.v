module WB_stage (
    input [31:0] alu_result,
    input [31:0] mem_data,
    input MemtoReg,
    output [31:0] write_data
);

    assign write_data = (MemtoReg) ? mem_data : alu_result;

endmodule