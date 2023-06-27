`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2023 12:58:26 PM
// Design Name: 
// Module Name: remote_pos_tb
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

module remote_pos_tb;


logic                                       clk;
logic                                       rst;
logic [OFFSET_PKT_STRUCT_WIDTH-1:0]         i_source_offset_pkt;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]          i_source_gcid; 				// from the previous node
logic [NB_CELL_COUNT_WIDTH-1:0]             i_source_lifetime; 	            // Used as valid
logic [NB_CELL_COUNT_WIDTH-1:0]             i_source_lifetime_split_remote;     // The number of lifetime to be consumed remotely
logic                                       remote_pos_tvalid;					        // from remote
logic       [AXIS_TDATA_WIDTH-1:0]          remote_pos_tdata;
logic        [STREAMING_TDEST_WIDTH-1:0]    dest_id_w;
logic                                       all_pos_ring_nodes_empty;
logic                                       debug_all_dirty;



logic        [OFFSET_PKT_STRUCT_WIDTH-1:0]   remote_offset_pkt; 						// from remote
logic        [3*GLOBAL_CELL_ID_WIDTH-1:0]    remote_gcid; 
logic                                        remote_valid; 
logic        [NB_CELL_COUNT_WIDTH-1:0]       remote_lifetime;
logic                                        remote_buffer_back_pressure;

logic        [OFFSET_PKT_STRUCT_WIDTH-1:0]   offset_pkt_to_remote; 						// to remote
logic        [3*GLOBAL_CELL_ID_WIDTH-1:0]    gcid_to_remote;
logic                                        offset_pkt_to_remote_valid;
logic        [NB_CELL_COUNT_WIDTH-1:0]       lifetime_to_remote;

logic                                        remote_ack_from_ring;

logic    [AXIS_PKT_STRUCT_WIDTH-1:0]    axis_pos_pkt_to_remote;
logic                                   last_transfer_from_remote;
logic                                   remote_pos_buf_valid;					        // from remote in buf
logic                                   remote_pos_buf_empty;
logic    [AXIS_TDATA_WIDTH-1:0]         remote_pos_buf_data;
logic                                   remote_pos_buf_full;
logic                                   remote_pos_buf_ack;



 logic [OFFSET_PKT_STRUCT_WIDTH-1:0] o_offset_pkt_to_ring; 
 logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_gcid_to_ring; 		// to the next node
 logic [NB_CELL_COUNT_WIDTH-1:0]     o_lifetime_to_ring;
 logic [NB_CELL_COUNT_WIDTH-1:0]     o_lifetime_split_remote_to_ring;

 logic                               o_remote_ack;                         // tell remote pos controller the remote data is received
 logic                               o_node_empty;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	dest_id_w <= 0;
	all_pos_ring_nodes_empty <= 0;
	debug_all_dirty <= 0;
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	remote_pos_tdata <= 0;
	remote_pos_tvalid <= 0;
	remote_buffer_back_pressure <= 0;
	
	#20
	rst <= 1'b0;
	dest_id_w <= 7;
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_source_gcid <= 9'b000000000;
	i_source_lifetime <= 4;
	i_source_lifetime_split_remote <= 3;
    // 0000000 000000001 01 010010010 0010 0
	remote_pos_tdata <= {4{32'h00015244,32'hffffffff,32'hffffffff,32'hffffffff}};
	remote_pos_tvalid <= 1;
	
	#20
	remote_buffer_back_pressure <= 1;
	
	#20
	remote_buffer_back_pressure <= 0;
	
	#20
    debug_all_dirty <= 1;
	
	#20
	all_pos_ring_nodes_empty <= 1;
	
	#2
	remote_pos_tdata <= 0;
	remote_pos_tvalid <= 0;
	
	#20
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	
	#500
	all_pos_ring_nodes_empty <= 0;
	debug_all_dirty <= 0;
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_source_gcid <= 9'b000000000;
	i_source_lifetime <= 4;
	i_source_lifetime_split_remote <= 3;
    // 0000000 000000001 01 010010010 0010 0
	remote_pos_tdata <= {4{32'h00015244,32'hffffffff,32'hffffffff,32'hffffffff}};
	remote_pos_tvalid <= 1;
	
	#20
    debug_all_dirty <= 1;
	
	#20
	all_pos_ring_nodes_empty <= 1;
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	remote_pos_tdata <= 0;
	remote_pos_tvalid <= 0;
	end
	
	
REMOTE_POS_IN_FIFO remote_pos_in_fifo (
    .clk        ( clk                   ),
    .rst        ( rst                   ),
    .din        ( remote_pos_tdata      ),
    .wr_en      ( remote_pos_tvalid     ),
    .rd_en      ( remote_pos_buf_ack    ),
    
    .empty      ( remote_pos_buf_empty ),
    .prog_full  ( remote_pos_buf_full   ),
    .dout       ( remote_pos_buf_data   )
);

assign remote_pos_buf_valid = ~remote_pos_buf_empty;

pos_input_ring_node_ext pos_input_ring_node_ext (
    .clk                                ( clk                               ),
    .rst                                ( rst                               ), 
    .i_source_offset_pkt                ( i_source_offset_pkt               ), 
    .i_source_gcid                      ( i_source_gcid                     ), 
    .i_source_lifetime                  ( i_source_lifetime                 ),
    .i_source_lifetime_split_remote     ( i_source_lifetime_split_remote    ),
    .i_remote_offset_pkt                ( remote_offset_pkt               ), 
    .i_remote_gcid                      ( remote_gcid                     ), 
    .i_remote_valid                     ( remote_valid                    ),
    .i_remote_lifetime                  ( remote_lifetime                 ),
    .i_remote_buffer_back_pressure      ( remote_buffer_back_pressure     ),
    
    .o_offset_pkt_to_ring               ( o_offset_pkt_to_ring              ), 
    .o_gcid_to_ring                     ( o_gcid_to_ring                    ), 
    .o_lifetime_to_ring                 ( o_lifetime_to_ring                ), 
    .o_lifetime_split_remote_to_ring    ( o_lifetime_split_remote_to_ring   ), 
    .o_offset_pkt_to_remote             ( offset_pkt_to_remote            ),
    .o_gcid_to_remote                   ( gcid_to_remote                  ), 
    .o_offset_pkt_to_remote_valid       ( offset_pkt_to_remote_valid      ),
    .o_lifetime_to_remote               ( lifetime_to_remote              ),
    .o_node_empty                       ( o_node_empty                      ),
    .o_remote_ack                       ( o_remote_ack                      )
);

assign remote_ack_from_ring = o_remote_ack;

remote_pos_controller remote_pos_controller (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_dest_id                      ( dest_id_w                     ),      // tbc
    .i_all_pos_ring_nodes_empty     ( all_pos_ring_nodes_empty      ),
    .i_all_pos_caches_dirty         ( debug_all_dirty               ),
    .i_offset_pkt_to_remote         ( offset_pkt_to_remote          ),
    .i_gcid_to_remote               ( gcid_to_remote                ),
    .i_offset_pkt_to_remote_valid   ( offset_pkt_to_remote_valid    ),
    .i_lifetime_to_remote           ( lifetime_to_remote            ),
    .i_remote_ack_from_ring         ( remote_ack_from_ring          ),
    .i_remote_tdata                 ( remote_pos_buf_data           ),      // tbd
    .i_remote_tvalid                ( remote_pos_buf_valid          ),      // tbd
    
    .o_remote_offset_pkt            ( remote_offset_pkt             ),
    .o_remote_gcid                  ( remote_gcid                   ),
    .o_remote_valid                 ( remote_valid                  ),
    .o_remote_lifetime              ( remote_lifetime               ),
    .o_last_transfer_from_remote    ( last_transfer_from_remote     ),      // sys signal, resets to 0 in the next iter
    .o_remote_input_buf_ack         ( remote_pos_buf_ack            ),      // tbd
    .o_axis_pos_pkt_to_remote       ( axis_pos_pkt_to_remote        )
);

endmodule
