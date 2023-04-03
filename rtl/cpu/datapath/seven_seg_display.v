`timescale 1ns / 1ps

module seven_seg_display(
    input clk,
    input [15:0] in,
    output reg [6:0] out,
    output reg [3:0] an
    );
    
    // Divide Clock
    reg [16:0] counter; // 17 bit counter, used to control the refresh rate
    reg [1:0] current;
    
    initial begin
        counter = 0;
        current = 0;
    end
    
    always @ (posedge clk) begin
        counter <= counter + 1;
        if(counter == 0) begin
            current <= current + 1;
        end
    end
    
    // Pick a display
    wire [6:0] s1, s2, s3, s4;
    
    seven_seg s_1 (
        .in(in[3:0]),
        .out(s1)
        );
    
    seven_seg s_2 (
        .in(in[7:4]),
        .out(s2)
        );
        
    seven_seg s_3 (
        .in(in[11:8]),
        .out(s3)
        );
        
    seven_seg s_4 (
        .in(in[15:12]),
        .out(s4)
        );
    
    always @ (*) begin
        case (current)
            2'b00: begin 
                out = s1;
                an = 4'b1110;
            end
            2'b01: begin 
                out = s2;
                an = 4'b1101;
            end
            2'b10: begin 
                out = s3;
                an = 4'b1011;
            end
            2'b11: begin 
                out = s4;
                an = 4'b0111;
            end
        endcase
    end
    
endmodule
