module program_counter (
    input wire clk,            // Clock signal
    input wire rst,            // Reset signal (active-high)
    input wire ld_pc,          // Load enable signal (from ir_addr)
    input wire inc_pc,         // Increment enable signal
    input wire [4:0] ir_addr,  // 5-bit value to load from IR (for jumps)
    output reg [4:0] pc_addr   // 5-bit program counter output
);

    // Sequential logic triggered on positive edge of clock
    always @(posedge clk) begin
        if (rst) begin
            pc_addr <= 5'b00000;  // Reset to 0 when rst is high
        end
        else if (ld_pc) begin
            pc_addr <= ir_addr;   // Load value from ir_addr when ld_pc is high
        end
        else if (inc_pc) begin
            pc_addr <= pc_addr + 1; // Increment PC by 1 when inc_pc is high
        end
        // If neither ld_pc nor inc_pc is high, PC holds its value
    end

endmodule