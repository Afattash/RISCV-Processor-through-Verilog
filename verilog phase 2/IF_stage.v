`include "PC.v"
`include "Instruction_Memory.v"

module IF_stage (
    input  wire        clk,
    input  wire        reset,        
    input  wire [31:0] pc_branch_target, 
    input  wire        branch_taken,                    
    output wire [31:0] instruction,     
    output wire [31:0] pc_plus4,        
    output wire [31:0] pc_current,
     input wire PC_write       
);

    wire [31:0] pc_next;

    // Print every fetch (optional for debug)
    always @(posedge clk) $display("FETCH: PC=%0d instruction=%h", pc_current, instruction);

    assign pc_next = branch_taken ? pc_branch_target : (pc_current + 1);

    PC PC1 (
        .clk(clk),
        .reset(reset),
        .PC_in(pc_next),
        .PC_out(pc_current)
    );

    wire [31:0] instruction_out;

    Instruction_Memory instruction_memory (
        .read_address(pc_current[7:0]),
        .instruction_out(instruction_out)
    );

    assign pc_plus4   = pc_current + 32'd1;
    assign instruction = instruction_out;

endmodule
