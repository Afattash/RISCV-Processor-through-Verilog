module EX_MEM (
    input         clk,
    input         reset,
    input  [31:0] alu_result_in,
    input  [31:0] reg2_in,
    input  [4:0]  rd_in,
    input         branch_in,
    input         branch_taken_in,      // NEW
    input  [31:0] branch_target_in,     // NEW
    input         regWrite_in,
    input         memRead_in,
    input         memWrite_in,
    input         memToReg_in,
    input  [31:0] store_data_in,
    output reg [31:0] alu_result_out,
    output reg [31:0] reg2_out,
    output reg [4:0]  rd_out,
    output reg        branch_out,
    output reg        branch_taken_out,     // NEW
    output reg [31:0] branch_target_out,    // NEW
    output reg        regWrite_out,
    output reg        memRead_out,
    output reg        memWrite_out,
    output reg        memToReg_out,
    output reg [31:0] store_data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out    <= 32'b0;
            reg2_out          <= 32'b0;
            rd_out            <= 5'b0;
            branch_out        <= 0;
            branch_taken_out  <= 0;
            branch_target_out <= 32'b0;
            regWrite_out      <= 0;
            memRead_out       <= 0;
            memWrite_out      <= 0;
            memToReg_out      <= 0;
            store_data_out    <= 32'b0;
        end else begin
            alu_result_out    <= alu_result_in;
            reg2_out          <= reg2_in;
            rd_out            <= rd_in;
            branch_out        <= branch_in;
            branch_taken_out  <= branch_taken_in;
            branch_target_out <= branch_target_in;
            regWrite_out      <= regWrite_in;
            memRead_out       <= memRead_in;
            memWrite_out      <= memWrite_in;
            memToReg_out      <= memToReg_in;
            store_data_out    <= store_data_in;
        end
        $display("EX_MEM: rd=%d, regWrite=%b, alu_result=%h", rd_out, regWrite_out, alu_result_out);
    end
endmodule
