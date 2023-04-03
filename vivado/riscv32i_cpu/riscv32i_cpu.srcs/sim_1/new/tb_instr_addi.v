`timescale 1ns / 1ps

module tb_instr_addi();

    reg clk;
    reg rst;
    reg [4:0] ra3;
    reg [31:0] imem_out;

    wire [31:0] imem_addr;
    wire [31:0] rd3;
    
    cpu_top_verify dut (
        .clk(clk),
        .rst(rst),
        .ra3(ra3),
        .rd3(rd3),
        .imem_out(imem_out),
        .imem_addr(imem_addr)
        );
    
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    parameter num_tests = 3;
    reg [31:0] tests [0:num_tests-1][0:1] = {
        {32'h0000_0193, 32'd0}, // 0 + 0 = 0
        {32'hfff0_0193, 32'hffff_ffff}, // 0 + 0xffffffff = 0xffffffff
        {32'h0ff0_0193, 32'h0000_00ff} // 0 + 0x000000ff = 0x000000ff
    };
    
    reg [100:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: ADDI");
        
        for(integer i = 0; i < num_tests; i = i + 1) begin
            ra3 = 5'd3; imem_out = tests[i][0]; #10;
            if(~(rd3 === tests[i][1])) begin
                $display("Test failed: %d", i + 1);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
