`timescale 1ns / 1ps

// This is a generic top-level module for the CPU and memory connections. The memory uses even-odd banking to support single-cycle unaligned accesses.
// This does use more hardware resources to be achieved.
module cpu_top #(parameter DATA_WIDTH = 32, NUM_REGISTERS = 32) (
    input clk,
    input rst,
    input [$clog2(NUM_REGISTERS)-1:0] ra3,
    input sw_bit,
    output [6:0] seg,
    output [3:0] an
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
    
    wire [DATA_WIDTH-1:0] rd3;
    
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
    
    // MEM_ROWS are based on the code and data files. Default will be 50000 to accomodate, but will be synthesized to fit only.
    memory #(.DATA_WIDTH(DATA_WIDTH), .IMEM_ROWS(50000), .DMEM_ROWS(50000), .IMEM_HEX_FILE("factorial_code.mem"), .DMEM_HEX_FILE_EVEN("factorial_data.mem"), .DMEM_HEX_FILE_ODD("factorial_data.mem")) mem (
        .clk(clk),
        .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_we(dmem_we),
        .dmem_wd(dmem_wd),
        .imem_out(imem_out),
        .dmem_out(dmem_out),
        .dmem_out_p1(dmem_out_p1),
        .dmem_addr_p1(dmem_addr_p1),
        .dmem_wd_p1(dmem_wd_p1)
        );
        
     cpu_debug cd (
        .clk(clk),
        .rd3(rd3),
        .sw_bit(sw_bit),
        .seg(seg),
        .an(an)
        );
    
endmodule
