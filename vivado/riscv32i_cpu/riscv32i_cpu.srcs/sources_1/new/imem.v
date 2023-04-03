`timescale 1ns / 1ps

module imem #(parameter DATA_WIDTH=32, MEM_ROWS=50000, MEM_HEX_FILE="imem_program1.mem") (
    input clk,
    input [DATA_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data_out
    );
    
    reg [DATA_WIDTH-1:0] mem [MEM_ROWS-1:0];
    
    initial begin
        $readmemh(MEM_HEX_FILE, mem);
    end
  
    assign data_out = mem[addr[DATA_WIDTH-1:2]];
    
endmodule
