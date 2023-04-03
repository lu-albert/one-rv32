`timescale 1ns / 1ps

module tb_instr_bgeu();

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
    reg [1000:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: BGEU");
        
        imem_out = 32'hffb0_0093; #10;
        imem_out = 32'h00a0_0113; #10;
        imem_out = 32'hfe20_fce3; #10;
        if(~(imem_addr === 32'd0)) begin
            $display("Test failed: BGEU taken (GT)");
        end else begin
            succeeded = succeeded + 1;
        end
        
        #15;
        rst = 1; #10;
        rst = 0;
        
        imem_out = 32'hffb0_0093; #10;
        imem_out = 32'hffb0_0113; #10;
        imem_out = 32'hfe20_fce3; #10;
        if(~(imem_addr === 32'd0)) begin
            $display("Test failed: BGEU taken (equal)");
        end else begin
            succeeded = succeeded + 1;
        end
        
        #15;
        rst = 1; #10;
        rst = 0;
        
        imem_out = 32'h00a0_0093; #10;
        imem_out = 32'hffb0_0113; #10;
        imem_out = 32'hfe20_fce3; #10;
        if(~(imem_addr === 32'h0000_000c)) begin
            $display("Test failed: BGEU not taken");
        end else begin
            succeeded = succeeded + 1;
        end
        
        if(succeeded === num_tests) begin
            $display("All tests passed!");
        end
        
        $finish();
    end

endmodule
