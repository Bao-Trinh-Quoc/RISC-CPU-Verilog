//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Author: Phan Minh Trong
// 
// Create Date: 10/04/2025 13:00
// Module Name: memory
// Description: 
//  - Main memory block for RISC-CPU.
// Revision:
//////////////////////////////////////////////////////////////////////////////////

module memory (
        input       clk,     // System clock (posedge triggered)
        input       read_en, // Active-high asynchronous read memory enable signal
        input       write_en // Active-high asynchronous write memory enable signal
        input [4:0] address, // 5-bit memory access address
        inout [7:0] data     // 8-bit data
);

    //------------------------------------------
    // Internal Registers
    //------------------------------------------
    reg [255:0] _memory // Main storage for datas and instructions
    

endmodule