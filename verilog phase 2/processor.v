`include "WB_stage.v"
`include "EXE_stage.v"
`include "MEM_stage.v"
`include "ID_stage.v"
`include "IF_stage.v"
`include "Control_Unit.v"
`include "hazard_detection_unit.v"
`include "branch_predictor.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"

module Processor (
    input wire clk,
    input wire reset
);
// --- Data Memory signals (connect these properly in your pipeline) ---


    // IF signals
    wire [31:0] pc_current, pc_plus4, instruction;

    // IF/ID pipeline register outputs
    wire [31:0] IF_ID_instr, IF_ID_pc;

    // ID signals
    wire [31:0] read_data1, read_data2, imm;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign rs1    = IF_ID_instr[19:15];
    assign rs2    = IF_ID_instr[24:20];
    assign rd     = IF_ID_instr[11:7];
    assign funct3 = IF_ID_instr[14:12];
    assign funct7 = IF_ID_instr[31:25];

    // Control signals (from CU)
    wire branch, MemtoReg, MemRead, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ALUop;
wire control_mux;
wire PC_write, IF_ID_write;

    // ID/EX pipeline register outputs
    wire [31:0] ID_EX_pc, ID_EX_reg1, ID_EX_reg2, ID_EX_imm;
    wire [4:0]  ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
    wire [2:0]  ID_EX_funct3;
    wire [6:0]  ID_EX_funct7;
    wire        ID_EX_branch, ID_EX_RegWrite, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_MemtoReg, ID_EX_ALUSrc;
    wire [1:0]  ID_EX_ALUop;

    // EXE signals
    wire [31:0] alu_result;
    wire branch_taken;
    wire [31:0] branch_target;
    wire [31:0] EXE_store_data_out, EX_MEM_store_data;


    // EX/MEM pipeline register outputs
    wire [31:0] EX_MEM_result, EX_MEM_reg2;
    wire [4:0]  EX_MEM_rd;
    wire        EX_MEM_RegWrite, EX_MEM_MemRead, EX_MEM_MemWrite, EX_MEM_MemtoReg;
    wire EX_MEM_branch_taken;
wire [31:0] EX_MEM_branch_target;

    // MEM signals
    wire [31:0] mem_read_data;

    // MEM/WB pipeline register outputs
    wire [31:0] MEM_WB_mem_data_out, MEM_WB_alu_result_out;
    wire [4:0]  MEM_WB_rd_out;
    wire        MEM_WB_regWrite_out, MEM_WB_memToReg_out;

    // WB mux output
    wire [31:0] write_back_data;

    // Hazard detection, forwarding, branch prediction (expand as needed)
    wire flush;
    assign flush = branch_taken; // From EXE_stage only!

    // Branch Predictor (optional, still using predicted_taken for IF_stage)
    wire predicted_taken, actual_taken, update_predictor;
    assign actual_taken = ID_EX_branch; // (simple assumption)
    assign update_predictor = 1'b1;     // Always update
    BranchPredictor predictor (
        .clk(clk),
        .reset(reset),
        .PC(pc_current),
        .actual_branch(actual_taken),
        .update(update_predictor),
        .predicted_taken(predicted_taken)
    );
