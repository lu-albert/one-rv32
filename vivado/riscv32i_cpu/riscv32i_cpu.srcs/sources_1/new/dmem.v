`timescale 1ns / 1ps

module dmem #(parameter DATA_WIDTH = 32, MEM_ROWS = 50000, MEM_HEX_FILE="factorial_data.mem") (
    input clk,
    input [DATA_WIDTH-1:0] addr,
    input we,
    input [DATA_WIDTH-1:0] wd,
    output [DATA_WIDTH-1:0] data_out,
    input [DATA_WIDTH-1:0] addr2,
    output [DATA_WIDTH-1:0] data2
    );
    
    reg [DATA_WIDTH-1:0] mem [MEM_ROWS-1:0];
   
    integer i;
    initial begin
        for(i = 0; i < MEM_ROWS-1; i=i+1)
            mem[i] = 32'h00000000;
        $readmemh(MEM_HEX_FILE, mem);
    end
   
    
    always @ (posedge clk) begin
        if(we) begin
            mem[addr[DATA_WIDTH-1:3]] <= wd;
        end
    end
    
    assign data_out = mem[addr[DATA_WIDTH-1:3]];
    assign data2 = mem[addr2[DATA_WIDTH-1:3]];
    
endmodule
