`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2025 08:38:16 PM
// Design Name: 
// Module Name: writeback
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module writeback(
    input MemToReg,
    input [31:0] read_data, ALU_result,
    output [31:0] write_data
);
    
    mux32 WB_mux(
        .a(read_data), 
        .b(ALU_result), 
        .sel(MemToReg), 
        .y(write_data)
    );
endmodule
