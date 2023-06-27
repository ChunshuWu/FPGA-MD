`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 06:13:41 PM
// Design Name: 
// Module Name: remote_pos_controller_tb
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

module remote_pos_controller_tb;

logic                                           clk;
logic                                           rst;
logic           [STREAMING_TDEST_WIDTH-1:0]     i_dest_id; 
logic                                           i_all_pos_ring_nodes_empty;
logic                                           i_all_pos_caches_dirty;
logic           [OFFSET_PKT_STRUCT_WIDTH-1:0]   i_offset_pkt_to_remote; 					// to remote
logic           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_gcid_to_remote;
logic                                           i_offset_pkt_to_remote_valid;
logic           [NB_CELL_COUNT_WIDTH-1:0]       i_lifetime_to_remote;
logic                                           i_remote_ack_from_ring;

logic           [AXIS_TDATA_WIDTH-1:0]          i_remote_tdata;					        // from remote
logic                                           i_remote_tvalid;

logic    [OFFSET_PKT_STRUCT_WIDTH-1:0]   o_remote_offset_pkt; 						// from remote
logic    [3*GLOBAL_CELL_ID_WIDTH-1:0]    o_remote_gcid;
logic                                    o_remote_valid;
logic    [NB_CELL_COUNT_WIDTH-1:0]       o_remote_lifetime;
logic                                    o_last_transfer_from_remote;
logic                                    o_remote_input_buf_ack;

logic    [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_pos_pkt_to_remote;                  // to remote
    
always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_dest_id <= 0;
	i_all_pos_ring_nodes_empty <= 0;
	i_all_pos_caches_dirty <= 0;
	i_offset_pkt_to_remote <= 0;
	i_gcid_to_remote <= 0;
	i_offset_pkt_to_remote_valid <= 0;
	i_lifetime_to_remote <= 0;
	i_remote_ack_from_ring <= 0;
	i_remote_tdata <= 0;
	i_remote_tvalid <= 0;
	
	#20
	rst <= 1'b0;
	i_dest_id <= 7;
	i_offset_pkt_to_remote[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_offset_pkt_to_remote[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_offset_pkt_to_remote[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_offset_pkt_to_remote[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_offset_pkt_to_remote[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_offset_pkt_to_remote_valid <= 1;
	i_gcid_to_remote <= 9'b000000000;
	i_lifetime_to_remote <= 4;
	i_remote_ack_from_ring <= 1;
	
	i_remote_tdata <= {4{32'hffffffff,32'hcccccccc,32'hbbbbbbbb,32'haaaaaaaa}};
	i_remote_tvalid <= 1;
	
	#2
    i_all_pos_caches_dirty <= 1;
	
	#22
	i_all_pos_ring_nodes_empty <= 1;
	
	#2
	i_lifetime_to_remote <= 0;
	i_offset_pkt_to_remote_valid <= 0;
	
	#20
	i_remote_tvalid <= 0;
	
	#4
	i_remote_ack_from_ring <= 0;
	
	
	
	
	end

remote_pos_controller remote_pos_controller (
    .clk                            ( clk                        ), 
    .rst                            ( rst                     ),
    .i_dest_id                      ( i_dest_id                     ),      // tbc
    .i_all_pos_ring_nodes_empty     ( i_all_pos_ring_nodes_empty      ),
    .i_all_pos_caches_dirty         ( i_all_pos_caches_dirty               ),
    .i_offset_pkt_to_remote         ( i_offset_pkt_to_remote          ),
    .i_gcid_to_remote               ( i_gcid_to_remote                ),
    .i_offset_pkt_to_remote_valid   ( i_offset_pkt_to_remote_valid    ),
    .i_lifetime_to_remote           ( i_lifetime_to_remote            ),
    .i_remote_ack_from_ring         ( i_remote_ack_from_ring          ),
    .i_remote_tdata                 ( i_remote_tdata           ),      // tbd
    .i_remote_tvalid                ( i_remote_tvalid          ),      // tbd
    
    .o_remote_offset_pkt            ( o_remote_offset_pkt             ),
    .o_remote_gcid                  ( o_remote_gcid                   ),
    .o_remote_valid                 ( o_remote_valid                  ),
    .o_remote_lifetime              ( o_remote_lifetime               ),
    .o_last_transfer_from_remote    ( o_last_transfer_from_remote     ),      // sys signal, resets to 0 in the next iter
    .o_remote_input_buf_ack         ( o_remote_input_buf_ack            ),      // tbd
    .o_axis_pos_pkt_to_remote       ( o_axis_pos_pkt_to_remote        )
);
endmodule