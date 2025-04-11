module address_mux (parameter WIDTH = 5) (
  	input [WIDTH-1:0] pc_addr,   // Program Counter Address (5-bit)
  	input [WIDTH-1:0] ir_addr,   // Instruction Register Address (5-bit)
    input sel,             // Select signal (0 for PC, 1 for IR)
  	output reg [WIDTH-1:0] addr_out // Output selected address
);

    always @(*) begin
        if (sel) begin
            addr_out = ir_addr;  // Select IR Address if sel is 1
        end else begin
            addr_out = pc_addr;  // Select PC Address if sel is 0
        end
    end

endmodule
