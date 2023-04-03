`timescale 1ns / 1ps

// This unit handles the different branch signals possible.
module branch_unit(
    input [2:0] branch_type,
    input zero,
    input lt_signed,
    input lt_unsigned,
    output reg b_sel
    );
    
    parameter BEQ = 3'b000, BNE = 3'b001, BLT = 3'b100, BGE = 3'b101, BLTU = 3'b110, BGEU = 3'b111;
    
    always @ (*) begin
        case (branch_type)
            BEQ: b_sel = zero;
            BNE: b_sel = ~zero;
            BLT: b_sel = lt_signed;
            BGE: b_sel = ~lt_signed;
            BLTU: b_sel = lt_unsigned;
            BGEU: b_sel = ~lt_unsigned;
            default: b_sel = 1'b0;
        endcase
    end
    
endmodule
