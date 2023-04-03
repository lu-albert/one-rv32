`timescale 1ns / 1ps

module cpu #(parameter DATA_WIDTH = 32, NUM_REGISTERS = 32) (
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] imem_out,
    input [DATA_WIDTH-1:0] dmem_out,
    input [$clog2(NUM_REGISTERS)-1:0] ra3,
    output [DATA_WIDTH-1:0] imem_addr,
    output [DATA_WIDTH-1:0] dmem_addr,
    output dmem_we,
    output [DATA_WIDTH-1:0] dmem_wd,
    output [DATA_WIDTH-1:0] rd3,
    input [DATA_WIDTH-1:0] dmem_out_p1,
    output [DATA_WIDTH-1:0] dmem_addr_p1,
    output [DATA_WIDTH-1:0] dmem_wd_p1
    );
    
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    
    wire we_mem;
    wire we_reg;
    wire [2:0] instr_type;
    wire [2:0] branch_type;
    wire [3:0] alu_ctrl;
    wire alu_src;
    wire mem2reg;
    wire [2:0] size_type;
    wire jump;
    wire jr;
    wire [1:0] upper_imm;
    
    control_unit cu (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .we_mem(we_mem),
        .we_reg(we_reg),
        .instr_type(instr_type),
        .branch_type(branch_type),
        .alu_ctrl(alu_ctrl),
        .alu_src(alu_src),
        .mem2reg(mem2reg),
        .size_type(size_type),
        .jump(jump),
        .jr(jr),
        .upper_imm(upper_imm)
        );
     
    datapath #(.DATA_WIDTH(32)) dp (
        .clk(clk),
        .rst(rst),
        .we_mem_fc(we_mem),
        .we_reg_fc(we_reg),
        .instr_type_fc(instr_type),
        .branch_type_fc(branch_type),
        .alu_ctrl_fc(alu_ctrl),
        .alu_src_fc(alu_src),
        .mem2reg_fc(mem2reg),
        .size_type_fc(size_type),
        .jump_fc(jump),
        .jr_fc(jr),
        .upper_imm_fc(upper_imm),
        .imem_out(imem_out),
        .dmem_out(dmem_out),
        .opcode_tc(opcode),
        .funct3_tc(funct3),
        .funct7_tc(funct7),
        .imem_addr(imem_addr),
        .dmem_addr(dmem_addr),
        .dmem_we(dmem_we),
        .dmem_wd(dmem_wd),
        .ra3(ra3), // Debug signal
        .rd3(rd3), // Debug signal
        .dmem_out_p1(dmem_out_p1),
        .dmem_addr_p1(dmem_addr_p1),
        .dmem_wd_p1(dmem_wd_p1)
        );

endmodule
