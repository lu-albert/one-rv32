`timescale 1ns / 1ps


module regfile #(parameter NUM_REGISTERS = 32, DATA_WIDTH = 32) (
    input clk,
    input [$clog2(NUM_REGISTERS)-1:0] ra1,
    input [$clog2(NUM_REGISTERS)-1:0] ra2,
    input [$clog2(NUM_REGISTERS)-1:0] ra3,
    input we,
    input [$clog2(NUM_REGISTERS)-1:0] wa,
    input [DATA_WIDTH-1:0] wd,
    output [DATA_WIDTH-1:0] rd1,
    output [DATA_WIDTH-1:0] rd2,
    output [DATA_WIDTH-1:0] rd3
    );
    
    reg [DATA_WIDTH-1:0] registers [0:NUM_REGISTERS-1];

    integer i;
    initial begin
        for (i = 0; i < NUM_REGISTERS; i=i+1)
            registers[i] = 'b0;
    end
    
    always @ (posedge clk) begin
        if(we)
            registers[wa] <= wd;
    end
    
    assign rd1 = (ra1 == 0) ? 0 : registers[ra1];
    assign rd2 = (ra2 == 0) ? 0 : registers[ra2];
    assign rd3 = (ra3 == 0) ? 0 : registers[ra3];
     
endmodule
