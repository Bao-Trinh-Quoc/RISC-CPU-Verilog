module tb_address_mux;

    // Testbench signals
    reg sel;
  	reg [4:0] ir_addr;
  	reg [4:0] pc_addr;
    wire [4:0] addr_out;

    // Instantiate the Address Mux module
    address_mux uut (
        .sel(sel),
      	.ir_addr(ir_addr),
      	.pc_addr(pc_addr),
        .addr_out(addr_out)
    );

    // Test procedure
    initial begin
        // Dump variables for waveform viewing
        $dumpfile("addr_mux_tb.vcd");
        $dumpvars(0, tb_address_mux);

        // Test case 1: Select instruction address (sel = 1)
        sel = 1;
        ir_addr = 5'b10110;  // Example: 22
        pc_addr = 5'b00011;    // Example: 3
        #10;
      	$display("sel = %b, ir_addr = %b, pc_addr = %b, addr_out = %b", 
                 sel, ir_addr, pc_addr, addr_out);

        // Test case 2: Select operand address (sel = 0)
        sel = 0;
        ir_addr = 5'b10110;  // Same as above
        pc_addr = 5'b00011;    // Same as above
        #10;
      $display("sel = %b, ir_addr = %b, pc_addr = %b, addr_out = %b", 
                 sel, ir_addr, pc_addr, addr_out);

        // Test case 3: Change inputs and select instruction address
        sel = 1;
        ir_addr = 5'b11111;  // Example: 31
        pc_addr = 5'b00100;    // Example: 4
        #10;
      $display("sel = %b, ir_addr = %b, pc_addr = %b, addr_out = %b", 
                 sel, ir_addr, pc_addr, addr_out);

        // Test case 4: Change inputs and select operand address
        sel = 0;
        ir_addr = 5'b11111;  // Same as above
        pc_addr = 5'b00100;    // Same as above
        #10;
      $display("sel = %b, ir_addr = %b, pc_addr = %b, addr_out = %b", 
                 sel, ir_addr, pc_addr, addr_out);

        // End simulation
        #10 $finish;
    end

endmodule