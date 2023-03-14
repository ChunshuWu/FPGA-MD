`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2022 01:23:55 AM
// Design Name: 
// Module Name: all_pos_caches
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

module all_pos_caches
(
	input clk,
	input rst,
	
	input                                                           i_PE_start,
	input                                                           i_MU_start,
	input                                                           i_MU_working,
	input                                                           i_iter_target_reached,
    input  [PARTICLE_ID_WIDTH-1:0]                                  i_init_wr_addr, 
    input  [NUM_CELLS-1:0]          [OFFSET_STRUCT_WIDTH-1:0]       i_init_data, 
    input  [NUM_CELLS-1:0]          [ELEMENT_WIDTH-1:0]             i_init_element,
    input  [NUM_INIT_STEPS-1:0]                                     i_init_wr_en, 
    input  [NUM_CELLS-1:0]                                          i_dirty,
	input  [NUM_CELLS-1:0]          [PARTICLE_ID_WIDTH-1:0]         i_MU_rd_addr,
	input  [NUM_CELLS-1:0]                                          i_MU_rd_en,
	input  [NUM_CELLS-1:0]                                          i_MU_wr_en,
    input  [NUM_CELLS-1:0]          [OFFSET_STRUCT_WIDTH-1:0]       i_MU_wr_pos, 
    input  [NUM_CELLS-1:0]          [ELEMENT_WIDTH-1:0]             i_MU_wr_element, 
    
    output [NUM_CELLS-1:0]          [OFFSET_PKT_STRUCT_WIDTH-1:0]   o_pos_pkt, 
	output [NUM_CELLS-1:0]          [3*GLOBAL_CELL_ID_WIDTH-1:0]    o_cur_gcid,
    output [NUM_CELLS-1:0]                                          o_valid,
    output [NUM_CELLS-1:0]                                          o_MU_offset_valid,
    output [NUM_CELLS-1:0]                                          o_dirty,
    output [NUM_CELLS-1:0]          [PARTICLE_ID_WIDTH-1:0]         o_debug_num_particles,
    output [NUM_CELLS-1:0]                                          o_debug_all_dirty,
    output [NUM_CELLS-1:0]          [3:0]                           o_debug_state
);

`POS_CACHE_INSTANCE(0,0,0)
`POS_CACHE_INSTANCE(0,0,1)
`POS_CACHE_INSTANCE(0,0,2)
`POS_CACHE_INSTANCE(0,1,0)
`POS_CACHE_INSTANCE(0,1,1)
`POS_CACHE_INSTANCE(0,1,2)
`POS_CACHE_INSTANCE(0,2,0)
`POS_CACHE_INSTANCE(0,2,1)
`POS_CACHE_INSTANCE(0,2,2)

`POS_CACHE_INSTANCE(1,0,0)
`POS_CACHE_INSTANCE(1,0,1)
`POS_CACHE_INSTANCE(1,0,2)
`POS_CACHE_INSTANCE(1,1,0)
`POS_CACHE_INSTANCE(1,1,1)
`POS_CACHE_INSTANCE(1,1,2)
`POS_CACHE_INSTANCE(1,2,0)
`POS_CACHE_INSTANCE(1,2,1)
`POS_CACHE_INSTANCE(1,2,2)

`POS_CACHE_INSTANCE(2,0,0)
`POS_CACHE_INSTANCE(2,0,1)
`POS_CACHE_INSTANCE(2,0,2)
`POS_CACHE_INSTANCE(2,1,0)
`POS_CACHE_INSTANCE(2,1,1)
`POS_CACHE_INSTANCE(2,1,2)
`POS_CACHE_INSTANCE(2,2,0)
`POS_CACHE_INSTANCE(2,2,1)
`POS_CACHE_INSTANCE(2,2,2)

//`POS_CACHE_INSTANCE(0,0,0)
//`POS_CACHE_INSTANCE(0,0,1)
//`POS_CACHE_INSTANCE(0,1,0)
//`POS_CACHE_INSTANCE(0,1,1)
//`POS_CACHE_INSTANCE(1,0,0)
//`POS_CACHE_INSTANCE(1,0,1)
//`POS_CACHE_INSTANCE(1,1,0)
//`POS_CACHE_INSTANCE(1,1,1)

	
endmodule

