module register (
    input wire clk,          // Clock input
    input wire rst,          // Reset input (active high)
    input wire load,         // Load enable signal
    input wire [7:0] data_in,  // 8-bit input data
    output reg [7:0] data_out  // 8-bit output data
);

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            data_out <= 8'b0;  // Reset output to 0
        end
        else if (load) begin
            data_out <= data_in;  // Load new value when load is high
        end
        // Output remains unchanged when load is low (data retention)
    end

endmodule