module MEM_WB (
    input         clk,
    input         reset,
    input  [31:0] mem_data_in,
    input  [31:0] alu_result_in,
    input  [4:0]  rd_in,
    input         regWrite_in,
    input         memToReg_in,
    output reg [31:0] mem_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0]  rd_out,
    output reg        regWrite_out,
    output reg        memToReg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data_out   <= 32'b0;
            alu_result_out <= 32'b0;
            rd_out         <= 5'b0;
            regWrite_out   <= 0;
            memToReg_out   <= 0;
        end else begin
            mem_data_out   <= mem_data_in;
            alu_result_out <= alu_result_in;
            rd_out         <= rd_in;
            regWrite_out   <= regWrite_in;
            memToReg_out   <= memToReg_in;
        end
         end
        always @(posedge clk) begin
 $display("MEM_WB: rd=%d, regWrite=%b, alu_result=%h, mem_data=%h", rd_out, regWrite_out, alu_result_out, mem_data_out);
end

   

endmodule