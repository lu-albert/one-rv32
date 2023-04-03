`timescale 1ns / 1ps

module tb_mux2();
    
    reg [31:0] a;
    reg [31:0] b;
    reg sel;
    
    wire [31:0] out;
    
    mux2 #(.DATA_WIDTH(32)) m2 (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
        );
    
    initial begin
        a = 32'd10; b = 32'd5; sel = 0; #10;
        if(out != a) 
            $display("Test failed for sel: %d, %x", sel, a);
        
        a = 32'd10; b = 32'd5; sel = 1; #10;
        if(out != b)
            $display("Test failed for sel: %d, %x", sel, b);
    end
    
endmodule
