module address_mux_tb();
    // Parameters
    localparam WIDTH = 5;

    // Testbench signals
    reg [WIDTH-1:0] inst_addr;
    reg [WIDTH-1:0] op_addr;
    reg sel;
    wire [WIDTH-1:0] addr_out;

    // Instantiate the address mux
    address_mux #(
        .WIDTH(WIDTH)
    ) mux (
        .inst_addr(inst_addr),
        .op_addr(op_addr),
        .sel(sel),
        .addr_out(addr_out)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        inst_addr = 0;
        op_addr = 0;
        sel = 0;

        // Test case 1: Select instruction address
        #10;
        inst_addr = 5'b10101;
        op_addr = 5'b11111;
        sel = 0;
        #10;
        if (addr_out !== inst_addr)
            $display("Test 1 Failed: Expected %b, got %b", inst_addr, addr_out);
        else
            $display("Test 1 Passed: Instruction address selected correctly");

        // Test case 2: Select operand address
        #10;
        inst_addr = 5'b10101;
        op_addr = 5'b11111;
        sel = 1;
        #10;
        if (addr_out !== op_addr)
            $display("Test 2 Failed: Expected %b, got %b", op_addr, addr_out);
        else
            $display("Test 2 Passed: Operand address selected correctly");

        // Test case 3: Change addresses while maintaining selection
        sel = 0;
        #10;
        inst_addr = 5'b00001;
        op_addr = 5'b00010;
        #10;
        if (addr_out !== inst_addr)
            $display("Test 3 Failed: Expected %b, got %b", inst_addr, addr_out);
        else
            $display("Test 3 Passed: Address change handled correctly");

        // End simulation
        #10;
        $display("All tests completed");
        $finish;
    end

    // Optional: Generate VCD file for waveform viewing
    // initial begin
    //     $dumpfile("address_mux_tb.vcd");
    //     $dumpvars(0, address_mux_tb);
    // end

endmodule