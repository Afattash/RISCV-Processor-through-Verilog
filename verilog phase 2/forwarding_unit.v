module ForwardingUnit (
    input  [4:0] ID_EX_rs1,
    input  [4:0] ID_EX_rs2,
    input  [4:0] EX_MEM_rd,
    input        EX_MEM_regWrite,
    input  [4:0] MEM_WB_rd,
    input        MEM_WB_regWrite,
    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);
    always @(*) begin
        // ForwardA logic
        if (EX_MEM_regWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1))
            forwardA = 2'b10;
        else if (MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1))
            forwardA = 2'b01;
        else
            forwardA = 2'b00;

        // ForwardB logic
        if (EX_MEM_regWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2))
            forwardB = 2'b10;
        else if (MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2))
            forwardB = 2'b01;
        else
            forwardB = 2'b00;
    end
endmodule
