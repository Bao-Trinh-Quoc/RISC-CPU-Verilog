module memory (
    input wire clk,           // System clock (posedge triggered)
    input wire read_en,       // Active-high read enable signal
    input wire write_en,      // Active-high write enable signal
    input wire [4:0] address, // 5-bit memory access address
    inout wire [7:0] data_bus // 8-bit bidirectional data bus
);

    // Internal storage
    reg [7:0] _memory [31:0]; // Memory array (32 locations for 5-bit address)
    reg [7:0] data_buffer;    // Buffer for read data

    // Bidirectional data bus control
    assign data_bus = (read_en && !write_en) ? data_buffer : 8'bz;

    // Read/write logic
    always @(posedge clk) begin
        if (read_en && !write_en) begin
            data_buffer <= _memory[address]; // Read data to buffer
        end
        else if (write_en && !read_en) begin
            _memory[address] <= data_bus; // Write data to memory
        end
    end

endmodule