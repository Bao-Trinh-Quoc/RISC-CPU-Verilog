module alu_tb();
    // Test signals
    reg [2:0] opcode;
    reg [7:0] inA;
    reg [7:0] inB;
    wire [7:0] result;
    wire is_zero;

    // Instantiate the ALU
    alu dut (
        .opcode(opcode),
        .inA(inA),
        .inB(inB),
        .result(result),
        .is_zero(is_zero)
    );

    // Test stimulus
    initial begin
        // Initialize inputs
        opcode = 3'b000;
        inA = 8'h00;
        inB = 8'h00;
        #10;

        // Test HLT operation (000)
        opcode = 3'b000;
        inA = 8'hAA;
        inB = 8'h55;
        #10;
        if (result !== inA)
            $display("HLT Test Failed: Expected %h, got %h", inA, result);
        else
            $display("HLT Test Passed");

        // Test SKZ operation (001) with zero input
        opcode = 3'b001;
        inA = 8'h00;
        inB = 8'h55;
        #10;
        if (!is_zero)
            $display("SKZ Test Failed: Expected is_zero=1 for inA=0");
        else
            $display("SKZ Test Passed with zero input");

        // Test SKZ operation with non-zero input
        inA = 8'h55;
        #10;
        if (is_zero)
            $display("SKZ Test Failed: Expected is_zero=0 for inA!=0");
        else
            $display("SKZ Test Passed with non-zero input");

        // Test ADD operation (010)
        opcode = 3'b010;
        inA = 8'h55;
        inB = 8'hAA;
        #10;
        if (result !== (inA + inB))
            $display("ADD Test Failed: Expected %h, got %h", inA + inB, result);
        else
            $display("ADD Test Passed");

        // Test AND operation (011)
        opcode = 3'b011;
        inA = 8'hF0;
        inB = 8'h0F;
        #10;
        if (result !== (inA & inB))
            $display("AND Test Failed: Expected %h, got %h", inA & inB, result);
        else
            $display("AND Test Passed");

        // Test XOR operation (100)
        opcode = 3'b100;
        inA = 8'hF0;
        inB = 8'hFF;
        #10;
        if (result !== (inA ^ inB))
            $display("XOR Test Failed: Expected %h, got %h", inA ^ inB, result);
        else
            $display("XOR Test Passed");

        // Test LDA operation (101)
        opcode = 3'b101;
        inA = 8'h55;
        inB = 8'hAA;
        #10;
        if (result !== inB)
            $display("LDA Test Failed: Expected %h, got %h", inB, result);
        else
            $display("LDA Test Passed");

        // Test STO operation (110)
        opcode = 3'b110;
        inA = 8'h33;
        inB = 8'h44;
        #10;
        if (result !== inA)
            $display("STO Test Failed: Expected %h, got %h", inA, result);
        else
            $display("STO Test Passed");

        // Test JMP operation (111)
        opcode = 3'b111;
        inA = 8'h1F;
        inB = 8'hFF;
        #10;
        if (result !== inA)
            $display("JMP Test Failed: Expected %h, got %h", inA, result);
        else
            $display("JMP Test Passed");

        // End simulation
        #10;
        $display("All tests completed");
        $finish;
    end

    // Generate waveform file
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule