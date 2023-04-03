`timescale 1ns / 1ps

module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg we_mem,
    output reg we_reg,
    output reg [2:0] instr_type,
    output reg [2:0] branch_type,
    output reg [3:0] alu_ctrl,
    output reg alu_src,
    output reg mem2reg,
    output reg [2:0] size_type,
    output reg jump,
    output reg jr,
    output reg [1:0] upper_imm
    );
    
    parameter I_TYPE = 3'b000, S_TYPE = 3'b001, B_TYPE = 3'b010, U_TYPE = 3'b011, J_TYPE = 3'b100, R_TYPE = 3'b101;
    
    parameter ALU_ADD = 4'b0000, ALU_SUB = 4'b0001, ALU_XOR = 4'b0010, ALU_OR = 4'b0011, ALU_AND = 4'b0100, 
                ALU_SLL = 4'b0101, ALU_SRL = 4'b0110, ALU_SRA = 4'b0111, ALU_SLT = 4'b1000, ALU_SLTU = 4'b1001;
                
    parameter BYTE = 3'b000, HALF_WORD = 3'b001, WORD = 3'b010, BYTE_UNSIGNED = 3'b011, HALF_WORD_UNSIGNED = 3'b100;
    
    always @ (*) begin
        case (opcode)
            // Arithmetic/Logic Register-to-Register Operations
            7'b011_0011: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = R_TYPE; // For the imm_select later. Avoid R-type.
                branch_type = 3'b010;
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_ADD;
                            7'b010_0000: alu_ctrl = ALU_SUB;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b001: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SLL;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b010: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SLT;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b011: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SLTU;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b100: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_XOR;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b101: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SRL;
                            7'b010_0000: alu_ctrl = ALU_SRA;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b110: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_OR;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b111: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_AND;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    default: alu_ctrl = 4'bxxxx;
                endcase
                alu_src = 1'b0;
                mem2reg = 1'b0;
                size_type = 3'bxxx;
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // Arithmetic/Logic Immediate Operations
            7'b001_0011: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = I_TYPE;
                branch_type = 3'b010;
                case (funct3)
                    3'b000: alu_ctrl = ALU_ADD;
                    3'b001: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SLL;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b010: alu_ctrl = ALU_SLT;
                    3'b011: alu_ctrl = ALU_SLTU;
                    3'b100: alu_ctrl = ALU_XOR;
                    3'b101: begin
                        case (funct7)
                            7'b000_0000: alu_ctrl = ALU_SRL;
                            7'b010_0000: alu_ctrl = ALU_SRA;
                            default: alu_ctrl = 4'bxxxx;
                        endcase
                    end
                    3'b110: alu_ctrl = ALU_OR;
                    3'b111: alu_ctrl = ALU_AND;
                    default: alu_ctrl = 4'bxxxx;
                endcase
                alu_src = 1'b1;
                mem2reg = 1'b0;
                size_type = 3'bxxx;
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // Load Operations
            7'b000_0011: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = I_TYPE;
                branch_type = 3'b010;
                alu_ctrl = ALU_ADD;
                alu_src = 1'b1;
                mem2reg = 1'b1;
                case (funct3)
                    3'b000: size_type = BYTE;
                    3'b001: size_type = HALF_WORD;
                    3'b010: size_type = WORD;
                    3'b100: size_type = BYTE_UNSIGNED;
                    3'b101: size_type = HALF_WORD_UNSIGNED;
                    default: size_type = 3'bxxx; 
                endcase
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // Store Operations
            7'b010_0011: begin
                we_mem = 1'b1;
                we_reg = 1'b0;
                instr_type = S_TYPE;
                branch_type = 3'b010;
                alu_ctrl = ALU_ADD;
                alu_src = 1'b1;
                mem2reg = 1'bx;
                case (funct3)
                    3'b000: size_type = BYTE;
                    3'b001: size_type = HALF_WORD;
                    3'b010: size_type = WORD;
                    default: size_type = 3'bxxx; 
                endcase
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // Branch Operations
            7'b110_0011: begin
                we_mem = 1'b0;
                we_reg = 1'b0;
                instr_type = B_TYPE;
                branch_type = funct3;
                alu_ctrl = ALU_SUB;
                alu_src = 1'b0;
                mem2reg = 1'bx;
                size_type = 3'bxxx;
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // JAL Operation
            7'b110_1111: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = J_TYPE;
                branch_type = 3'b010;
                alu_ctrl = 4'bxxxx;
                alu_src = 1'bx;
                mem2reg = 1'bx;
                size_type = 3'bxxx;
                jump = 1'b1;
                jr = 1'b0;
                upper_imm = 2'b00;
            end
            
            // JALR Operation
            7'b110_0111: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = I_TYPE;
                branch_type = 3'b010;
                alu_ctrl = ALU_ADD;
                alu_src = 1'b1;
                mem2reg = 1'b0;
                size_type = 3'bxxx;
                jump = 1'b1;
                jr = 1'b1;
                upper_imm = 2'b00;
            end
            
            // LUI Operation
            7'b011_0111: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = U_TYPE;
                branch_type = 3'b010;
                alu_ctrl = 4'bxxxx;
                alu_src = 1'bx;
                mem2reg = 1'bx;
                size_type = 3'bxxx;
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b01;
            end
            
            // AUIPC Operation
            7'b001_0111: begin
                we_mem = 1'b0;
                we_reg = 1'b1;
                instr_type = U_TYPE;
                branch_type = 3'b010;
                alu_ctrl = 4'bxxxx;
                alu_src = 1'bx;
                mem2reg = 1'bx;
                size_type = 3'bxxx;
                jump = 1'b0;
                jr = 1'b0;
                upper_imm = 2'b10;
            end
            
        endcase
    end
    
endmodule
