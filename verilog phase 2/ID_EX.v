module ID_EX (
    input         clk,
    input         reset,
    input         bubble,
    input         flush,
    input  [31:0] pc_in,
    input  [31:0] reg1_in,
    input  [31:0] reg2_in,
    input  [31:0] imm_in,
    input  [4:0]  rs1_in,
    input  [4:0]  rs2_in,
    input  [4:0]  rd_in,
    input  [2:0]  funct3_in,
    input  [6:0]  funct7_in,
    input         branch_in,
    input         regWrite_in,
    input         memRead_in,
    input         memWrite_in,
    input         memToReg_in,
    input  [1:0]  ALUop_in,
    input         ALUSrc_in,
    output reg [31:0] pc_out,
    output reg [31:0] reg1_out,
    output reg [31:0] reg2_out,
    output reg [31:0] imm_out,
    output reg [4:0]  rs1_out,
    output reg [4:0]  rs2_out,
    output reg [4:0]  rd_out,
    output reg [2:0]  funct3_out,
    output reg [6:0]  funct7_out,
    output reg        branch_out,
    output reg        regWrite_out,
    output reg        memRead_out,
    output reg        memWrite_out,
    output reg        memToReg_out,
    output reg [1:0]  ALUop_out,
    output reg        ALUSrc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush || bubble) begin
            pc_out       <= 32'b0;
            reg1_out     <= 32'b0;
            reg2_out     <= 32'b0;
            imm_out      <= 32'b0;
            rs1_out      <= 5'b0;
            rs2_out      <= 5'b0;
            rd_out       <= 5'b0;
            funct3_out   <= 3'b0;
            funct7_out   <= 7'b0;
            branch_out   <= 0;
            regWrite_out <= 0;
            memRead_out  <= 0;
            memWrite_out <= 0;
            memToReg_out <= 0;
            ALUop_out    <= 2'b00;
            ALUSrc_out   <= 0;
        end else begin
            pc_out       <= pc_in;
            reg1_out     <= reg1_in;
            reg2_out     <= reg2_in;
            imm_out      <= imm_in;
            rs1_out      <= rs1_in;
            rs2_out      <= rs2_in;
            rd_out       <= rd_in;
            funct3_out   <= funct3_in;
            funct7_out   <= funct7_in;
            branch_out   <= branch_in;
            regWrite_out <= regWrite_in;
            memRead_out  <= memRead_in;
            memWrite_out <= memWrite_in;
            memToReg_out <= memToReg_in;
            ALUop_out    <= ALUop_in;
            ALUSrc_out   <= ALUSrc_in;
        end
    end

    // For debug: display at each clock edge
    always @(posedge clk) begin
        $display("ID/EX passing imm=%h, ALUSrc=%b, funct3=%b, funct7=%b", imm_out, ALUSrc_out, funct3_out, funct7_out);
    end

endmodule
