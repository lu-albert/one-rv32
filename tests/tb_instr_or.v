`timescale 1ns / 1ps

module tb_instr_or();

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
    reg [31:0] tests [0:num_tests-1][0:3] = {
        {32'h0000_0093, 32'h0000_0113, 32'h0020_e1b3, 32'd0}, // 0 OR 0 = 0
        {32'hfff0_0093, 32'h0000_0113, 32'h0020_e1b3, 32'hffff_ffff}, // 0xffffffff OR 0x0 = 0xffffffff
        {32'hfff0_0093, 32'h0ff0_0113, 32'h0020_e1b3, 32'hffff_ffff} // 0xffffffff OR 0x000000ff = 0xffffffff
    };
    
    reg [100:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: OR");
        
        for(integer i = 0; i < num_tests; i = i + 1) begin
            imem_out = tests[i][0]; #10;
            imem_out = tests[i][1]; #10;
            ra3 = 5'd3; imem_out = tests[i][2]; #10;
            if(~(rd3 === tests[i][3])) begin
                $display("Test failed: %d", i + 1);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
