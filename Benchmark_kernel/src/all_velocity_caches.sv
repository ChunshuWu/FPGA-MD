`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2022 12:59:48 AM
// Design Name: 
// Module Name: all_velocity_caches
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

module all_velocity_caches
(
	input                                                          clk,
	input                                                          rst,
	input                                                          i_MU_start,
	input                                                          i_MU_working,
	input  [NUM_CELLS-1:0]          [PARTICLE_ID_WIDTH-1:0]        i_MU_rd_addr,
	input  [NUM_CELLS-1:0]                                         i_MU_rd_en,
	input  [NUM_CELLS-1:0]                                         i_MU_wr_en,
    input  [NUM_CELLS-1:0]          [FLOAT_STRUCT_WIDTH-1:0]       i_MU_wr_vel, 
	
	output [NUM_CELLS-1:0]          [FLOAT_STRUCT_WIDTH-1:0]       o_MU_vel,
    output [NUM_CELLS-1:0]                                         o_MU_vel_valid
);

`VELOCITY_CACHE_INSTANCE(0,0,0)
`VELOCITY_CACHE_INSTANCE(0,0,1)
`VELOCITY_CACHE_INSTANCE(0,1,0)
`VELOCITY_CACHE_INSTANCE(0,1,1)
`VELOCITY_CACHE_INSTANCE(1,0,0)
`VELOCITY_CACHE_INSTANCE(1,0,1)
`VELOCITY_CACHE_INSTANCE(1,1,0)
`VELOCITY_CACHE_INSTANCE(1,1,1)
	
endmodule
