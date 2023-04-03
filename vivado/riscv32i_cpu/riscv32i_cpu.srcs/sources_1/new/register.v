`timescale 1ns / 1ps

module register #(parameter DATA_WIDTH=32) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out
    );
    
    reg [DATA_WIDTH-1:0] data;
    
    always @ (posedge clk) begin
        if (rst == 1'b1)
            data <= 0;
        else
            data <= data_in;
    end
    
    assign data_out = data;
    
endmodule
