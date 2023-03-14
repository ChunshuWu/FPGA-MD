`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2022 10:49:48 PM
// Design Name: 
// Module Name: check_pos_input_ring_target_hit_tb
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

import MD_pkg::*;   // Change OFFSET_WIDTH to 30 before simulating, or change the test cases below. 

module pos_cache_tb;

logic                               clk;
logic                               rst;

logic                               i_PE_start;
logic                               i_MU_start;
logic                               i_MU_working;
logic  [PARTICLE_ID_WIDTH-1:0]      i_init_wr_addr;
offset_data_t                       i_init_data;
logic  [ELEMENT_WIDTH-1:0]          i_init_element;
logic                               i_init_wr_en;
logic                               i_dirty;
logic  [PARTICLE_ID_WIDTH-1:0]      i_MU_rd_addr;
logic                               i_MU_rd_en;
logic                               i_MU_wr_en;
offset_data_t                       i_MU_wr_pos;
logic  [ELEMENT_WIDTH-1:0]          i_MU_wr_element;

offset_packet_t                     o_pos_pkt;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_cur_gcid;
logic                               o_valid;
logic                               o_MU_offset_valid;
logic                               o_dirty;
logic [PARTICLE_ID_WIDTH-1:0]       o_debug_num_particles;
logic                               o_debug_all_dirty;
logic [3:0]                         o_debug_state;

always #1 clk <= ~clk;

initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_PE_start <= 0;
	i_MU_start <= 0;
	i_MU_working <= 0;
	i_init_element <= 0;
	i_init_data <= 0;
	i_init_wr_en <= 0;
	i_init_wr_addr <= 0;
	i_dirty <= 0;
	
	i_MU_rd_addr <= 0;
	i_MU_rd_en <= 0;
	i_MU_wr_en <= 0;
	i_MU_wr_pos <= 0;
	i_MU_wr_element <= 0;
	
	#10
	rst <= 1'b0;
	
	#10
	i_init_wr_addr <= 0;
    i_init_data.offset_x <= 15;
    i_init_data.offset_y <= 0;
    i_init_data.offset_z <= 0;
	i_init_element <= 0;
	i_init_wr_en   <= 1'b1;
	
	#2
	i_init_wr_addr <= 1;
    i_init_data.offset_x <= 23'h080000;
    i_init_data.offset_y <= 23'h080000;
    i_init_data.offset_z <= 23'h080000;
    i_init_element <= 1;
	
	#2
	i_init_wr_addr <= 2;
    i_init_data.offset_x <= 23'h100000;
    i_init_data.offset_y <= 23'h100000;
    i_init_data.offset_z <= 23'h100000;
	
	#2
	i_init_wr_addr <= 3;
    i_init_data.offset_x <= 23'h180000;
    i_init_data.offset_y <= 23'h180000;
    i_init_data.offset_z <= 23'h180000;
	
	#2
	i_init_wr_addr <= 4;
    i_init_data.offset_x <= 23'h200000;
    i_init_data.offset_y <= 23'h200000;
    i_init_data.offset_z <= 23'h200000;
	
	#2
	i_init_wr_addr <= 5;
    i_init_data.offset_x <= 23'h280000;
    i_init_data.offset_y <= 23'h280000;
    i_init_data.offset_z <= 23'h280000;
	
	#2
	i_init_wr_addr <= 6;
    i_init_data.offset_x <= 23'h300000;
    i_init_data.offset_y <= 23'h300000;
    i_init_data.offset_z <= 23'h300000;
	
	#2
	i_init_wr_addr <= 7;
    i_init_data.offset_x <= 23'h380000;
    i_init_data.offset_y <= 23'h380000;
    i_init_data.offset_z <= 23'h380000;
	
	#2
	i_init_wr_addr <= 8;
    i_init_data.offset_x <= 23'h400000;
    i_init_data.offset_y <= 23'h400000;
    i_init_data.offset_z <= 23'h400000;
	
	#2
	i_init_wr_addr <= 9;
    i_init_data.offset_x <= 23'h480000;
    i_init_data.offset_y <= 23'h480000;
    i_init_data.offset_z <= 23'h480000;
	
	#2
	i_init_wr_addr <= 10;
    i_init_data.offset_x <= 23'h500000;
    i_init_data.offset_y <= 23'h500000;
    i_init_data.offset_z <= 23'h500000;
	
	#2
	i_init_wr_addr <= 11;
    i_init_data.offset_x <= 23'h580000;
    i_init_data.offset_y <= 23'h580000;
    i_init_data.offset_z <= 23'h580000;
	
	#2
	i_init_wr_addr <= 12;
    i_init_data.offset_x <= 23'h600000;
    i_init_data.offset_y <= 23'h600000;
    i_init_data.offset_z <= 23'h600000;
	
	#2
	i_init_wr_addr <= 13;
    i_init_data.offset_x <= 23'h680000;
    i_init_data.offset_y <= 23'h680000;
    i_init_data.offset_z <= 23'h680000;
	
	#2
	i_init_wr_addr <= 14;
    i_init_data.offset_x <= 23'h700000;
    i_init_data.offset_y <= 23'h700000;
    i_init_data.offset_z <= 23'h700000;
	
	#2
	i_init_wr_addr <= 15;
    i_init_data.offset_x <= 23'h780000;
    i_init_data.offset_y <= 23'h780000;
    i_init_data.offset_z <= 23'h780000;
	
	#2
	i_init_wr_en <= 0;
	
	#20
	i_PE_start <= 1'b1;
	
	#6
	i_dirty <= 1'b1;
	
	#30
	i_dirty <= 1'b0;
	
	#20
	i_MU_start <= 1'b1;
	
	#2
	i_MU_start <= 1'b0;
	i_MU_working <= 1;
	i_MU_rd_addr <= 0;
	i_MU_rd_en <= 1;
	
	#2
	i_MU_rd_addr <= 1;
	
	#2
	i_MU_rd_addr <= 2;
	
	#2
	i_MU_rd_addr <= 3;
	
	#2
	i_MU_rd_addr <= 4;
	
	#2
	i_MU_rd_addr <= 5;
	
	#2
	i_MU_rd_addr <= 6;
	
	#2
	i_MU_rd_addr <= 0;
	i_MU_rd_en <= 0;
	
	#2
	i_MU_working <= 0;
	end

pos_cache pos_cache
	(
		.clk          (clk), 
		.rst          (rst), 
		.i_PE_start          (i_PE_start), 
		.i_MU_start          (i_MU_start), 
		.i_MU_working          (i_MU_working), 
		.i_init_wr_addr          (i_init_wr_addr), 
		.i_init_data          (i_init_data), 
		.i_init_element          (i_init_element), 
		.i_init_wr_en          (i_init_wr_en), 
		.i_dirty          (i_dirty), 
		.i_MU_rd_addr          (i_MU_rd_addr), 
		.i_MU_rd_en          (i_MU_rd_en), 
		.i_MU_wr_en          (i_MU_wr_en), 
		.i_MU_wr_pos          (i_MU_wr_pos), 
		.i_MU_wr_element          (i_MU_wr_element), 
		.o_pos_pkt          (o_pos_pkt), 
		.o_cur_gcid          (o_cur_gcid), 
		.o_valid          (o_valid), 
		.o_MU_offset_valid          (o_MU_offset_valid), 
		.o_dirty          (o_dirty), 
		.o_debug_num_particles          (o_debug_num_particles), 
		.o_debug_all_dirty          (o_debug_all_dirty), 
		.o_debug_state          (o_debug_state)
	);

endmodule