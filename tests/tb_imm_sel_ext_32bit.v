`timescale 1ns / 1ps

module tb_imm_sel_ext_32bit();

    reg [31:0] instr;
    reg [2:0] instr_type;
    
    wire [31:0] imm_ext;
    
    imm_sel_ext_32bit dut (
        .instr(instr),
        .instr_type(instr_type),
        .imm_ext(imm_ext)
        );
     
     parameter I_TYPE = 3'b000, S_TYPE = 3'b001, B_TYPE = 3'b010, U_TYPE = 3'b011, J_TYPE = 3'b100, R_TYPE = 3'b101;
     
     initial begin
        #2;
        
        // I_TYPE Immediate
        instr = 32'h5dc00093; instr_type = I_TYPE; #15;
        if(imm_ext != 32'h5dc)
            $display("Test failed: I_TYPE immediate select");
        
        // S_TYPE Immediate
        instr = 32'h001127a3; instr_type = S_TYPE; #15;
        if(imm_ext != 32'hF)
            $display("Test failed: S_TYPE immediate select");
        
        // B_TYPE Immediate
        instr = 32'hfe208ee3; instr_type = B_TYPE; #15;
        if(imm_ext != 32'hFFFFFFFC)
            $display("Test failed: B_TYPE immediate select");
            
        // U_TYPE Immediate
        instr = 32'h001000b7; instr_type = U_TYPE; #15;
        if(imm_ext != 32'h00100000)
            $display("Test failed: U_TYPE immediate select");
            
        // U_TYPE Immediate
        instr = 32'h000010ef; instr_type = J_TYPE; #15;
        if(imm_ext != 32'h00001000)
            $display("Test failed: J_TYPE immediate select");
     end

endmodule
