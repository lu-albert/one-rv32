`timescale 1ns / 1ps

// This is an older top-level module intended for manual verification by directly providing instruction memory values to the CPU to test.
// The "cpu_top_rvtests" module is a more comprehensive test suite and should be used instead.
module cpu_top_verify #(parameter DATA_WIDTH = 32, NUM_REGISTERS = 32) (
    input clk,
    input rst,
    input [$clog2(NUM_REGISTERS)-1:0] ra3,
    output [DATA_WIDTH-1:0] rd3,
    input [DATA_WIDTH-1:0] imem_out,
    output [DATA_WIDTH-1:0] imem_addr
    );
    
    wire [DATA_WIDTH-1:0] dmem_out;

    wire [DATA_WIDTH-1:0] dmem_addr;
    wire dmem_we;
    wire [DATA_WIDTH-1:0] dmem_wd;
    
    wire [DATA_WIDTH-1:0] dmem_out_p1;
    
    wire [DATA_WIDTH-1:0] dmem_addr_p1;
    wire [DATA_WIDTH-1:0] dmem_wd_p1;
    
    cpu #(.DATA_WIDTH(DATA_WIDTH), .NUM_REGISTERS(NUM_REGISTERS)) c (
        .clk(clk),
        .rst(rst),
        .imem_out(imem_out),
        .dmem_out(dmem_out),
        .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_we(dmem_we),
        .dmem_wd(dmem_wd),
        .ra3(ra3),
        .rd3(rd3),
        .dmem_out_p1(dmem_out_p1),
        .dmem_addr_p1(dmem_addr_p1),
        .dmem_wd_p1(dmem_wd_p1)
        );
    
    memory #(.DATA_WIDTH(DATA_WIDTH)) mem (
        .clk(clk),
    //    .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_we(dmem_we),
        .dmem_wd(dmem_wd),
    //    .imem_out(imem_out),
        .dmem_out(dmem_out),
        .dmem_addr2(dmem_addr2),
        .dmem_data2(dmem_data2),
        .dmem_out_p1(dmem_out_p1),
        .dmem_addr_p1(dmem_addr_p1),
        .dmem_wd_p1(dmem_wd_p1)
        );
    
endmodule
