module ALU_Control (
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALU_Ctrl
);

always @(*) begin
    case (ALUOp)
        2'b00: begin // Loads, Stores, ADDI, ORI, ANDI, etc.
            case (funct3)
                3'b000: ALU_Ctrl = 4'b0000; // ADD/ADDI
                3'b010: ALU_Ctrl = 4'b0000; // LW/SW should use ADD
                3'b110: ALU_Ctrl = 4'b0010; // OR/ORI
                3'b111: ALU_Ctrl = 4'b0011; // AND/ANDI
                3'b100: ALU_Ctrl = 4'b0100; // XOR/XORI
                default: ALU_Ctrl = 4'b1111;
            endcase
        end
        2'b01: begin // Branches (BEQ, BNE, etc.) use SUB
            ALU_Ctrl = 4'b0001; // SUB for branches
        end
        2'b10: begin // R-type
            case ({funct7, funct3})
                10'b0000000_000: ALU_Ctrl = 4'b0000; // ADD
                10'b0100000_000: ALU_Ctrl = 4'b0001; // SUB
                10'b0000000_110: ALU_Ctrl = 4'b0010; // OR
                10'b0000000_111: ALU_Ctrl = 4'b0011; // AND
                10'b0000000_100: ALU_Ctrl = 4'b0100; // XOR
                default: ALU_Ctrl = 4'b1111;
            endcase
        end
        2'b11: begin // ADDIW/other 64-bit extensions if needed
            case ({funct7, funct3})
                10'b0000000_000: ALU_Ctrl = 4'b0000; // ADDIW as ADD
                default: ALU_Ctrl = 4'b1111;
            endcase
        end
        default: ALU_Ctrl = 4'b0000;
    endcase
end

endmodule
