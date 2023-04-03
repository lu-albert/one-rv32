`timescale 1ns / 1ps

module tb_instr_lh();

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
        32'h00011183,
        32'h00411203,
        32'h00811283,
        32'h00c11303,
        32'h01011383,
        32'h01411403,
        32'h01811483,
        32'h01c11503,
        32'h02011583,
        32'h02411603,
        32'h02811683,
        32'h02c11703,
        32'h03011783,
        32'h03411803,
        32'h03811883,
        32'h03c11903,
        32'h04011983,
        32'h04411a03,
        32'h04811a83,
        32'h04c11b03,
        32'h05011b83,
        32'h05411c03,
        32'h05811c83,
        32'h05c11d03,
        32'h06011d83,
        32'h06411e03,
        32'h06811e83,
        32'h06c11f03,
        32'h07011f83
    };

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: LH");
        
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
            if(~(rd3 === 32'hffff_9348)) begin
                $display("Test failed: %d", i);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
