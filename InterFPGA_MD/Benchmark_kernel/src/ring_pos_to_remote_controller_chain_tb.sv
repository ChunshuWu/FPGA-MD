`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 04:11:35 PM
// Design Name: 
// Module Name: ring_pos_to_remote_controller_chain_tb
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

module ring_pos_to_remote_controller_chain_tb;

logic                                           clk;
logic                                           rst;
logic           [NODE_ID_WIDTH-1:0]             i_init_id;                                  // Assume 8 nodes, 3 bits
logic                                           i_all_pos_ring_nodes_empty;
logic                                           i_all_dirty;
logic           [OFFSET_PKT_STRUCT_WIDTH-1:0]   i_offset_pkt_to_remote; 					// to remote
logic           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_gcid_to_remote;
logic                                           i_offset_pkt_to_remote_valid;
logic           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote_xz;
logic           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote_x;
logic           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote_z;

logic           [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_pos_pkt_to_remote;                  // to remote
logic                                           o_ring_pos_to_remote_bufs_empty;
logic                                           o_pos_burst_running;
logic                                           o_last_pos_sent;

ring_pos_to_remote_controller_chain ring_pos_to_remote_controller_chain (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_init_id                      ( i_init_id                     ),      // tbc
    .i_all_pos_ring_nodes_empty     ( i_all_pos_ring_nodes_empty    ),
    .i_all_dirty                    ( i_all_dirty                   ),
    .i_offset_pkt_to_remote         ( i_offset_pkt_to_remote        ),
    .i_gcid_to_remote               ( i_gcid_to_remote              ),
    .i_offset_pkt_to_remote_valid   ( i_offset_pkt_to_remote_valid  ),
    .i_lifetime_to_remote_xz        ( i_lifetime_to_remote_xz       ),
    .i_lifetime_to_remote_x         ( i_lifetime_to_remote_x        ),
    .i_lifetime_to_remote_z         ( i_lifetime_to_remote_z        ),
    
    .o_axis_pos_pkt_to_remote       ( o_axis_pos_pkt_to_remote      ),
    .o_ring_pos_to_remote_bufs_empty( o_ring_pos_to_remote_bufs_empty   ),
    .o_pos_burst_running            ( o_pos_burst_running           ),
    .o_last_pos_sent                ( o_last_pos_sent               )
);

always #1 clk <= ~clk;

always@(posedge clk) begin
    if (rst) begin
	   i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +: PARTICLE_ID_WIDTH] <= 0;
    end
    else begin
	   i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +: PARTICLE_ID_WIDTH] 
	   <= i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +: PARTICLE_ID_WIDTH] + 1'b1;
    end
end
initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_init_id <= 0;
	i_all_pos_ring_nodes_empty <= 0;
	i_all_dirty <= 0;
	i_offset_pkt_to_remote[OFFSET_WIDTH-1:0] <= 0;
	i_offset_pkt_to_remote[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 0;
	i_offset_pkt_to_remote[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 0;
	i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +PARTICLE_ID_WIDTH +: ELEMENT_WIDTH] <= 0;
	i_gcid_to_remote <= 0;
	i_offset_pkt_to_remote_valid <= 0;
	i_lifetime_to_remote_xz <= 0;
	i_lifetime_to_remote_x <= 0;
	i_lifetime_to_remote_z <= 0;
	
	#20
	rst <= 1'b0;
	i_init_id <= 3'b000;
	i_offset_pkt_to_remote[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_offset_pkt_to_remote[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_offset_pkt_to_remote[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_offset_pkt_to_remote[OFFSET_STRUCT_WIDTH +PARTICLE_ID_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_gcid_to_remote <= 9'b010010010;
	i_lifetime_to_remote_xz <= 3;
	i_lifetime_to_remote_x <= 6;
	i_lifetime_to_remote_z <= 2;
	i_offset_pkt_to_remote_valid <= 1'b1;
	
	#100
	i_all_pos_ring_nodes_empty <= 1'b1;
	i_all_dirty <= 1'b1;
	i_offset_pkt_to_remote_valid <= 1'b0;
	
end
endmodule
