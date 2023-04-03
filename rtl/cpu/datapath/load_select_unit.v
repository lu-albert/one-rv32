`timescale 1ns / 1ps

// The load select unit handles all the variations to store the data and handles unaligned accesses too.
module load_select_unit #(parameter DATA_WIDTH = 32) (
    input [DATA_WIDTH-1:0] in_data,
    input [DATA_WIDTH-1:0] in_data_p1,
    input [1:0] mem_addr_lb,
    input [2:0] load_select,
    output reg [DATA_WIDTH-1:0] out_data
    );
    
    parameter BYTE = 3'b000, HALF_WORD = 3'b001, WORD = 3'b010, BYTE_UNSIGNED = 3'b011, HALF_WORD_UNSIGNED = 3'b100;
    
    always @ (*) begin
        case (load_select)
            BYTE: begin
                case (mem_addr_lb)
                    2'b00: out_data = {{DATA_WIDTH-8{in_data[7]}}, in_data[7:0]};
                    2'b01: out_data = {{DATA_WIDTH-8{in_data[15]}}, in_data[15:8]};
                    2'b10: out_data = {{DATA_WIDTH-8{in_data[23]}}, in_data[23:16]};
                    2'b11: out_data = {{DATA_WIDTH-8{in_data[31]}}, in_data[31:24]};
                endcase
            end
            
            HALF_WORD: begin
                case (mem_addr_lb)
                    2'b00: out_data = {{DATA_WIDTH-16{in_data[15]}}, in_data[15:0]};
                    2'b01: out_data = {{DATA_WIDTH-16{in_data[23]}}, in_data[23:8]};
                    2'b10: out_data = {{DATA_WIDTH-16{in_data[31]}}, in_data[31:16]};
                    2'b11: out_data = {{DATA_WIDTH-16{in_data_p1[7]}}, in_data_p1[7:0], in_data[31:24]};
                endcase
            end
            
            WORD: begin
                case (mem_addr_lb)
                    2'b00: out_data = in_data;
                    2'b01: out_data = {in_data_p1[7:0], in_data[31:8]};
                    2'b10: out_data = {in_data_p1[15:0], in_data[31:16]};
                    2'b11: out_data = {in_data_p1[23:0], in_data[31:24]};
                endcase
            end
            
            BYTE_UNSIGNED: begin
                case (mem_addr_lb)
                    2'b00: out_data = {{DATA_WIDTH-8{1'b0}}, in_data[7:0]};
                    2'b01: out_data = {{DATA_WIDTH-8{1'b0}}, in_data[15:8]};
                    2'b10: out_data = {{DATA_WIDTH-8{1'b0}}, in_data[23:16]};
                    2'b11: out_data = {{DATA_WIDTH-8{1'b0}}, in_data[31:24]};
                endcase
            end
            
            HALF_WORD_UNSIGNED: begin
                case (mem_addr_lb)
                    2'b00: out_data = {{DATA_WIDTH-16{1'b0}}, in_data[15:0]};
                    2'b01: out_data = {{DATA_WIDTH-16{1'b0}}, in_data[23:8]};
                    2'b10: out_data = {{DATA_WIDTH-16{1'b0}}, in_data[31:16]};
                    2'b11: out_data = {{DATA_WIDTH-16{1'b0}}, in_data_p1[7:0], in_data[31:24]};
                endcase
            end
            
            default: out_data = in_data;
            
        endcase
    end
    
endmodule
