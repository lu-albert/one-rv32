`timescale 1ns / 1ps

module adder #(parameter DATA_WIDTH = 32) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    output [DATA_WIDTH-1:0] out
    );
    
    assign out = a + b;
    
endmodule
