`include "Register.v"
`include "ImmG.v"

module ID_stage (
    input clk,
    input reset,
    input [4:0] wb_rd,
    input wb_RegWrite,
    input [31:0] wb_write_data,
    input [31:0] instruction,
    input [31:0] pc_in,
    output [31:0] read_data1,
    output [31:0] read_data2,
    output [31:0] imm,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd
);


    wire [6:0] opcode;
    assign opcode = instruction[6:0];

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];

Register_file register_file (
    .clk(clk),
    .reset(reset),
    .Rs1(rs1),               
    .Rs2(rs2),               
    .Rd(wb_rd),              
    .RegWrite(wb_RegWrite),  
    .Write_data(wb_write_data),
    .Read_data1(read_data1),
    .Read_data2(read_data2)
);

    ImmGen immgen_inst (
        .opcode(opcode),
        .instruction(instruction),
        .ImmExt(imm)
    );
  


endmodule