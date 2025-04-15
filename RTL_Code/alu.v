module alu (
    input wire [2:0] opcode,     // 3-bit operation code
    input wire [7:0] inA,        // 8-bit input A (from Accumulator)
    input wire [7:0] inB,        // 8-bit input B (from Memory)
    output reg [7:0] result,     // 8-bit result
    output wire is_zero          // Flag indicating if inA is zero
);

    // Operation codes
    localparam HLT = 3'b000;  // Halt
    localparam SKZ = 3'b001;  // Skip if zero
    localparam ADD = 3'b010;  // Add
    localparam AND = 3'b011;  // Logical AND
    localparam XOR = 3'b100;  // Logical XOR
    localparam LDA = 3'b101;  // Load accumulator
    localparam STO = 3'b110;  // Store
    localparam JMP = 3'b111;  // Jump

    // Asynchronous zero detection for inA
    assign is_zero = (inA == 8'b0);

    // Combinational logic for ALU operations
    always @(*) begin
        case (opcode)
            HLT: result = inA;           // Stop program, pass through inA
            SKZ: result = inA;           // Check if zero, pass through inA
            ADD: result = inA + inB;     // Add inA and inB
            AND: result = inA & inB;     // Bitwise AND
            XOR: result = inA ^ inB;     // Bitwise XOR
            LDA: result = inB;           // Load value from memory (inB)
            STO: result = inA;           // Store value to memory, pass through inA
            JMP: result = inA;           // Jump to address, pass through inA
            default: result = 8'b0;      // Default case (should never occur)
        endcase
    end

endmodule