`timescale 1ns / 1ps

module imm_sel_ext_32bit(
    input [31:0] instr,
    input [2:0] instr_type,
    output reg [31:0] imm_ext
    );
    
    parameter I_TYPE = 3'b000, S_TYPE = 3'b001, B_TYPE = 3'b010, U_TYPE = 3'b011, J_TYPE = 3'b100, R_TYPE = 3'b101;
    
    always @ (*) begin
        case (instr_type)
            I_TYPE: imm_ext = {{20{instr[31]}}, instr[31:20]};
            S_TYPE: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            B_TYPE: imm_ext = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            U_TYPE: imm_ext = {instr[31:12], {12{1'b0}}};
            J_TYPE: imm_ext = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        endcase
    end
    
endmodule
