module address_mux #(
    parameter WIDTH = 5  // Default width is 5 bits
)(
    input wire [WIDTH-1:0] inst_addr,    // Instruction address input
    input wire [WIDTH-1:0] op_addr,      // Operand address input
    input wire sel,                      // Select signal (0: inst_addr, 1: op_addr)
    output wire [WIDTH-1:0] addr_out     // Output address
);

    // Simple multiplexer logic
    assign addr_out = sel ? op_addr : inst_addr;

endmodule