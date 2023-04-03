`timescale 1ns / 1ps

module alu #(parameter DATA_WIDTH = 32) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input [3:0] alu_ctrl,
    output [DATA_WIDTH-1:0] out,
    output zero,
    output lt_signed,
    output lt_unsigned
    );
    
    reg [DATA_WIDTH-1:0] temp_out;
    
    wire [DATA_WIDTH-1:0] difference;
    
    assign {dcarry, difference} = a - b;
    
    always @ (*) begin
        case (alu_ctrl)
            4'b0000: temp_out = a + b;
            4'b0001: temp_out = difference;
            4'b0010: temp_out = a ^ b;
            4'b0011: temp_out = a | b;
            4'b0100: temp_out = a & b;
            4'b0101: temp_out = a << b[4:0];
            4'b0110: temp_out = a >> b[4:0];
            4'b0111: temp_out = $signed(a) >>> b[4:0];
            4'b1000: temp_out = (a[DATA_WIDTH-1] ^ b[DATA_WIDTH-1]) ? a[DATA_WIDTH-1] : difference[DATA_WIDTH-1];
            4'b1001: temp_out = dcarry;
            default: temp_out = a + b;
        endcase
    end
    
    assign out = temp_out;
    assign zero = ~(|temp_out); // Flip bit to make it so difference = 0 means zero = 1 (it is zero)
    assign lt_signed = difference[DATA_WIDTH-1];
    assign lt_unsigned = dcarry;
    
endmodule
