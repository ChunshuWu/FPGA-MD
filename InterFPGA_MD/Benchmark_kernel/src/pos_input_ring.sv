
import MD_pkg::*;

module pos_input_ring (
	input clk, 
	input rst, 
	input                  [NODE_ID_WIDTH-1:0]             local_node_id,
	input [NUM_CELLS-1:0]  [OFFSET_PKT_STRUCT_WIDTH-1:0]   local_offset_pkt, 				// from pos cache
	input [NUM_CELLS-1:0]  [3*GLOBAL_CELL_ID_WIDTH-1:0]    local_gcid,
	input [NUM_CELLS-1:0]  [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]       local_split_lifetime,
	input [NUM_CELLS-1:0]                                  local_valid, 
	input [NUM_CELLS-1:0]                                  local_dirty, 
	input [NUM_CELLS-1:0]                                  dispatcher_back_pressure, 
	
	input                  [OFFSET_PKT_STRUCT_WIDTH-1:0]   remote_offset_pkt, 						// from remote
	input                  [3*GLOBAL_CELL_ID_WIDTH-1:0]    remote_gcid, 
	input                                                  remote_valid, 
	input                  [NB_CELL_COUNT_WIDTH-1:0]       remote_lifetime,
	input                                                  remote_buffer_back_pressure,
	
	output [NUM_CELLS-1:0] [POS_PKT_STRUCT_WIDTH-1:0]      pos_pkt_to_pe, 							// to PE
	output [NUM_CELLS-1:0] [NODE_ID_WIDTH-1:0]             node_id_to_pe,
	output logic           [NUM_CELLS-1:0]                 pos_pkt_to_pe_valid,
	output logic           [NUM_CELLS-1:0]                 dirty_feedback,
	
	output logic           [OFFSET_PKT_STRUCT_WIDTH-1:0]   offset_pkt_to_remote, 								// to remote
	output logic           [3*GLOBAL_CELL_ID_WIDTH-1:0]    gcid_to_remote, 
	output logic                                           offset_pkt_to_remote_valid, 
	output logic           [NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0]       lifetime_to_remote,
//	output logic           [NB_CELL_COUNT_WIDTH-1:0]       lifetime_to_remote_x,
//	output logic           [NB_CELL_COUNT_WIDTH-1:0]       lifetime_to_remote_z,
	output logic                                           all_nodes_empty,
	output logic                                           remote_ack
);

logic [NUM_CELLS-1:0]   [OFFSET_PKT_STRUCT_WIDTH-1:0]  offset_pkt_link;
logic [NUM_CELLS-1:0]   [3*GLOBAL_CELL_ID_WIDTH-1:0]   gcid_link;
logic [NUM_CELLS-1:0]   [NODE_ID_WIDTH-1:0]            node_id_link;
logic [NUM_CELLS-1:0]   [NB_CELL_COUNT_WIDTH-1:0]      lifetime_link;
logic [NUM_CELLS-1:0]   [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0] lifetime_split_remote_link;

logic [OFFSET_PKT_STRUCT_WIDTH-1:0]     offset_pkt_ext;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]      gcid_ext;
logic [NODE_ID_WIDTH-1:0]               node_id_ext;
logic [NB_CELL_COUNT_WIDTH-1:0]         lifetime_ext;
logic [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]   lifetime_split_remote_ext;

logic [NUM_CELLS:0]                     node_empty;
assign all_nodes_empty = &node_empty;

genvar i;
generate
	for (i = 1; i < NUM_CELLS; i++) begin: pos_input_ring_nodes
		pos_input_ring_node #(
			.GCELL_X                         ( {i / (Y_DIM * Z_DIM)}             ), 
			.GCELL_Y                         ( {i / Z_DIM % Y_DIM}               ), 
			.GCELL_Z                         ( {i % Z_DIM}                       )
		)
		pos_input_ring_node (
			.clk                             ( clk                               ),
			.rst                             ( rst                               ), 
			.i_source_offset_pkt             ( offset_pkt_link[(i-1)]            ), 
			.i_source_gcid                   ( gcid_link[(i-1)]                  ), 
			.i_source_node_id                ( node_id_link[(i-1)]               ), 
			.i_source_lifetime               ( lifetime_link[(i-1)]              ),
	        .i_source_lifetime_split_remote  ( lifetime_split_remote_link[(i-1)] ),
			.i_local_offset_pkt              ( local_offset_pkt[i]               ), 
			.i_local_gcid                    ( local_gcid[i]                     ), 
			.i_local_node_id                 ( local_node_id                     ),
			.i_local_split_lifetime          ( local_split_lifetime[i]           ),
			.i_local_valid                   ( local_valid[i]                    ),
			.i_local_dirty                   ( local_dirty[i]                    ),
			.i_dispatcher_back_pressure      ( dispatcher_back_pressure[i]       ),
			
			.o_offset_pkt_to_ring            ( offset_pkt_link[i]                ), 
			.o_gcid_to_ring                  ( gcid_link[i]                      ), 
			.o_node_id_to_ring               ( node_id_link[i]                   ), 
			.o_lifetime_to_ring              ( lifetime_link[i]                  ), 
	        .o_lifetime_split_remote_to_ring ( lifetime_split_remote_link[i]     ),
			.o_pos_pkt_to_pe                 ( pos_pkt_to_pe[i]                  ), 
			.o_node_id_to_pe                 ( node_id_to_pe[i]                  ), 
			.o_pos_pkt_to_pe_valid           ( pos_pkt_to_pe_valid[i]            ),
			.o_dirty_feedback                ( dirty_feedback[i]                 ),
			.o_node_empty                    ( node_empty[i]                     )
		);
    end
