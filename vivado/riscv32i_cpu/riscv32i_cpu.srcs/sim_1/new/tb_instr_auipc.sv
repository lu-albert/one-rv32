`timescale 1ns / 1ps

module tb_instr_auipc();

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
    
    parameter num_tests = 2;
    reg [1000:0] succeeded;

    initial begin
        #2;
        rst = 1; #5;
        rst = 0;
        succeeded = 0;
        
        $display("Test Start: AUIPC");
        
        ra3 = 5'd1; imem_out = 32'h003e_8097; #10;
        
        if(~(rd3 === 32'h003e_8000)) begin
            $display("Test failed: AUIPC (1 Positive)");
        end else begin
            succeeded = succeeded + 1;
        end
        
        ra3 = 5'd2; imem_out = 32'hffc1_8117; #10;
        
        if(~(rd3 === 32'hffc1_8004)) begin
            $display("Test failed: AUIPC (2 Negative)");
        end else begin
            succeeded = succeeded + 1;
        end
        
        if(succeeded === num_tests) begin
            $display("All tests passed!");
        end
        
        $finish();
    end

endmodule
