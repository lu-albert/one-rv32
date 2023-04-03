`timescale 1ns / 1ps

module tb_cpu_regular();

    reg clk;
    reg rst;
    
    reg [31:0] dmem_addr2;
    reg [4:0] ra3;
    
    wire [31:0] rd3;
    wire [31:0] dmem_data2;
    
    reg sw_bit;
    wire [6:0] seg;
    wire [3:0] an;
    
    cpu_top dut (
        .clk(clk),
        .rst(rst),
        .ra3(ra3),
        .sw_bit(sw_bit),
        .seg(seg),
        .an(an)
        );
    
    always begin
        clk = 0; #7.75;
        clk = 1; #7.75;
    end
    
    initial begin
        $monitor("%0t, %8h, %8h", $time, dmem_addr2, dmem_data2);
        #2;
        ra3 = 10; sw_bit = 0; rst = 1; #20;
        rst = 0;
        
        dmem_addr2 = 32'h00010000; #20;
    end

endmodule
