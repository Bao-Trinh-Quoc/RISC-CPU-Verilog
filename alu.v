module alu (
    input  [7:0] inA,       
    input  [7:0] inB,       
    input  [2:0] opcode,    
    output reg [7:0] alu_out,
    output      is_zero     
);

assign is_zero = (inA == 8'b0); 

always @(*) begin
    case(opcode)
        3'b010: alu_out = inA + inB;
        3'b011: alu_out = inA & inB;
        3'b100: alu_out = inA ^ inB;
        default: alu_out = 8'b0;
    endcase
end

endmodule  
