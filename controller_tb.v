`timescale 1ns/1ps

module controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg is_zero;

    // Outputs
    wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

    // Instantiate the controller module
    controller uut (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .is_zero(is_zero),
        .sel(sel),
        .rd(rd),
        .ld_ir(ld_ir),
        .halt(halt),
        .inc_pc(inc_pc),
        .ld_ac(ld_ac),
        .ld_pc(ld_pc),
        .wr(wr),
        .data_e(data_e)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock

    // Test procedure
    initial begin
        $display("Start controller testbench...");
        $dumpfile("controller_tb.vcd");
        $dumpvars(0, controller_tb);

        // Initialize
        clk = 0;
        rst = 1;
        opcode = 3'b000; // HLT
        is_zero = 0;

        // Reset for 1 cycle
        #10;
        rst = 0;

        // --- Test HLT ---
        opcode = 3'b000;
        #80; // đủ 8 trạng thái để quay lại

        // --- Test SKZ (is_zero = 1) ---
        opcode = 3'b001;
        is_zero = 1;
        #80;

        // --- Test SKZ (is_zero = 0) ---
        opcode = 3'b001;
        is_zero = 0;
        #80;
        // --- Test ADD ---
        opcode = 3'b010;
        #80;

        // --- Test LDA ---
        opcode = 3'b101;
        #80;

        // --- Test STO ---
        opcode = 3'b110;
        #80;
        // --- Test JMP ---
        opcode = 3'b111;
        #80;
        $finish;
    end

endmodule
