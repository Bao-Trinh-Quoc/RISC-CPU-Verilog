`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 09:11:11 AM
// Design Name: 
// Module Name: risc_cpu_tb
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


module risc_cpu_tb();
    // Test signals
    reg clk;
    reg rst;
    wire halt;

    // Instantiate the RISC CPU
    risc_cpu dut (
        .clk(clk),
        .rst(rst),
        .halt(halt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Memory initialization - Sample program
    initial begin
        // Load a test program into memory
        // Program:
        // 1. Load value from memory location 20 to accumulator (LDA 20)
        // 2. Add value from memory location 21 (ADD 21)
        // 3. Store result to memory location 22 (STO 22)
        // 4. Halt (HLT)
        
        dut.mem._memory[0] = 8'b101_10100;  // LDA 20 (Load from addr 20)
        dut.mem._memory[1] = 8'b010_10101;  // ADD 21 (Add value from addr 21)
        dut.mem._memory[2] = 8'b110_10110;  // STO 22 (Store to addr 22)
        dut.mem._memory[3] = 8'b000_00000;  // HLT

        dut.mem._memory[20] = 8'h05;        // First operand
        dut.mem._memory[21] = 8'h03;        // Second operand
    end

    // Test stimulus
    initial begin
        // Initialize
        rst = 0;
        
        // Apply reset
        #10 rst = 1;
        #10 rst = 0;

        // Wait for program to complete (halt)
        wait(halt);
        
        #10;
        if (dut.mem._memory[22] === 8'h08)
            $display("Test Passed: Correct result stored in memory");
        else
            $display("Test Failed: Expected 8'h08, got %h", dut.mem._memory[22]);

        #20 $finish;
    end

    initial begin
       $monitor("Time=%0t rst=%b halt=%b pc=%h ir=%h acc=%h state=%h opcode=%b", 
         $time, rst, halt, dut.pc_addr, dut.ir_out, dut.acc_out, 
         dut.ctrl.current_state, dut.opcode);
    end

    // Generate waveform file
    // initial begin
    //     $dumpfile("risc_cpu_tb.vcd");
    //     $dumpvars(0, risc_cpu_tb);
    // end

endmodule
