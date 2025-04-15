module program_counter_tb();
   /// Testbench signals
    reg clk;
    reg rst;
    reg ld_pc;
    reg inc_pc;
    reg [4:0] ir_addr;
    wire [4:0] pc_addr;

    // Instantiate the Program Counter module
    program_counter uut (
        .clk(clk),
        .rst(rst),
        .ld_pc(ld_pc),
        .inc_pc(inc_pc),
        .ir_addr(ir_addr),
        .pc_addr(pc_addr)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    always begin
        #5 clk = ~clk;
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        ld_pc = 0;
        inc_pc = 0;
        ir_addr = 5'b00000;

        // Dump variables for waveform viewing
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, tb_program_counter);

        // Test case 1: Reset
        #10 rst = 1;          // Apply reset
        #10 rst = 0;          // Release reset
        $display("After reset: pc_addr = %b", pc_addr);

        // Test case 2: Increment PC with inc_pc
        #10 inc_pc = 1;       // Enable increment
        #20 inc_pc = 0;       // Disable increment after 2 cycles
        $display("After 2 increments: pc_addr = %b", pc_addr);

        // Test case 3: Load a value from ir_addr (e.g., 5'b10101)
        #10 ld_pc = 1;
        ir_addr = 5'b10101;
        #10 ld_pc = 0;        // Load for 1 cycle, then disable
        $display("After load 10101 from ir_addr: pc_addr = %b", pc_addr);

        // Test case 4: Resume incrementing
        #10 inc_pc = 1;
        #20 inc_pc = 0;       // Increment for 2 cycles
        $display("After 2 more increments: pc_addr = %b", pc_addr);

        // End simulation
        #10 $finish;
    end

endmodule