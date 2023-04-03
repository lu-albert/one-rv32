`timescale 1ns / 1ps

module tb_adder();

    reg [31:0] a;
    reg [31:0] b;
    
    wire [31:0] out;
    
    adder #(.DATA_WIDTH(32)) add (
        .a(a),
        .b(b),
        .out(out)
        );
    
    initial begin
        a = 32'd10; b = 32'd100; #100;
        if(out != 32'd110)
            $display("Test failed for %d + %d", a, b);
        
        a = 32'hFFFFFFFF; b = 32'h00000001; #100;
        if(out != 32'h00000000)
            $display("Test failed for %d + %d", a, b);
            
        $finish();
    end

endmodule
