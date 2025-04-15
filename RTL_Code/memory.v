module memory (
        input       clk,      // System clock (posedge triggered)
        input       read_en,  // Active-high asynchronous read from memory enable signal
        input       write_en, // Active-high asynchronous write to memory enable signal
        input [4:0] address,  // 5-bit memory access address
        inout [7:0] data_bus  // 8-bit data
);

    //------------------------------------------
    // Internal Registers
    //------------------------------------------
    reg [7:0] _memory [255:0]; // Main storage for datas and instructions
    reg [7:0] data_buffer;     // Data buffer for writing data to data bus

    //------------------------------------------
    // Read/write execution
    //------------------------------------------
    assign data_bus = read_en ? data_buffer : 8'bz;
    always @(posedge clk) begin
        if (read_en) begin
            data_buffer = _memory[address];
        end
        else if (write_en) begin
            _memory[address] = data_bus;
        end
    end

endmodule