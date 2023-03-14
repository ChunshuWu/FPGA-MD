//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2022 09:06:00 PM
// Design Name: 
// Module Name: pos_input_ring_node
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

module pos_input_ring_node
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
	input                                      clk, 
	input                                      rst, 
	input [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_source_offset_pkt,
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_source_gcid, 				// from the previous node
	input [NB_CELL_COUNT_WIDTH-1:0]            i_source_lifetime, 	            // Used as valid
	
	input [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_local_offset_pkt, 						// from pos cache
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_local_gcid, 
	input                                      i_local_valid, 
	input                                      i_local_dirty,
	input                                      i_dispatcher_back_pressure,
	
	output [OFFSET_PKT_STRUCT_WIDTH-1:0]       o_offset_pkt_to_ring, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_gcid_to_ring, 		// to the next node
	output logic [NB_CELL_COUNT_WIDTH-1:0]     o_lifetime_to_ring, 
	
	output [POS_PKT_STRUCT_WIDTH-1:0]          o_pos_pkt_to_pe, 								// to PE
	output logic                               o_pos_pkt_to_pe_valid,
	output logic                               o_dirty_feedback
);

logic hit;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_x;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_y;
logic [GLOBAL_CELL_ID_WIDTH-1:0] gcid_z;

assign gcid_x = i_local_gcid[GLOBAL_CELL_ID_WIDTH-1:0];
assign gcid_y = i_local_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH];
assign gcid_z = i_local_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH];

check_pos_input_ring_target_hit #(
	.GCELL_X   ( GCELL_X   ), 
	.GCELL_Y   ( GCELL_Y   ), 
	.GCELL_Z   ( GCELL_Z   )
)
check_target_hit (
	.i_gcid    ( i_source_gcid ), 
	
	.o_hit     ( hit           )
);

logic [CELL_ID_WIDTH-1:0] cid_x;
logic [CELL_ID_WIDTH-1:0] cid_y;
logic [CELL_ID_WIDTH-1:0] cid_z;

compute_nb_cid #(
	.GCELL_X           ( GCELL_X   ), 
	.GCELL_Y           ( GCELL_Y   ), 
	.GCELL_Z           ( GCELL_Z   )
)
inst_compute_nb_cid (
	.i_source_gcid_x   ( i_source_gcid[GLOBAL_CELL_ID_WIDTH-1:0]                           ), 
	.i_source_gcid_y   ( i_source_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH]      ), 
	.i_source_gcid_z   ( i_source_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH]    ), 
	//.i_fold_id(fold_id), 
	
	.o_nb_cid_x        ( cid_x                                                             ), 
	.o_nb_cid_y        ( cid_y                                                             ), 
	.o_nb_cid_z        ( cid_z                                                             )
);

pos_input_node_router inst_pos_router (
    .clk                        ( clk                           ), 
    .rst                        ( rst                           ), 
    .i_hit                      ( hit                           ), 
    .i_local_offset_pkt         ( i_local_offset_pkt            ), 
    .i_local_gcid               ( i_local_gcid                  ), 
    .i_local_valid              ( i_local_valid                 ), 
    .i_local_dirty              ( i_local_dirty                 ),
    
    .i_dispatcher_back_pressure ( i_dispatcher_back_pressure    ), 
    
    .i_source_offset_pkt        ( i_source_offset_pkt           ), 
    .i_source_gcid              ( i_source_gcid                 ), 
    .i_source_lifetime          ( i_source_lifetime             ), 
    
    .i_cid_x                    ( cid_x                         ), 
    .i_cid_y                    ( cid_y                         ), 
    .i_cid_z                    ( cid_z                         ), 
    
    .o_offset_pkt_to_ring       ( o_offset_pkt_to_ring          ), 
    .o_gcid_to_ring             ( o_gcid_to_ring                ), 
    .o_lifetime_to_ring         ( o_lifetime_to_ring            ), 
    .o_pos_pkt_to_pe            ( o_pos_pkt_to_pe               ), 
    .o_pos_pkt_to_pe_valid      ( o_pos_pkt_to_pe_valid         ),
    .o_dirty_feedback           ( o_dirty_feedback              )
);

endmodule
