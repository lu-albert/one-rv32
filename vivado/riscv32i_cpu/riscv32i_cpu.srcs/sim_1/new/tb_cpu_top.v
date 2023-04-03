`timescale 1ns / 1ps

module tb_cpu_top();

    reg clk;
    reg rst;
    
    reg [31:0] dmem_addr2;
    reg [4:0] ra3;
    
    wire [31:0] rd3;
    wire [31:0] dmem_data2;
    
    cpu_top_rvtests dut (
        .clk(clk),
        .rst(rst),
        .dmem_addr2(dmem_addr2),
        .ra3(ra3),
        .rd3(rd3),
        .dmem_data2(dmem_data2)
        );
    
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        // Monitor the dmem_out2 value that is where the test results are outputted to.
        $monitor("%0t, %8h, %8h", $time, dmem_addr2, dmem_data2);
        #2;
        ra3 = 10; rst = 1; #10;
        rst = 0;
        
        dmem_addr2 = 32'h00010000; #15;
    end

endmodule
