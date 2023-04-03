`timescale 1ns / 1ps

module tb_instr_sh();

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
    
    reg [31:0] tests [0:37] = 
    {
        32'h00100093,
        32'h401000b3,
        32'h07400193,
        32'h00000113,
        32'h00111023,
        32'h00410113,
        32'h00310463,
        32'hfe000ae3,
        32'h00000113,
        32'h00012183,
        32'h00412203,
        32'h00812283,
        32'h00c12303,
        32'h01012383,
        32'h01412403,
        32'h01812483,
        32'h01c12503,
        32'h02012583,
        32'h02412603,
        32'h02812683,
        32'h02c12703,
        32'h03012783,
        32'h03412803,
        32'h03812883,
        32'h03c12903,
        32'h04012983,
        32'h04412a03,
        32'h04812a83,
        32'h04c12b03,
        32'h05012b83,
        32'h05412c03,
        32'h05812c83,
        32'h05c12d03,
        32'h06012d83,
        32'h06412e03,
        32'h06812e83,
        32'h06c12f03,
        32'h07012f83
    };

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: SH");
        
        // Prepare
        
        while(imem_addr !== 32'h0000_0024) begin
            imem_out = tests[imem_addr / 4];
            $display(imem_addr);
            #10;
        end

        $display("Part 2");
        
        // Begin Test
        
        $display("%h", tests[imem_addr / 4]);
        
        for(integer i = 3; i < 32; i = i + 1) begin
            ra3 = i; imem_out = tests[imem_addr / 4];
            $display("Inner: %d, %h", ra3, tests[imem_addr / 4]);
            #10;
            if(~(rd3 === 32'h0000_ffff)) begin
                $display("Test failed: %d", i);
            end else begin
                succeeded = succeeded + 1;
            end
        end
        
        if(succeeded === num_tests)
            $display("All tests passed!");
        
    end

endmodule
