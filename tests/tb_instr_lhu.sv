`timescale 1ns / 1ps

module tb_instr_lhu();

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
    
    parameter num_tests = 29;
    
    reg [100:0] succeeded;
    
    reg [31:0] tests [0:42] = 
    {
        32'h6f400093,
        32'h03900113,
        32'h00000193,
        32'h6f408093,
        32'h00118193,
        32'h00218463,
        32'hfe000ae3,
        32'h07400193,
        32'h00000113,
        32'h00112023,
        32'h00410113,
        32'h00310463,
        32'hfe000ae3,
        32'h00000113,
        32'h00015183,
        32'h00415203,
        32'h00815283,
        32'h00c15303,
        32'h01015383,
        32'h01415403,
        32'h01815483,
        32'h01c15503,
        32'h02015583,
        32'h02415603,
        32'h02815683,
        32'h02c15703,
        32'h03015783,
        32'h03415803,
        32'h03815883,
        32'h03c15903,
        32'h04015983,
        32'h04415a03,
        32'h04815a83,
        32'h04c15b03,
        32'h05015b83,
        32'h05415c03,
        32'h05815c83,
        32'h05c15d03,
        32'h06015d83,
        32'h06415e03,
        32'h06815e83,
        32'h06c15f03,
        32'h07015f83
    };

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: LHU");
        
        // Prepare
        
        while(imem_addr !== 32'h0000_0038) begin
            imem_out = tests[imem_addr / 4];
            $display("%h", imem_addr);
            #10;
        end

        $display("Part 2");
        
        // Begin Test
        
        $display("%h", tests[imem_addr / 4]);
        
        for(integer i = 3; i < 32; i = i + 1) begin
            ra3 = i; imem_out = tests[imem_addr / 4];
            $display("Inner: %d, %h", ra3, tests[imem_addr / 4]);
            #10;
            if(~(rd3 === 32'h0000_9348)) begin
                $display("Test failed: %d", i);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
