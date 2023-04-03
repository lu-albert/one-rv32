`timescale 1ns / 1ps

module tb_register();

    reg clk;
    reg rst;
    reg [31:0] data_in;
    
    wire [31:0] data_out;
    
    register #(.DATA_WIDTH(32)) r (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
        );
    
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        rst = 0; #2;
        data_in = 32'hFFFFFFFF; #10;
        if(data_out != data_in) begin
            $display("Test failed for %x!", data_in);
        end
        
        data_in = 32'hFFFF0000; #10;
        if(data_out != data_in) begin
            $display("Test failed for %x!", data_in);
        end
        
        rst = 1; #15;
        if(data_out != 0) begin
            $display("Test failed for %x!", 0);
        end
        
        rst = 0; #15;
    end
    
endmodule