Data_memory RAM (
    .clk(clk),
    .addr(EX_MEM_result),         // 32-bit ALU result, address to access
    .mem_write(EX_MEM_MemWrite),  // Memory write enable
    .mem_read(EX_MEM_MemRead),    // Memory read enable
    .write_data(EX_MEM_reg2),     // Data to write (for sw)
    .read_data(mem_read_data)     // Data output (for lw)
);

    // ==========================
    // IF Stage
    // ==========================
    IF_stage IF (
        .clk(clk),
        .reset(reset),           
        .instruction(instruction),
        .pc_plus4(pc_plus4),
        .pc_current(pc_current),
        .pc_branch_target(EX_MEM_branch_target),
    .branch_taken(EX_MEM_branch_taken),
    .PC_write(PC_write)
    );



    // ==========================
    // IF/ID Pipeline Register
    // ==========================
    IF_ID if_id_reg (
        .clk(clk),
        .reset(reset),
        .flush(flush),         
         .write(IF_ID_write),          
        .instr_in(instruction),
        .pc_in(pc_plus4),
        .instr_out(IF_ID_instr),
        .pc_out(IF_ID_pc)
    );

    // ==========================
    // ID Stage
    // ==========================
    wire [31:0] rf_read_data1, rf_read_data2;
    wire [4:0]  rf_rs1, rf_rs2, rf_rd;

    assign rf_rs1 = IF_ID_instr[19:15];
    assign rf_rs2 = IF_ID_instr[24:20];
    assign rf_rd  = IF_ID_instr[11:7];

    Register_file register_file (
        .clk(clk),
        .reset(reset),
        .Rs1(rf_rs1),
        .Rs2(rf_rs2),
        .Rd(MEM_WB_rd_out),               
        .RegWrite(MEM_WB_regWrite_out),   
        .Write_data(write_back_data),     
        .Read_data1(rf_read_data1),
        .Read_data2(rf_read_data2)
    );

    // Immediate generator (assuming your ImmGen module)
    ImmGen immgen_inst (
        .opcode(IF_ID_instr[6:0]),
        .instruction(IF_ID_instr),
        .ImmExt(imm)
    );

    // Control unit
    Control_Unit CU (
        .OPcode(IF_ID_instr[6:0]),
        .branch(branch),
        .ALUSrc(ALUSrc),
        .ALUop(ALUop),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite)
    );
wire branch_hazard   = control_mux ? 1'b0 : branch;
wire MemtoReg_hazard = control_mux ? 1'b0 : MemtoReg;
wire MemRead_hazard  = control_mux ? 1'b0 : MemRead;
wire MemWrite_hazard = control_mux ? 1'b0 : MemWrite;
wire ALUSrc_hazard   = control_mux ? 1'b0 : ALUSrc;
wire RegWrite_hazard = control_mux ? 1'b0 : RegWrite;
wire [1:0] ALUop_hazard = control_mux ? 2'b00 : ALUop;
    // ==========================
    // ID/EX Pipeline Register
    // ==========================
    HazardDetectionUnit hazard_unit (
    .ID_EX_rd(ID_EX_rd),
    .ID_EX_memRead(ID_EX_MemRead),
    .IF_ID_rs1(IF_ID_instr[19:15]),
    .IF_ID_rs2(IF_ID_instr[24:20]),
    .PC_write(PC_write),
    .IF_ID_write(IF_ID_write),
    .control_mux(control_mux)
);

