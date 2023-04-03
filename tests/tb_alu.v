`timescale 1ns / 1ps

module tb_alu();

    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_ctrl;
    
    wire [31:0] out;
    wire zero;
    
    alu #(.DATA_WIDTH(32)) dut (
        .a(a),
        .b(b),
        .alu_ctrl(alu_ctrl),
        .out(out),
        .zero(zero)
        );
    
    initial begin
        #2;
        a = 32'd10; b = 32'd5; alu_ctrl = 4'b0000; #15;
        if(out != 32'd15 || zero != 0)
            $display("Test failed: Add");
            
        a = 32'd10; b = 32'd5; alu_ctrl = 4'b0001; #15;
        if(out != 32'd5 || zero != 0)
            $display("Test failed: Subtract");
            
        a = 32'd10; b = 32'd10; alu_ctrl = 4'b0001; #15;
        if(out != 32'd0 || zero == 0)
            $display("Test failed: Subtract and must be zero");
        
        a = 32'hFFFF0000; b = 32'hF000FFFF; alu_ctrl = 4'b0010; #15;
        if(out != 32'h0FFFFFFF || zero != 0)
            $display("Test failed: XOR");
            
        a = 32'hFFFF0000; b = 32'hF000FFFF; alu_ctrl = 4'b0011; #15;
        if(out != 32'hFFFFFFFF || zero != 0)
            $display("Test failed: OR");
        
        a = 32'hFFFF0000; b = 32'hF000FFFF; alu_ctrl = 4'b0100; #15;
        if(out != 32'hF0000000 || zero != 0)
            $display("Test failed: AND");
            
    end
    
endmodule
