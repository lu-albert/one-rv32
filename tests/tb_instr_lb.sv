`timescale 1ns / 1ps

module tb_instr_lb();

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
        32'h00010183,
        32'h00410203,
        32'h00810283,
        32'h00c10303,
        32'h01010383,
        32'h01410403,
        32'h01810483,
        32'h01c10503,
        32'h02010583,
        32'h02410603,
        32'h02810683,
        32'h02c10703,
        32'h03010783,
        32'h03410803,
        32'h03810883,
        32'h03c10903,
        32'h04010983,
        32'h04410a03,
        32'h04810a83,
        32'h04c10b03,
        32'h05010b83,
        32'h05410c03,
        32'h05810c83,
        32'h05c10d03,
        32'h06010d83,
        32'h06410e03,
        32'h06810e83,
        32'h06c10f03,
        32'h07010f83
    };

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: LB");
        
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
            if(~(rd3 === 32'hffff_fff4)) begin
                $display("Test failed: %d", i);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
