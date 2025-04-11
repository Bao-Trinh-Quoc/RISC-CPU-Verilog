`timescale 1ns / 1ps

module controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg is_zero;
    reg [2:0] opcode;

    // Outputs
    wire inc_pc, ld_pc, sel, rd, wr, ld_ir, ld_ac, data_e;

    // Instantiate the Controller
    controller uut (
        .clk(clk),
        .rst(rst),
        .is_zero(is_zero),
        .opcode(opcode),
        .inc_pc(inc_pc),
        .ld_pc(ld_pc),
        .sel(sel),
        .rd(rd),
        .wr(wr),
        .ld_ir(ld_ir),
        .ld_ac(ld_ac),
        .data_e(data_e)
    );

    // Clock
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("Start controller test");
        $dumpfile("controller_tb.vcd");
        $dumpvars(0, controller_tb);

        clk = 0;
        rst = 1;
        is_zero = 0;
        opcode = 3'b000; // HLT

        #10 rst = 0;
        #50 opcode = 3'b101; // LDA
        #50 opcode = 3'b110; // STO
        #50 opcode = 3'b111; // JMP
        #50 opcode = 3'b001; is_zero = 1; // SKZ và zero
        #50 opcode = 3'b001; is_zero = 0; // SKZ và không zero
        #100 $finish;
    end
endmodule
