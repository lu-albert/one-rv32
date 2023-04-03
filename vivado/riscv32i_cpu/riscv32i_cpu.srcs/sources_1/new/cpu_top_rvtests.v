`timescale 1ns / 1ps

// This module is intended to be used as a top-level module to test the riscv-tests GitHub build.
module cpu_top_rvtests #(parameter DATA_WIDTH = 32, NUM_REGISTERS = 32) (
    input clk,
    input rst,
    input [31:0] dmem_addr2,
    input [4:0] ra3,
    output [31:0] rd3,
    output [31:0] dmem_data2
    );
    
    wire [DATA_WIDTH-1:0] imem_out;
    wire [DATA_WIDTH-1:0] dmem_out;
    
    wire [DATA_WIDTH-1:0] imem_addr;
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
    
    memory #(.DATA_WIDTH(DATA_WIDTH), .IMEM_ROWS(50000), .DMEM_ROWS(50000), .IMEM_HEX_FILE("rv32i_tests_code.mem"), .DMEM_HEX_FILE_EVEN("rv32i_tests_data_even.mem"), .DMEM_HEX_FILE_ODD("rv32i_tests_data_odd.mem")) mem (
        .clk(clk),
        .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_we(dmem_we),
        .dmem_wd(dmem_wd),
        .imem_out(imem_out),
        .dmem_out(dmem_out),
        .dmem_addr2(dmem_addr2),
        .dmem_data2(dmem_data2),
        .dmem_out_p1(dmem_out_p1),
        .dmem_addr_p1(dmem_addr_p1),
        .dmem_wd_p1(dmem_wd_p1)
        );
    
endmodule
