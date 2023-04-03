`timescale 1ns / 1ps

module tb_regfile();

    reg clk;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg we;
    reg [4:0] wa;
    reg [31:0] wd;
    
    wire [31:0] rd1;
    wire [31:0] rd2;
    
    regfile #(.NUM_REGISTERS(32), .DATA_WIDTH(32)) dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .we(we),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
        );
        
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    initial begin
        #2;
        
        // Read 0th register
        ra1 = 5'd0; ra2 = 5'd0; we = 1'b0; #15;
        if(rd1 !== 0)
            $display("Test failed: Zero Register not zero");
            
        // Read registers when not initialized yet
        ra1 = 5'd1; ra2 = 5'd1; we = 1'b0; #15;
        if(~(rd1 == 0 && rd2 == 0))
            $display("Test failed: Beginning registers, not written yet");
            
        // Write and read register 1
        wa = 5'd1; wd = 32'hFFFF0000; we = 1'b1; #15;
        ra1 = 5'd1; ra2 = 5'd1; #15;
        if(~(rd1 == 32'hFFFF0000 && rd2 == 32'hFFFF0000))
            $display("Test failed: Register 1 value");
            
        // Write and read register 0 (should always still be 0, even when writing to it)
        wa = 5'd0; wd = 32'hFFFF0000; we = 1'b1; #15;
        ra1 = 5'd0; ra2 = 5'd0; #15;
        if(~(rd1 == 0 && rd2 == 0))
            $display("Test failed: Register 0 write value");
            
        // Write and read register 2 when WE is not set
        wa = 5'd2; wd = 32'hFFFF0001; we = 1'b0; #15;
        ra1 = 5'd2; ra2 = 5'd2; #15;
        if(~(rd1 == 0 && rd2 == 0))
            $display("Test failed: Register 2 write value, WE not set");
            
    end

endmodule
