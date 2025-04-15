module register_tb;
    // Test signals
    reg clk;
    reg rst;
    reg load;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate the register
    register dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize signals
        rst = 0;
        load = 0;
        data_in = 8'h00;
        
        // Test 1: Reset functionality
        #10 rst = 1;
        #10 rst = 0;
        
        // Test 2: Load data
        #10;
        data_in = 8'hA5;
        load = 1;
        #10 load = 0;
        
        // Test 3: Data retention (change input while load is low)
        #10 data_in = 8'h55;
        #20;  // Wait two clock cycles to verify retention
        
        // Test 4: Load new data
        load = 1;
        #10 load = 0;
        
        // Test 5: Reset while holding data
        #20 rst = 1;
        #10 rst = 0;
        
        // Test 6: Load after reset
        #10;
        data_in = 8'hFF;
        load = 1;
        #10 load = 0;
        
        // End simulation
        #20 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t rst=%b load=%b data_in=%h data_out=%h", 
                 $time, rst, load, data_in, data_out);
        
        // Generate waveform file
        // $dumpfile("register_tb.vcd");
        // $dumpvars(0, register_tb);
    end

endmodule