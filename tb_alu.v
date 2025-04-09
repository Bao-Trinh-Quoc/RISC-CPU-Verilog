`timescale 1ns/1ps

module tb_alu;
  reg [7:0] inA, inB;
  reg [2:0] opcode;
  wire [7:0] alu_out;
  wire is_zero;

  alu uut (
    .inA(inA), .inB(inB), .opcode(opcode),
    .alu_out(alu_out), .is_zero(is_zero)
  );

  initial begin
    $display("Time\tinA\tinB\topcode\talu_out\tis_zero");

    // ADD
    inA = 8'd5; inB = 8'd10; opcode = 3'b010;
    #10 $display("%4t\t%2d\t%2d\t%03b\t%2d\t%b", $time, inA, inB, opcode, alu_out, is_zero); //hiện lên Tcl Console

    // AND
    inA = 8'b10101010; inB = 8'b11001100; opcode = 3'b011;
    #10 $display("%4t\t%2b\t%2b\t%03b\t%b\t%b", $time, inA, inB, opcode, alu_out, is_zero);

    // XOR 
    inA = 8'hFF; inB = 8'h0F; opcode = 3'b100;
    #10 $display("%4t\t%2h\t%2h\t%03b\t%h\t%b", $time, inA, inB, opcode, alu_out, is_zero);

    // nếu ko đúng opcode => default
    inA = 8'd8; inB = 8'd2; opcode = 3'b001;
    #10 $display("%4t\t%2d\t%2d\t%03b\t%2d\t%b", $time, inA, inB, opcode, alu_out, is_zero);

    //Kiểm tra is_zero = 1
    inA = 8'd0; inB = 8'd123; opcode = 3'b010;
    #10 $display("%4t\t%2d\t%2d\t%03b\t%2d\t%b", $time, inA, inB, opcode, alu_out, is_zero);

    $finish;
  end
endmodule
