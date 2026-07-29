`include "ALU.v"
`include "ALU_Control.v"
`include "forwarding_unit.v"

module EXE_stage (
    input  wire [31:0] reg_data1_in,
    input  wire [31:0] reg_data2_in,
    input  wire [31:0] imm,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  ex_mem_rd,
    input  wire        ex_mem_RegWrite,
    input  wire [4:0]  mem_wb_rd,
    input  wire        mem_wb_RegWrite,
    input  wire [31:0] ex_mem_result,
    input  wire [31:0] wb_data,
    input  wire        ALUSrc,
    input  wire [1:0]  ALUOp,
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    input  wire        branch,        // Is this instruction a branch?
    input  wire [31:0] pc,            // Needed for branch target calculation
    output wire [31:0] alu_result,
    output wire        branch_taken,  // Is the branch resolved as taken?
    output wire [31:0] branch_target,
    output wire [31:0] store_data_out
  // Where to jump if branch taken
    
);

    // Internal signals
    wire [3:0] alu_control;
    wire [1:0] forwardA, forwardB;
    reg [31:0] srcA, srcB_input;
    wire [31:0] srcB;
reg [31:0] store_data;
    // Forwarding logic
    ForwardingUnit fwd_unit (
        .ID_EX_rs1(rs1),
        .ID_EX_rs2(rs2),
        .EX_MEM_rd(ex_mem_rd),
        .EX_MEM_regWrite(ex_mem_RegWrite),
        .MEM_WB_rd(mem_wb_rd),
        .MEM_WB_regWrite(mem_wb_RegWrite),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    // Source selection (with forwarding)
    always @(*) begin
        case (forwardA)
            2'b00: srcA = reg_data1_in;
            2'b10: srcA = ex_mem_result;
            2'b01: srcA = wb_data;
            default: srcA = reg_data1_in;
        endcase

        case (forwardB)
            2'b00: srcB_input = reg_data2_in;
            2'b10: srcB_input = ex_mem_result;
            2'b01: srcB_input = wb_data;
            default: srcB_input = reg_data2_in;
        endcase

        // Debug print using actual variable names
        $display("EXE_stage ALU inputs: A=%h, B=%h, ALUCtrl=%b at PC=%h",
            srcA, (ALUSrc ? imm : srcB_input), alu_control, pc);
            $display("Cycle: %0t | rs1=%0d, rs2=%0d, forwardA=%b, forwardB=%b, srcA=%h, srcB_input=%h, ex_mem_result=%h, wb_data=%h",
         $time, rs1, rs2, forwardA, forwardB, srcA, srcB_input, ex_mem_result, wb_data);

    end

    assign srcB = ALUSrc ? imm : srcB_input;

    // ALU control and execution
    ALU_Control alu_ctrl_unit (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALU_Ctrl(alu_control)
    );

    ALU alu_unit (
        .input1(srcA),
        .input2(srcB),
        .operation(alu_control),
        .result(alu_result)
    );

    // ====== Branch Resolution Logic ======
    reg branch_cond_met;
    always @(*) begin
        case (funct3)
            3'b000: branch_cond_met = (srcA == srcB_input);                  // BEQ
            3'b001: branch_cond_met = (srcA != srcB_input);                  // BNE
            3'b100: branch_cond_met = ($signed(srcA) < $signed(srcB_input)); // BLT
            3'b101: branch_cond_met = ($signed(srcA) >= $signed(srcB_input));// BGE
            3'b110: branch_cond_met = (srcA < srcB_input);                   // BLTU
            3'b111: branch_cond_met = (srcA >= srcB_input);                  // BGEU
            default: branch_cond_met = 1'b0;
        endcase
        $display("Cycle: %0t | rs1=%0d, rs2=%0d, forwardA=%b, forwardB=%b, srcA=%h, srcB_input=%h, ex_mem_result=%h, wb_data=%h", $time, rs1, rs2, forwardA, forwardB, srcA, srcB_input, ex_mem_result, wb_data);

    end
assign store_data_out = srcB_input;
    assign branch_taken = branch && branch_cond_met;
    assign branch_target = pc + imm; // Standard RISC-V branch calculation

endmodule
