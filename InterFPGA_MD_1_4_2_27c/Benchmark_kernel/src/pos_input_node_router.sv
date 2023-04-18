//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 01:28:24 AM
// Design Name: 
// Module Name: pos_input_node_router
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

module pos_input_node_router
(
    input                                       clk, 
    input                                       rst, 
    input                                       i_hit, 
    input                                       i_dispatcher_back_pressure, 
    input [OFFSET_PKT_STRUCT_WIDTH-1:0]         i_source_offset_pkt, 
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]          i_source_gcid, 
    input [NB_CELL_COUNT_WIDTH-1:0]             i_source_lifetime, 
    input [OFFSET_PKT_STRUCT_WIDTH-1:0]         i_local_offset_pkt, 
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]          i_local_gcid, 
    input                                       i_local_valid, 
    input                                       i_local_dirty, 
	input [CELL_ID_WIDTH-1:0]                   i_cid_x,
	input [CELL_ID_WIDTH-1:0]                   i_cid_y,
	input [CELL_ID_WIDTH-1:0]                   i_cid_z, 
    
    
    output offset_packet_t                      o_offset_pkt_to_ring, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]   o_gcid_to_ring, 
	output logic [NB_CELL_COUNT_WIDTH-1:0]      o_lifetime_to_ring, 
	output pos_packet_t                         o_pos_pkt_to_pe, 
	output logic                                o_pos_pkt_to_pe_valid,
	output logic                                o_dirty_feedback
);
	
always@(posedge clk)
	begin
	if (rst)
		begin
		o_offset_pkt_to_ring          <= 0;					// to ring
		o_gcid_to_ring                <= 0;
		o_lifetime_to_ring            <= 0;
		o_pos_pkt_to_pe               <= 0; 				// to PE
		o_pos_pkt_to_pe_valid         <= 1'b0; 
		o_dirty_feedback              <= 1'b0;
		end
	else
		begin
		if (i_source_lifetime > 0)	// Ring propagation
			begin
			o_offset_pkt_to_ring         <= i_source_offset_pkt;
			o_gcid_to_ring               <= i_source_gcid;
		    o_dirty_feedback             <= 1'b0;
			if (i_hit)
				begin
				o_lifetime_to_ring          <= i_source_lifetime - 1'b1;
				o_pos_pkt_to_pe[POS_STRUCT_WIDTH +: ELEMENT_WIDTH]                      <= i_source_offset_pkt[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH];
				o_pos_pkt_to_pe[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]    <= i_source_offset_pkt[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH];
				o_pos_pkt_to_pe[DATA_WIDTH-1:0]                                         <= {i_cid_x, i_source_offset_pkt[OFFSET_WIDTH-1:0]};
				o_pos_pkt_to_pe[2*DATA_WIDTH-1:DATA_WIDTH]                              <= {i_cid_y, i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH]};
				o_pos_pkt_to_pe[3*DATA_WIDTH-1:2*DATA_WIDTH]                            <= {i_cid_z, i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]};
				o_pos_pkt_to_pe_valid       <= 1'b1;
				end
			else
				begin
				o_lifetime_to_ring          <= i_source_lifetime;
				o_pos_pkt_to_pe_valid       <= 1'b0;
				end
			end
		else		// Add fresh data from pos cache to the ring
			begin
			if (~i_local_dirty & i_local_valid & ~i_dispatcher_back_pressure)     // If preload, nb data are not getting through, so no valid pairs
				begin
				o_offset_pkt_to_ring        <= i_local_offset_pkt;	// Send to both pe and the next node
				o_gcid_to_ring              <= i_local_gcid;
				o_lifetime_to_ring          <= NUM_DEST_CELLS-1;
		        o_dirty_feedback            <= 1'b1;
				o_pos_pkt_to_pe[POS_STRUCT_WIDTH +: ELEMENT_WIDTH]                      <= i_local_offset_pkt[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH];
				o_pos_pkt_to_pe[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]    <= i_local_offset_pkt[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH];
				o_pos_pkt_to_pe[DATA_WIDTH-1:0]                                         <= {CELL_2, i_local_offset_pkt[OFFSET_WIDTH-1:0]};
				o_pos_pkt_to_pe[2*DATA_WIDTH-1:DATA_WIDTH]                              <= {CELL_2, i_local_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH]};
				o_pos_pkt_to_pe[3*DATA_WIDTH-1:2*DATA_WIDTH]                            <= {CELL_2, i_local_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]};
				o_pos_pkt_to_pe_valid       <= 1'b1;
				end
			else
				begin
				o_lifetime_to_ring          <= 0;
		        o_dirty_feedback            <= 1'b0;
				o_pos_pkt_to_pe_valid       <= 1'b0;
				end
			end
		end
	end
	
endmodule
