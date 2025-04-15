module risc_cpu (
    input wire clk,          // System clock
    input wire rst,          // Reset signal (active high)
    output wire halt         // Halt signal from controller
);

    // Internal wires for connecting components
    wire [4:0] pc_addr;          // Program counter output
    wire [4:0] ir_addr;          // Address from instruction register
    wire [4:0] addr_out;         // Address Mux output
    wire [7:0] data_bus;         // Bidirectional data bus
    wire [7:0] ir_out;           // Instruction register output
    wire [7:0] acc_out;          // Accumulator output
    wire [7:0] alu_result;       // ALU result

    // Control signals from controller
    wire sel;                    // Address Mux select
    wire rd;                     // Memory read enable
    wire ld_ir;                  // Load instruction register
    wire inc_pc;                 // Increment program counter
    wire ld_ac;                  // Load accumulator
    wire ld_pc;                  // Load program counter
    wire wr;                     // Memory write enable
    wire data_e;                 // Data enable
    wire is_zero;                // Zero flag from ALU

    // Extract opcode and operand from instruction
    wire [2:0] opcode;
    wire [4:0] operand;
    assign opcode = ir_out[7:5];    // Top 3 bits are opcode
    assign operand = ir_out[4:0];   // Bottom 5 bits are operand/address
    assign ir_addr = operand;        // Connect operand to ir_addr

    // Program Counter
    program_counter pc (
        .clk(clk),
        .rst(rst),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr)
    );

    // Address Multiplexer
    address_mux addr_mux (
        .inst_addr(pc_addr),
        .op_addr(ir_addr),
        .sel(sel),
        .addr_out(addr_out)
    );

    // Memory Unit
    memory mem (
        .clk(clk),
        .read_en(rd),
        .write_en(wr),
        .address(addr_out),
        .data_bus(data_bus)
    );

    // Instruction Register
    register inst_reg (
        .clk(clk),
        .rst(rst),
        .load(ld_ir),
        .data_in(data_bus),
        .data_out(ir_out)
    );

    // Accumulator Register
    register acc_reg (
        .clk(clk),
        .rst(rst),
        .load(ld_ac),
        .data_in(alu_result),
        .data_out(acc_out)
    );

    // ALU Unit
    alu alu_unit (
        .opcode(opcode),
        .inA(acc_out),
        .inB(data_bus),
        .result(alu_result),
        .is_zero(is_zero)
    );

    // Controller


endmodule