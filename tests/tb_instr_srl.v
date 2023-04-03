`timescale 1ns / 1ps

module tb_instr_srl();

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
    
    parameter num_tests = 4;
    reg [31:0] tests [0:num_tests-1][0:3] = {
        {32'h0010_0093, 32'h0100_0113, 32'h0011_51b3, 32'h0000_0008},
        {32'h0200_0093, 32'h0100_0113, 32'h0011_51b3, 32'h0000_0010},
        {32'h01c0_0093, 32'h0100_0113, 32'h0011_51b3, 32'h0000_0000},
        {32'h0020_0093, 32'hfec0_0113, 32'h0011_51b3, 32'h3fff_fffb}
    };
    
    reg [100:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: SRL");
        
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
