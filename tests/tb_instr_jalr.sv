`timescale 1ns / 1ps

module tb_instr_jalr();

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
    
    parameter num_tests = 1;
    reg [1000:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: JALR");
        
        imem_out = 32'h7d00_0093; #10;
        imem_out = 32'h7d00_8093; #10;
        imem_out = 32'h7d00_8093; #10;
        imem_out = 32'h7d00_8093; #10;
        imem_out = 32'h7d00_8093; #10;
        imem_out = 32'h7d00_8093; #10;
        
        imem_out = 32'h12c0_8093; #10;
        ra3 = 5'd2; imem_out = 32'h0200_8167; #10;

        if(~(imem_addr === 32'h0000_302c && rd3 === 32'h0000_0020)) begin
            $display("Test failed: JALR");
        end else begin
            succeeded = succeeded + 1;
        end
        
        if(succeeded === num_tests) begin
            $display("All tests passed!");
        end
        
        $finish();
    end

endmodule
