`timescale 1ns / 1ps

// Debug unit for the CPU, specifically for the Digilent Basys-3 FPGA board. This is for the 7-segment LEDs.
module cpu_debug #(parameter DATA_WIDTH = 32) (
    input clk,
    input [DATA_WIDTH-1:0] rd3,
    input sw_bit,
    output [6:0] seg,
    output [3:0] an
    );
    
    wire [15:0] display;
    
    assign display = (sw_bit == 1'b0) ? rd3[(DATA_WIDTH/2)-1:0] : rd3[DATA_WIDTH-1:(DATA_WIDTH/2)]; 
    
    seven_seg_display sd (
        .clk(clk),
        .in(display),
        .out(seg),
        .an(an)
        );
    
endmodule
