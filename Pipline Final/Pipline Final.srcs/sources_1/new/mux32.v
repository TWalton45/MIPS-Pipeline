`timescale 1ns / 1ps

module mux32(
        output wire [31:0] y,
        input wire [31:0] a, b,
        input wire sel
    );
    //if sel = 1, then y = a
    //if sel = 0, tjem y = b
    assign  y = sel ? a: b;
    
endmodule
