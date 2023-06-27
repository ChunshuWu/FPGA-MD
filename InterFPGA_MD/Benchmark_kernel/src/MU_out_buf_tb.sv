`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2022 11:06:15 AM
// Design Name: 
// Module Name: MU_out_buf_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import MD_pkg::*;

module MU_out_buf_tb;
    
    
logic                            clk;
logic                            rst;
logic       buf_rden;
logic       buf_wren;
MU_packet_t MU_packet_buf;
MU_packet_t MU_packet_buf_out;
logic       buf_out_valid;
logic       buf_out_invalid;

MU_packet_t o_MU_pkt;
logic       o_data_valid;

assign buf_out_valid = ~buf_out_invalid; 

always@(posedge clk) begin
    if (rst) begin
        o_data_valid <= 0;
        o_MU_pkt       <= 0;
//        buf_rden <= 1'b0;
    end
    else begin
        if (buf_out_valid) begin
//            buf_rden <= 1'b1;
            o_data_valid   <= 1'b1;
            o_MU_pkt       <= MU_packet_buf_out;
        end
        else begin
//            buf_rden <= 1'b0;
            o_data_valid   <= 1'b0;
        end
    end
end

assign buf_rden = buf_out_valid;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	buf_rden <= 1'b0;
	buf_wren <= 1'b0;
	MU_packet_buf <= 0;
	
	#10
	rst <= 1'b0;
	
	#2
	buf_wren <= 1'b1;
	MU_packet_buf <= 1;
	
	#2
	buf_wren <= 1'b0;
	
	
	
	end
MU_OUT_BUF MU_out_buffer
(
	.clk           ( clk               ), 
	.rst           ( rst               ), 
	.rd_en         ( buf_rden          ), 
	.wr_en         ( buf_wren          ), 
	.data_in       ( MU_packet_buf     ), 
	
	.data_out      ( MU_packet_buf_out ), 
	.empty         ( buf_out_invalid   ), 
	.almost_full   (      )
);
endmodule
