module BranchPredictor (
    input              clk,
    input              reset,
    input       [31:0] PC,
    input              actual_branch,   // 1 if branch taken
    input              update,          // when to update prediction
    output reg         predicted_taken
);

    reg [1:0] btb [0:255];  // 2-bit counters
    wire [7:0] index = PC[9:2]; // Use PC[9:2] as index
    integer j;

    always @(*) begin
        // Predict by MSB (standard way)
        predicted_taken = btb[index][1];
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (j = 0; j < 256; j = j + 1)
                btb[j] <= 2'b01; // weakly not taken
        end else if (update) begin
            if (actual_branch) begin
                if (btb[index] != 2'b11)
                    btb[index] <= btb[index] + 1;
            end else begin
                if (btb[index] != 2'b00)
                    btb[index] <= btb[index] - 1;
            end
        end
    end
endmodule
