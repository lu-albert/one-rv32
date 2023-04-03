`timescale 1ns / 1ps

// The store select unit handles all the variations to store the data aand handles unaligned stores too.
module store_select_unit #(parameter DATA_WIDTH = 32) (
    input [DATA_WIDTH-1:0] in_data,
    input [DATA_WIDTH-1:0] mem_out,
    input [DATA_WIDTH-1:0] mem_out_p1,
    input [1:0] addr_lb,
    input [2:0] store_select,
    output reg [DATA_WIDTH-1:0] out_data,
    output reg [DATA_WIDTH-1:0] out_data_p1
    );
    
    parameter BYTE = 3'b000, HALF_WORD = 3'b001, WORD = 3'b010, BYTE_UNSIGNED = 3'b011, HALF_WORD_UNSIGNED = 3'b100;
    
    always @ (*) begin
        case (store_select)
            BYTE: begin
                case (addr_lb)
                    2'b00: out_data = {mem_out[31:8], in_data[7:0]};
                    2'b01: out_data = {mem_out[31:16], in_data[7:0], mem_out[7:0]};
                    2'b10: out_data = {mem_out[31:24], in_data[7:0], mem_out[15:0]};
                    2'b11: out_data = {in_data[7:0], mem_out[23:0]};
                endcase
                out_data_p1 = mem_out_p1;
            end
            
            HALF_WORD: begin
                case (addr_lb)
                    2'b00: out_data = {mem_out[31:16], in_data[15:0]};
                    2'b01: out_data = {mem_out[31:24], in_data[15:0], mem_out[7:0]};
                    2'b10: out_data = {in_data[15:0], mem_out[15:0]};
                    2'b11: out_data = {in_data[7:0], mem_out[23:0]};
                endcase
                out_data_p1 = {mem_out_p1[31:8], in_data[15:8]};
            end
            
            WORD: begin
                case (addr_lb)
                    2'b00: out_data = in_data;
                    2'b01: out_data = {in_data[23:0], mem_out[7:0]};
                    2'b10: out_data = {in_data[15:0], mem_out[15:0]};
                    2'b11: out_data = {in_data[7:0], mem_out[24:0]};
                endcase
                case (addr_lb)
                    2'b00: out_data_p1 = mem_out_p1;
                    2'b01: out_data_p1 = {mem_out[31:8], in_data[31:24]};
                    2'b10: out_data_p1 = {mem_out[31:16], in_data[31:16]};
                    2'b11: out_data_p1 = {mem_out[31:24], in_data[31:8]};
                endcase
            end
            
            default: out_data = in_data;
        endcase
    end
    
endmodule