endgenerate
    
    pos_input_ring_node #(
        .GCELL_X                            ( {0}                           ), 
        .GCELL_Y                            ( {0}                           ), 
        .GCELL_Z                            ( {0}                           )
    ) pos_input_ring_node_0 (
        .clk                                ( clk                             ),
        .rst                                ( rst                             ), 
        .i_source_offset_pkt                ( offset_pkt_ext                  ), 
        .i_source_gcid                      ( gcid_ext                        ), 
        .i_source_node_id                   ( node_id_ext                     ),
        .i_source_lifetime                  ( lifetime_ext                    ),
	    .i_source_lifetime_split_remote     ( lifetime_split_remote_ext       ),
        .i_local_offset_pkt                 ( local_offset_pkt[0]             ), 
        .i_local_gcid                       ( local_gcid[0]                   ), 
        .i_local_node_id                    ( local_node_id                   ),
        .i_local_split_lifetime             ( local_split_lifetime[0]         ),
        .i_local_valid                      ( local_valid[0]                  ),
        .i_local_dirty                      ( local_dirty[0]                  ),
        .i_dispatcher_back_pressure         ( dispatcher_back_pressure[0]     ),
        
        .o_offset_pkt_to_ring               ( offset_pkt_link[0]              ), 
        .o_gcid_to_ring                     ( gcid_link[0]                    ), 
        .o_node_id_to_ring                  ( node_id_link[0]                 ), 
        .o_lifetime_to_ring                 ( lifetime_link[0]                ), 
	    .o_lifetime_split_remote_to_ring    ( lifetime_split_remote_link[0]   ),
        .o_pos_pkt_to_pe                    ( pos_pkt_to_pe[0]                ), 
        .o_node_id_to_pe                    ( node_id_to_pe[0]                ), 
        .o_pos_pkt_to_pe_valid              ( pos_pkt_to_pe_valid[0]          ),
        .o_dirty_feedback                   ( dirty_feedback[0]               ),
		.o_node_empty                       ( node_empty[0]                   )
    );
    
    pos_input_ring_node_ext pos_input_ring_node_ext (
        .clk                                ( clk                                       ),
        .rst                                ( rst                                       ), 
        .i_local_node_id                    ( local_node_id                             ),
        .i_source_offset_pkt                ( offset_pkt_link[NUM_CELLS-1]              ), 
        .i_source_gcid                      ( gcid_link[NUM_CELLS-1]                    ), 
        .i_source_node_id                   ( node_id_link[NUM_CELLS-1]                 ), 
        .i_source_lifetime                  ( lifetime_link[NUM_CELLS-1]                ),
        .i_source_lifetime_split_remote     ( lifetime_split_remote_link[NUM_CELLS-1]   ),
        .i_remote_offset_pkt                ( remote_offset_pkt                         ), 
        .i_remote_gcid                      ( remote_gcid                               ), 
        .i_remote_valid                     ( remote_valid                              ),
        .i_remote_lifetime                  ( remote_lifetime                           ),
        .i_remote_buffer_back_pressure      ( remote_buffer_back_pressure               ),
        
        .o_offset_pkt_to_ring               ( offset_pkt_ext                            ), 
        .o_gcid_to_ring                     ( gcid_ext                                  ), 
        .o_node_id_to_ring                  ( node_id_ext                               ), 
        .o_lifetime_to_ring                 ( lifetime_ext                              ), 
        .o_lifetime_split_remote_to_ring    ( lifetime_split_remote_ext                 ), 
        .o_offset_pkt_to_remote             ( offset_pkt_to_remote                      ),
	    .o_gcid_to_remote                   ( gcid_to_remote                            ), 
        .o_offset_pkt_to_remote_valid       ( offset_pkt_to_remote_valid                ),
        .o_lifetime_to_remote               ( lifetime_to_remote                        ),
		.o_node_empty                       ( node_empty[NUM_CELLS]                     ),
		.o_remote_ack                       ( remote_ack                                )
    );


endmodule