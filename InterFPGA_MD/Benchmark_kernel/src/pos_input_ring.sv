
import MD_pkg::*;

module pos_input_ring (
	input clk, 
	input rst, 
	input [NUM_CELLS-1:0]  [OFFSET_PKT_STRUCT_WIDTH-1:0]   local_offset_pkt, 				// from pos cache
	input [NUM_CELLS-1:0]  [3*GLOBAL_CELL_ID_WIDTH-1:0]    local_gcid, 
	input [NUM_CELLS-1:0]                                  local_valid, 
	input [NUM_CELLS-1:0]                                  local_dirty, 
	input [NUM_CELLS-1:0]                                  dispatcher_back_pressure, 
	
	output [NUM_CELLS-1:0] [POS_PKT_STRUCT_WIDTH-1:0]      pos_pkt_to_pe, 							// to PE
	output logic           [NUM_CELLS-1:0]                 pos_pkt_to_pe_valid,
	output logic           [NUM_CELLS-1:0]                 dirty_feedback
);

logic [NUM_CELLS-1:0]   [OFFSET_PKT_STRUCT_WIDTH-1:0]  offset_pkt_link;
logic [NUM_CELLS-1:0]   [3*GLOBAL_CELL_ID_WIDTH-1:0]   gcid_link;
logic [NUM_CELLS-1:0]   [NB_CELL_COUNT_WIDTH-1:0]      lifetime_link;

genvar i;
generate
	for (i = 0; i < NUM_CELLS; i++) begin: pos_input_ring_nodes
		pos_input_ring_node #(
			.GCELL_X                     ( {i / (Y_DIM * Z_DIM)}             ), 
			.GCELL_Y                     ( {i / Z_DIM % Y_DIM}               ), 
			.GCELL_Z                     ( {i % Z_DIM}                       )
		)
		pos_input_ring_node (
			.clk                         ( clk                                           ),
			.rst                         ( rst                                           ), 
			.i_source_offset_pkt         ( offset_pkt_link[(i+1)%NUM_CELLS]    ), 
			.i_source_gcid               ( gcid_link[(i+1)%NUM_CELLS]          ), 
			.i_source_lifetime           ( lifetime_link[(i+1)%NUM_CELLS]      ),
			.i_local_offset_pkt          ( local_offset_pkt[i]                           ), 
			.i_local_gcid                ( local_gcid[i]                                 ), 
			.i_local_valid               ( local_valid[i]                                ),
			.i_local_dirty               ( local_dirty[i]                                ),
			.i_dispatcher_back_pressure  ( dispatcher_back_pressure[i]                   ),
			
			.o_offset_pkt_to_ring        ( offset_pkt_link[i]                            ), 
			.o_gcid_to_ring              ( gcid_link[i]                                  ), 
			.o_lifetime_to_ring          ( lifetime_link[i]                              ), 
			.o_pos_pkt_to_pe             ( pos_pkt_to_pe[i]                              ), 
			.o_pos_pkt_to_pe_valid       ( pos_pkt_to_pe_valid[i]                        ),
			.o_dirty_feedback            ( dirty_feedback[i]                             )
		);
    end
endgenerate


endmodule