`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 09:00:50 AM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller (
    input wire clk,
    input wire rst,               
    input wire [2:0] opcode,        
    input wire zero,          
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
    reg [2:0] current_state, next_state;
    localparam INST_ADDR = 3'b000;
    localparam INST_FETCH = 3'b001;
    localparam INST_LOAD = 3'b010;
    localparam IDLE = 3'b011;
    localparam OP_ADDR = 3'b100;
    localparam OP_FETCH = 3'b101;
    localparam ALU_OP = 3'b110;
    localparam STORE = 3'b111;

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

    // Control signal generation
    always @(*) begin
        // Reset all signals
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
                rd = 1;
                ld_ir = 1;
            end
            IDLE: begin
                sel = 1;
                rd = 1;
                ld_ir = 1;
            end
            OP_ADDR: begin
                if (opcode == 3'b000) // HLT
                    halt = 1;
                inc_pc = 1;
            end
            OP_FETCH: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) 
                    rd = 1; // ADD, AND, XOR, LDA
            end
            ALU_OP: begin
                if (opcode == 3'b010 || opcode == 3'b011 || opcode == 3'b100 || opcode == 3'b101) begin
                    rd = 1;
                    ld_ac = 1;
                end
                else if(opcode == 3'b001 && zero == 1) 
                    inc_pc = 1;
                else if(opcode == 3'b111) 
                    ld_pc = 1;
                else if(opcode == 3'b110) begin // STO
                    data_e = 1;
                end
            end
            STORE: begin
                if (opcode == 3'b110) begin // STO
                    wr = 1;
                    data_e = 1;
                end
                else if(opcode == 3'b111) 
                    ld_pc = 1;
            end
        endcase
    end

endmodule
