`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2023 06:44:34 PM
// Design Name: 
// Module Name: ring_pos_to_remote_tb
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

module ring_pos_to_remote_tb(

    );
    
logic                                       clk;
logic                                       rst;
logic [NODE_ID_WIDTH-1:0]                   i_local_node_id;
logic [OFFSET_PKT_STRUCT_WIDTH-1:0]         i_source_offset_pkt;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]          i_source_gcid; 				// from the previous node
logic [NODE_ID_WIDTH-1:0]                   i_source_node_id;
logic [NB_CELL_COUNT_WIDTH-1:0]             i_source_lifetime; 	            // Used as valid
logic [NB_CELL_COUNT_WIDTH-1:0]             i_source_lifetime_split_remote;     // The number of lifetime to be consumed remotely

logic        [STREAMING_TDEST_WIDTH-1:0]    dest_id_w;
logic                                       all_pos_ring_nodes_empty;
logic                                       debug_all_dirty;
logic                                       remote_buffer_back_pressure;

logic        [OFFSET_PKT_STRUCT_WIDTH-1:0]   offset_pkt_to_remote; 						// to remote
logic        [3*GLOBAL_CELL_ID_WIDTH-1:0]    gcid_to_remote;
logic                                        offset_pkt_to_remote_valid;
logic        [NB_CELL_COUNT_WIDTH-1:0]       lifetime_to_remote;


logic    [AXIS_PKT_STRUCT_WIDTH-1:0]    axis_pos_pkt_to_remote;


always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_local_node_id <= 7;
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_node_id <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	dest_id_w <= 0;
	remote_buffer_back_pressure <= 0;
	all_pos_ring_nodes_empty <= 0;
	debug_all_dirty <= 0;
	
	#20
	rst <= 1'b0;
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_source_gcid <= 9'b010010010;
	i_source_lifetime <= 4;
	i_source_lifetime_split_remote <= 3;
    // 0000000 000000001 01 010010010 0010 0
	
	#2
	i_source_lifetime <= 4;
	i_source_lifetime_split_remote <= 2;
	
	#20
	remote_buffer_back_pressure <= 1;
	
	#20
	remote_buffer_back_pressure <= 0;
	
	#20
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	
	#60
	debug_all_dirty <= 1;
	all_pos_ring_nodes_empty <= 1;
	
	#20
	all_pos_ring_nodes_empty <= 0;
	debug_all_dirty <= 0;
	
	#20
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_source_gcid <= 9'b010010010;
	i_source_lifetime <= 4;
	i_source_lifetime_split_remote <= 3;
	
	#20
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	
	#60
	debug_all_dirty <= 1;
	all_pos_ring_nodes_empty <= 1;
	end

pos_input_ring_node_ext pos_input_ring_node_ext (
    .clk                                ( clk                               ),
    .rst                                ( rst                               ), 
    .i_local_node_id                    ( i_local_node_id                   ),
    .i_source_offset_pkt                ( i_source_offset_pkt               ), 
    .i_source_gcid                      ( i_source_gcid                     ), 
    .i_source_node_id                   ( i_source_node_id                  ), 
    .i_source_lifetime                  ( i_source_lifetime                 ),
    .i_source_lifetime_split_remote     ( i_source_lifetime_split_remote    ),
    .i_remote_offset_pkt                ( 0                                 ), 
    .i_remote_gcid                      ( 0                                 ), 
    .i_remote_valid                     ( 0                                 ),
    .i_remote_lifetime                  ( 0                                 ),
    .i_remote_buffer_back_pressure      ( remote_buffer_back_pressure       ),
    
    .o_offset_pkt_to_ring               (  ), 
    .o_gcid_to_ring                     (  ), 
    .o_node_id_to_ring                  (  ),
    .o_lifetime_to_ring                 (  ), 
    .o_lifetime_split_remote_to_ring    (  ), 
    .o_offset_pkt_to_remote             ( offset_pkt_to_remote              ),
    .o_gcid_to_remote                   ( gcid_to_remote                    ), 
    .o_offset_pkt_to_remote_valid       ( offset_pkt_to_remote_valid        ),
    .o_lifetime_to_remote               ( lifetime_to_remote                ),
    .o_node_empty                       (  ),
    .o_remote_ack                       (  )
);

ring_pos_to_remote_controller ring_pos_to_remote_controller (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_dest_id                      ( dest_id_w                     ),      // tbc
    .i_all_pos_ring_nodes_empty     ( all_pos_ring_nodes_empty      ),
    .i_all_pos_caches_dirty         ( debug_all_dirty               ),
    .i_offset_pkt_to_remote         ( offset_pkt_to_remote          ),
    .i_gcid_to_remote               ( gcid_to_remote                ),
    .i_offset_pkt_to_remote_valid   ( offset_pkt_to_remote_valid    ),
    .i_lifetime_to_remote           ( lifetime_to_remote            ),
    
    .o_axis_pos_pkt_to_remote       ( axis_pos_pkt_to_remote        )
);

endmodule
