`timescale 1ns / 1ps

module mux2 #(parameter DATA_WIDTH=32) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input sel,
    output [DATA_WIDTH-1:0] out
    );
    
    assign out = (sel == 0) ? a : b;
    
endmodule
