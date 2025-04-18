module controller (
    input clk,
    input rst,               
    input [2:0] opcode,        
    input is_zero,          
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg wr,
    output reg data_e
);

    // controller states
    typedef enum reg [2:0] {
        INST_ADDR = 3'd0,
        INST_FETCH = 3'd1,
        INST_LOAD = 3'd2,
        IDLE = 3'd3,
        OP_ADDR = 3'd4,
        OP_FETCH = 3'd5,
        ALU_OP = 3'd6,
        STORE = 3'd7
    } state_t;

    state_t current_state, next_state;

    // State transition
    always @(posedge clk) begin
        if (rst)
            current_state <= INST_ADDR;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            INST_ADDR:   next_state = INST_FETCH;
            INST_FETCH:  next_state = INST_LOAD;
            INST_LOAD:   next_state = IDLE;
            IDLE:        next_state = OP_ADDR;
            OP_ADDR:     next_state = OP_FETCH;
            OP_FETCH:    next_state = ALU_OP;
            ALU_OP:      next_state = STORE;
            STORE:       next_state = INST_ADDR;
            default:     next_state = INST_ADDR;
        endcase
    end

    // Điều khiển tín hiệu theo trạng thái và opcode
    always @(*) begin
        // reset tất cả tín hiệu
        sel = 0;
        rd = 0;
        ld_ir = 0;
        halt = 0;
        inc_pc = 0;
        ld_ac = 0;
        ld_pc = 0;
        wr = 0;
        data_e = 0;

        case (current_state)
            INST_ADDR: begin
                sel = 1;
            end
            INST_FETCH: begin
                sel = 1;
                rd = 1;
            end
            INST_LOAD: begin
                sel = 1;
                ld_ir = 1;
            end
            IDLE: begin
                if (opcode == 3'b000) // HLT
                    halt = 1;
                else if (opcode == 3'b001 && is_zero) // SKZ
                    inc_pc = 1;
            end
            OP_ADDR: begin
                sel = 0;
            end
            OP_FETCH: begin
                if (opcode != 3'b110) rd = 1; // không cần đọc nếu là STO
            end
            ALU_OP: begin
                case (opcode)
                    3'b010, 3'b011, 3'b100: ld_ac = 1;  // ADD, AND, XOR
                    3'b101: ld_ac = 1;                // LDA
                    3'b111: ld_pc = 1;                // JMP
                    default: ;
                endcase
            end
            STORE: begin
                if (opcode == 3'b110) begin // STO
                    wr = 1;
                    data_e = 1;
                end
            end
        endcase
    end

endmodule
