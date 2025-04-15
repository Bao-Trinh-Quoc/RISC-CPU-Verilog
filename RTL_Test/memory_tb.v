`timescale 1ns / 1ps

module memory_tb();
    // Testbench signals
    //------------------------------------------
    // Parameters
    //------------------------------------------
    localparam CLK_HALF_PERIOD = 5; // 10ns clock period (50MHz)
    localparam TEST_DELAY      = 1000;

    //------------------------------------------
    // Signals
    //------------------------------------------
    reg       clk;
    reg       read_en;
    reg       write_en;
    reg [4:0] address;
    wire [7:0] data_bus;

    //------------------------------------------
    // Internal Registers
    //------------------------------------------
    reg [7:0] data_buffer;

    //------------------------------------------
    // Instantiate DUT
    //------------------------------------------
    memory uut (
        .clk      (clk),
        .read_en  (read_en),
        .write_en (write_en),
        .address  (address),
        .data_bus (data_bus)
    );

    //------------------------------------------
    // Clock Generation
    //------------------------------------------
    always #CLK_HALF_PERIOD clk = ~clk;

    //------------------------------------------
    // Test Sequence
    //------------------------------------------
    assign data_bus = read_en ? 8'bz : data_buffer;
    initial begin
        clk = 0;

        // At initial state, the memory contains no datas, so we start writing datas to it
        // I want to store:
        // 00110101b -> 10101b
        // 11000001b -> 10111b
        // 11111111b -> 11001b
        // 10110100b -> 10011b
        #10 read_en  = 0;
            write_en = 1;
            address = 5'b1_0101;
            data_buffer = 8'b0011_0101;

        #10 read_en  = 0;
            write_en = 1;
            address = 5'b1_0111;
            data_buffer = 8'b1100_0001;

        #10 read_en  = 0;
            write_en = 1;
            address = 5'b1_1001;
            data_buffer = 8'b1111_1111;

        #10 read_en  = 0;
            write_en = 1;
            address = 5'b1_0011;
            data_buffer = 8'b1011_0100;

        // Finishes storing datas,  datas from memory
        #10 read_en  = 1;
            write_en = 0;
            address = 5'b1_0111;

        // Re-write data in address location
        #10 read_en  = 0;
            write_en = 1;
            address = 5'b1_0111;
            data_buffer = 8'b1010_0101;
        
        #10 read_en  = 1;
            write_en = 0;
            address = 5'b1_0101;

        #10 read_en  = 1;
            write_en = 0;
            address = 5'b1_0111;

        // Test reading from uninitialized memory
        #10 read_en  = 1;
            write_en = 0;
            address = 5'b0_1001;

        // Finish simulation
        #(2*TEST_DELAY) $finish;
    end

    //------------------------------------------
    // Monitoring
    //------------------------------------------
    initial begin
        $monitor("Time: %0t | READ State: %b | WRITE State: %b | ADDRESS: %b | DATA: %b", 
                 $time, read_en, write_en, address, data_bus);
    end

    initial begin
       $dumpfile("waveform.vcd");
       $dumpvars(0, memory_tb);
   end

endmodule
