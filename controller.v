module controller (
    input wire clk,
    input wire rst,
    input wire is_zero,
    input wire [2:0] opcode,

    output reg inc_pc, ld_pc,
    output reg sel, rd, wr,
    output reg ld_ir, ld_ac,
    output reg data_e
);

    typedef enum reg [2:0] {
        T0 = 3'd0, // Fetch Address
        T1 = 3'd1, // Read Instruction
        T2 = 3'd2, // Load IR
        T3 = 3'd3, // Operand Address
        T4 = 3'd4, // Operand Fetch
        T5 = 3'd5  // Execute
    } state_t;

    state_t current_state, next_state;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= T0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            T0: next_state = T1;
            T1: next_state = T2;
            T2: next_state = T3;
            T3: begin
                if (opcode == 3'b000 || opcode == 3'b111) // HLT, JMP
                    next_state = T5;
                else if (opcode == 3'b001 && !is_zero)    // SKZ
                    next_state = T0;
                else
                    next_state = T4;
            end
            T4: next_state = T5;
            T5: next_state = T0;
            default: next_state = T0;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default
        {inc_pc, ld_pc, sel, rd, wr, ld_ir, ld_ac, data_e} = 8'b0;

        case (current_state)
            T0: begin
                sel = 0;   // address from PC
                rd  = 1;
                inc_pc = 1;
            end
            T1: begin
                ld_ir = 1;
            end
            T3: begin
                sel = 1; // address from instruction
                rd = 1;
                if (opcode == 3'b111) ld_pc = 1;
            end
            T4: begin
                rd = 1;
            end
            T5: begin
                case (opcode)
                    3'b010, 3'b011, 3'b100: ld_ac = 1; // ADD, AND, XOR
                    3'b101: ld_ac = 1;                // LDA
                    3'b110: begin                     // STO
                        wr = 1;
                        data_e = 1;
                    end
                    default: ; // HLT, SKZ, JMP
                endcase
            end
        endcase
    end

endmodule
