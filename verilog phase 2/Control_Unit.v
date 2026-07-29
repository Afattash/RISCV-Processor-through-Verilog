`ifndef CONTROL_UNIT_V
`define CONTROL_UNIT_V
module Control_Unit (
    input  wire [6:0] OPcode,
    output reg        branch,     
    output reg        MemtoReg,   
    output reg        MemRead,
    output reg        MemWrite,
    output reg        ALUSrc,
    output reg        RegWrite,
    output reg [1:0]  ALUop        // Control signal for ALU_Control
);

always @(*) begin
    case (OPcode)
        7'b0110011: begin // R-type
            branch    = 0;
            MemtoReg  = 0;
            MemRead   = 0;
            MemWrite  = 0;
            ALUSrc    = 0;
            RegWrite  = 1;
            ALUop     = 2'b10; // Use funct fields in ALU_Control
        end

        7'b0010011: begin // I-type (e.g., addi, andi, ori)
            branch    = 0;
            MemtoReg  = 0;
            MemRead   = 0;
            MemWrite  = 0;
            ALUSrc    = 1;
            RegWrite  = 1;
            ALUop     = 2'b10; // Still use funct3/funct7
        end
        7'b0011011: begin // I-type (addiw, slliw, etc)
            branch    = 0;
            MemtoReg  = 0;
            MemRead   = 0;
            MemWrite  = 0;
            ALUSrc    = 1;
            RegWrite  = 1;
            ALUop     = 2'b11;
        end
        7'b0000011: begin // lw
            branch    = 0;
            MemtoReg  = 1;
            MemRead   = 1;
            MemWrite  = 0;
            ALUSrc    = 1;
            RegWrite  = 1;
            ALUop     = 2'b00; // ALU = ADD
        end

        7'b0100011: begin // sw
            branch    = 0;
            MemtoReg  = 0; 
            MemRead   = 0;
            MemWrite  = 1;
            ALUSrc    = 1;
            RegWrite  = 0;
            ALUop     = 2'b00; // ALU = ADD
        end

        7'b1100011: begin // beq, bne
            branch    = 1;
            MemtoReg  = 0; 
            MemRead   = 0;
            MemWrite  = 0; 
            ALUSrc    = 0;
            RegWrite  = 0;
            ALUop     = 2'b01; // ALU = SUB
        end

        default: begin 
            branch    = 0;
            MemtoReg  = 0;
            MemRead   = 0;
            MemWrite  = 0;
            ALUSrc    = 0;
            RegWrite  = 0;
            ALUop     = 2'b00;
        end
    endcase
end

endmodule
`endif
