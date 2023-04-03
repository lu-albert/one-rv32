`timescale 1ns / 1ps

module tb_instr_lbu();

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
    
    reg [31:0] tests [0:36] = 
    {
        32'h6f400093,
        32'h07400193,
        32'h00000113,
        32'h00112023,
        32'h00410113,
        32'h00310463,
        32'hfe000ae3,
        32'h00000113,
        32'h00014183,
        32'h00414203,
        32'h00814283,
        32'h00c14303,
        32'h01014383,
        32'h01414403,
        32'h01814483,
        32'h01c14503,
        32'h02014583,
        32'h02414603,
        32'h02814683,
        32'h02c14703,
        32'h03014783,
        32'h03414803,
        32'h03814883,
        32'h03c14903,
        32'h04014983,
        32'h04414a03,
        32'h04814a83,
        32'h04c14b03,
        32'h05014b83,
        32'h05414c03,
        32'h05814c83,
        32'h05c14d03,
        32'h06014d83,
        32'h06414e03,
        32'h06814e83,
        32'h06c14f03,
        32'h07014f83
    };

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: LBU");
        
        // Prepare
        
        while(imem_addr !== 32'h0000_0020) begin
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
            if(~(rd3 === 32'h0000_00f4)) begin
                $display("Test failed: %d", i);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