ID_EX id_ex_reg (
    .clk(clk), .reset(reset), .bubble(control_mux), .flush(flush),
    .pc_in(IF_ID_pc), .reg1_in(rf_read_data1), .reg2_in(rf_read_data2), .imm_in(imm),
    .rs1_in(rf_rs1), .rs2_in(rf_rs2), .rd_in(rf_rd),
    .funct3_in(funct3), .funct7_in(funct7),
    .branch_in(branch_hazard),
    .regWrite_in(RegWrite_hazard),
    .memRead_in(MemRead_hazard),
    .memWrite_in(MemWrite_hazard),
    .memToReg_in(MemtoReg_hazard),
    .ALUop_in(ALUop_hazard),
    .ALUSrc_in(ALUSrc_hazard),
    .pc_out(ID_EX_pc), .reg1_out(ID_EX_reg1), .reg2_out(ID_EX_reg2), .imm_out(ID_EX_imm),
    .rs1_out(ID_EX_rs1), .rs2_out(ID_EX_rs2), .rd_out(ID_EX_rd),
    .funct3_out(ID_EX_funct3), .funct7_out(ID_EX_funct7),
    .branch_out(ID_EX_branch), .regWrite_out(ID_EX_RegWrite), .memRead_out(ID_EX_MemRead),
    .memWrite_out(ID_EX_MemWrite), .memToReg_out(ID_EX_MemtoReg),
    .ALUop_out(ID_EX_ALUop), .ALUSrc_out(ID_EX_ALUSrc)
);


    // ==========================
    // EXE Stage
    // ==========================
    EXE_stage EXE (
        .reg_data1_in(ID_EX_reg1),
        .reg_data2_in(ID_EX_reg2),
        .imm(ID_EX_imm),
        .rs1(ID_EX_rs1),
        .rs2(ID_EX_rs2),
        .ex_mem_rd(EX_MEM_rd),
        .ex_mem_RegWrite(EX_MEM_RegWrite),
        .mem_wb_rd(MEM_WB_rd_out),
        .mem_wb_RegWrite(MEM_WB_regWrite_out),
        .ex_mem_result(EX_MEM_result),
        .wb_data(write_back_data),
        .ALUSrc(ID_EX_ALUSrc),
        .ALUOp(ID_EX_ALUop),
        .funct3(ID_EX_funct3),
        .funct7(ID_EX_funct7),
        .branch(ID_EX_branch),      // comes from ID/EX pipeline register
        .pc(ID_EX_pc),
        .alu_result(alu_result),
        .branch_taken(branch_taken),
        .branch_target(branch_target),
        .store_data_out(EXE_store_data_out)

    );

    // ==========================
    // EX/MEM Pipeline Register
    // ==========================
EX_MEM ex_mem_reg (
    .clk(clk), .reset(reset),
    .alu_result_in(alu_result),
    .store_data_in(EXE_store_data_out), 
    .rd_in(ID_EX_rd),
    .rd_out(EX_MEM_rd),
    .branch_in(ID_EX_branch),
    .branch_taken_in(branch_taken),          
    .branch_target_in(branch_target),       
    .regWrite_in(ID_EX_RegWrite),
    .memRead_in(ID_EX_MemRead),
    .memWrite_in(ID_EX_MemWrite),
    .memToReg_in(ID_EX_MemtoReg),
    .alu_result_out(EX_MEM_result),
    .store_data_out(EX_MEM_store_data),
    .branch_out(EX_MEM_branch),             
    .branch_taken_out(EX_MEM_branch_taken), 
    .branch_target_out(EX_MEM_branch_target), 
    .regWrite_out(EX_MEM_RegWrite),
    .memRead_out(EX_MEM_MemRead),
    .memWrite_out(EX_MEM_MemWrite),
    .memToReg_out(EX_MEM_MemtoReg)
);


    // ==========================
    // MEM Stage
    // ==========================
    MEM_stage MEM (
        .clk(clk),
        .mem_read(EX_MEM_MemRead),
        .mem_write(EX_MEM_MemWrite),
        .alu_result(EX_MEM_result),
        .write_data(EX_MEM_store_data),
        .mem_read_data(mem_read_data)
    );

    // ==========================
    // MEM/WB Pipeline Register
    // ==========================
    MEM_WB mem_wb_reg (
        .clk(clk), .reset(reset),
        .mem_data_in(mem_read_data),
        .alu_result_in(EX_MEM_result),
        .rd_in(EX_MEM_rd),
        .regWrite_in(EX_MEM_RegWrite),
        .memToReg_in(EX_MEM_MemtoReg),
        .mem_data_out(MEM_WB_mem_data_out),
        .alu_result_out(MEM_WB_alu_result_out),
        .rd_out(MEM_WB_rd_out),
        .regWrite_out(MEM_WB_regWrite_out),
        .memToReg_out(MEM_WB_memToReg_out)
    );

    // ==========================
    // WB Stage
    // ==========================
    WB_stage WB (
        .alu_result(MEM_WB_alu_result_out),
        .mem_data(MEM_WB_mem_data_out),
        .MemtoReg(MEM_WB_memToReg_out),
        .write_data(write_back_data)
    );

endmodule
