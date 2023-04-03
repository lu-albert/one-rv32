`timescale 1ns / 1ps

module tb_instr_add();

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
        {32'h00100093, 32'h00208113, 32'h002081b3, 32'd4}, // 1 + 3 = 4
        {32'hfff00093, 32'h00100113, 32'h002081b3, 32'd0}, // 0xffffffff + 1 = 0
        {32'h00000093, 32'hfff00113, 32'h002081b3, 32'hffffffff} // 0x0 + (-1) = 0xffffffff
    };
    reg [1000:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: ADD");
        
        for(integer i = 0; i < num_tests; i = i + 1) begin
            imem_out = tests[i][0]; #10;
            imem_out = tests[i][1]; #10;
            ra3 = 5'd3; imem_out = tests[i][2]; #10;
            if(~(rd3 === tests[i][3])) begin
                $display("Test failed: ADD_%d", i + 1);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests) begin
            $display("All tests passed!");
        end
        
        $finish();
        
    end

endmodule
