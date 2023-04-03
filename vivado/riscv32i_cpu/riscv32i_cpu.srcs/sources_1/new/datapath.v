`timescale 1ns / 1ps

module datapath #(parameter DATA_WIDTH = 32, NUM_REGISTERS = 32) (
    input clk,
    input rst,
    input we_mem_fc,
    input we_reg_fc,
    input [2:0] instr_type_fc,
    input [2:0] branch_type_fc,
    input [3:0] alu_ctrl_fc,
    input alu_src_fc,
    input mem2reg_fc,
    input [2:0] size_type_fc,
    input jump_fc,
    input jr_fc,
    input [1:0] upper_imm_fc,
    input [DATA_WIDTH-1:0] imem_out,
    input [DATA_WIDTH-1:0] dmem_out,
    input [$clog2(NUM_REGISTERS)-1:0] ra3,
    output [6:0] opcode_tc,
    output [2:0] funct3_tc,
    output [6:0] funct7_tc,
    output [DATA_WIDTH-1:0] imem_addr,
    output [DATA_WIDTH-1:0] dmem_addr,
    output dmem_we,
    output [DATA_WIDTH-1:0] dmem_wd,
    output [DATA_WIDTH-1:0] rd3,
    input [DATA_WIDTH-1:0] dmem_out_p1,
    output [DATA_WIDTH-1:0] dmem_addr_p1,
    output [DATA_WIDTH-1:0] dmem_wd_p1
    );
    
    // IF Inputs
    wire b_sel;
    
    // IF Outputs
    wire [DATA_WIDTH-1:0] instr;
    
    // ID Inputs
    wire [DATA_WIDTH-1:0] wd_reg_ui;
    
    // ID Outputs
    wire [DATA_WIDTH-1:0] rd1;
    wire [DATA_WIDTH-1:0] rd2;
     
    wire [DATA_WIDTH-1:0] imm_ext;
     
    wire [DATA_WIDTH-1:0] alu_in_b;
     
    // EX Outputs
    wire [DATA_WIDTH-1:0] alu_out;
    
    // MEM Outputs
    wire [DATA_WIDTH-1:0] dmem_ls_out;
    wire [DATA_WIDTH-1:0] wd_reg;
    
    
    
    // --- START Instruction Fetch --- //
    
    // Internals
    wire [DATA_WIDTH-1:0] pc_current;
    wire [DATA_WIDTH-1:0] pc_next;
    wire [DATA_WIDTH-1:0] pc_plus4;
    wire [DATA_WIDTH-1:0] ta;
    wire [DATA_WIDTH-1:0] jta_p4;
    wire [DATA_WIDTH-1:0] jta;
    
    register #(.DATA_WIDTH(DATA_WIDTH)) pc (
        .clk(clk),
        .rst(rst),
        .data_in(pc_next),
        .data_out(pc_current)
        );
        
    adder #(.DATA_WIDTH(DATA_WIDTH)) pcplus4 (
        .a(pc_current),
        .b(32'd4),
        .out(pc_plus4)
        );
    
    adder #(.DATA_WIDTH(DATA_WIDTH)) ta_calc (
        .a(pc_current),
        .b(imm_ext),
        .out(ta)
        );
        
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) jr_sel (
        .a(ta),
        .b(wd_reg),
        .sel(jr_fc),
        .out(jta)
        );
        
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) jta_p4_sel (
        .a(pc_plus4),
        .b(jta),
        .sel(jump_fc),
        .out(jta_p4)
        );
        
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) branch_sel (
        .a(jta_p4),
        .b(ta),
        .sel(b_sel),
        .out(pc_next)
        );
    
    assign imem_addr = pc_current;
    assign instr = imem_out;
    
    // --- END Instruction Fetch --- //
     


     // --- START Instruction Decode --- //
     
     // Decode instruction to control unit
    assign opcode_tc = instr[6:0];
    assign funct3_tc = instr[14:12];
    assign funct7_tc = instr[31:25];
    
    // Internal signals
    wire [DATA_WIDTH-1:0] wd_reg_jal;

    regfile #(.NUM_REGISTERS(NUM_REGISTERS), .DATA_WIDTH(DATA_WIDTH)) rf (
        .clk(clk),
        .ra1(instr[19:15]),
        .ra2(instr[24:20]),
        .ra3(ra3),
        .we(we_reg_fc),
        .wa(instr[11:7]),
        .wd(wd_reg_jal),
        .rd1(rd1),
        .rd2(rd2),
        .rd3(rd3)
        );
        
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) wd_reg_jal_sel (
        .a(wd_reg_ui),
        .b(pc_plus4),
        .sel(jump_fc),
        .out(wd_reg_jal)
        );
       
    imm_sel_ext_32bit imm_sel (
        .instr(instr),
        .instr_type(instr_type_fc),
        .imm_ext(imm_ext)
        );
       
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) alu_src_mux (
        .a(rd2),
        .b(imm_ext),
        .sel(alu_src_fc),
        .out(alu_in_b)
        );
        
    // --- END Instruction Decode --- //
        
        
       
    // --- START EX --- //
       
    // Internals
    wire alu_zero;
    wire alu_lt_signed;
    wire alu_lt_unsigned;
    
    wire [DATA_WIDTH-1:0] lui_val;
    wire [DATA_WIDTH-1:0] auipc_val;
       
    alu #(.DATA_WIDTH(DATA_WIDTH)) alu_unit (
        .a(rd1),
        .b(alu_in_b),
        .alu_ctrl(alu_ctrl_fc),
        .out(alu_out),
        .zero(alu_zero),
        .lt_signed(alu_lt_signed),
        .lt_unsigned(alu_lt_unsigned)
        );
    
    branch_unit bu (
        .branch_type(branch_type_fc),
        .zero(alu_zero),
        .lt_signed(alu_lt_signed),
        .lt_unsigned(alu_lt_unsigned),
        .b_sel(b_sel)
        );
    
    assign lui_val = imm_ext;
    assign auipc_val = pc_current + imm_ext;
    
    mux3 #(.DATA_WIDTH(DATA_WIDTH)) wd_upper_imm_sel (
        .a(wd_reg),
        .b(lui_val),
        .c(auipc_val),
        .sel(upper_imm_fc),
        .out(wd_reg_ui)
        );
    
       
    // --- END EX --- //
       
       
    // --- START MEM --- //
    
    assign dmem_addr = alu_out;
    assign dmem_we = we_mem_fc;
    
    assign dmem_addr_p1 = dmem_addr + (DATA_WIDTH / 8); // Get the next address start for memory alignment in 1 clock cycle.
    
    store_select_unit #(.DATA_WIDTH(DATA_WIDTH)) su (
        .in_data(rd2),
        .mem_out(dmem_out),
        .mem_out_p1(dmem_out_p1),
        .addr_lb(alu_out[1:0]),
        .store_select(size_type_fc),
        .out_data(dmem_wd),
        .out_data_p1(dmem_wd_p1)
        );

    load_select_unit #(.DATA_WIDTH(DATA_WIDTH)) lu (
        .in_data(dmem_out),
        .in_data_p1(dmem_out_p1),
        .mem_addr_lb(alu_out[1:0]), // Lower 2 bits only for selecting the alignment
        .load_select(size_type_fc),
        .out_data(dmem_ls_out)
        );

    // --- END MEM --- //
    
    
    
    // --- START WB --- //
       
    mux2 #(.DATA_WIDTH(DATA_WIDTH)) mem2reg_mux (
        .a(alu_out),
        .b(dmem_ls_out),
        .sel(mem2reg_fc),
        .out(wd_reg)
        );
    
    // --- END WB --- //
       
endmodule