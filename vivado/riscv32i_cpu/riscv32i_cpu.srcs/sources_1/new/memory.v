`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2023 05:53:10 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory #(parameter DATA_WIDTH = 32, IMEM_ROWS=50000, DMEM_ROWS=50000, IMEM_HEX_FILE="imem_code.mem", DMEM_HEX_FILE_EVEN="imem_code_even.mem", DMEM_HEX_FILE_ODD="imem_code_odd.mem") (
    input clk,
    input [DATA_WIDTH-1:0] imem_addr,
    input [DATA_WIDTH-1:0] dmem_addr,
    input dmem_we,
    input [DATA_WIDTH-1:0] dmem_wd,
    output [DATA_WIDTH-1:0] imem_out,
    output [DATA_WIDTH-1:0] dmem_out,
    input [DATA_WIDTH-1:0] dmem_addr2,
    output [DATA_WIDTH-1:0] dmem_data2,
    output [DATA_WIDTH-1:0] dmem_out_p1,
    input [DATA_WIDTH-1:0] dmem_addr_p1,
    input [DATA_WIDTH-1:0] dmem_wd_p1
    );
    
    imem #(.DATA_WIDTH(DATA_WIDTH), .MEM_ROWS(IMEM_ROWS), .MEM_HEX_FILE(IMEM_HEX_FILE)) instr_mem (
        .clk(clk),
        .addr(imem_addr),
        .data_out(imem_out)
        );
        
    wire [DATA_WIDTH-1:0] dmem_addr_even;
    wire [DATA_WIDTH-1:0] dmem_addr_odd;
    
    wire [DATA_WIDTH-1:0] dmem_out_even;
    wire [DATA_WIDTH-1:0] dmem_out_odd;
    
    wire dmem_we_even;
    wire dmem_we_odd;
    
    wire [DATA_WIDTH-1:0] dmem_wd_even;
    wire [DATA_WIDTH-1:0] dmem_wd_odd;
    
    assign dmem_addr_even = (dmem_addr[2] == 0) ? dmem_addr : dmem_addr_p1;
    assign dmem_addr_odd = (dmem_addr[2] == 1) ? dmem_addr : dmem_addr_p1;
    
    assign dmem_out = (dmem_addr[2] == 0) ? dmem_out_even : dmem_out_odd;
    assign dmem_out_p1 = (dmem_addr[2] == 1) ? dmem_out_even : dmem_out_odd;
    
    assign dmem_we_even = (dmem_addr[2] == 0) ? dmem_we : 0;
    assign dmem_we_odd = (dmem_addr[2] == 1) ? dmem_we : 0;
    
    assign dmem_wd_even = (dmem_addr[2] == 0) ? dmem_wd : dmem_wd_p1;
    assign dmem_wd_odd = (dmem_addr[2] == 1) ? dmem_wd : dmem_wd_p1;
    
    dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_ROWS(DMEM_ROWS), .MEM_HEX_FILE(DMEM_HEX_FILE_EVEN)) dmem_unit_even (
        .clk(clk),
        .addr(dmem_addr_even),
        .we(dmem_we_even),
        .wd(dmem_wd_even),
        .data_out(dmem_out_even),
        .addr2(dmem_addr2),
        .data2(dmem_data2)
        );
        

     dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_ROWS(DMEM_ROWS), .MEM_HEX_FILE(DMEM_HEX_FILE_ODD)) dmem_unit_odd (
        .clk(clk),
        .addr(dmem_addr_odd),
        .we(dmem_we_odd),
        .wd(dmem_wd_odd),
        .data_out(dmem_out_odd)
        );
        
endmodule
