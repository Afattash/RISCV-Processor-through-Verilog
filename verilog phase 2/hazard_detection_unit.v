module HazardDetectionUnit (
    input  [4:0] ID_EX_rd,
    input        ID_EX_memRead,
    input  [4:0] IF_ID_rs1,
    input  [4:0] IF_ID_rs2,
    output reg   PC_write,
    output reg   IF_ID_write,
    output reg   control_mux 
);

    always @(*) begin
        // Default: no hazard
        PC_write      = 1;
        IF_ID_write   = 1;
        control_mux   = 0;

        // Stall if there's a real load-use hazard (excluding x0)
        if (ID_EX_memRead &&
            (ID_EX_rd != 0) &&
            ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2))) begin
            PC_write      = 0;
            IF_ID_write   = 0;
            control_mux   = 1;
        end
    end

endmodule
