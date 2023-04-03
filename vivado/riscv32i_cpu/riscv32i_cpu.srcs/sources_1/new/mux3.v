`timescale 1ns / 1ps

module mux3 #(parameter DATA_WIDTH=32) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input [DATA_WIDTH-1:0] c,
    input [1:0] sel,
    output reg [DATA_WIDTH-1:0] out
    );
    
    always @ (*) begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            default: out = a;
        endcase
    end
    
endmodule
