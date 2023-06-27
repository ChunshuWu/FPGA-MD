`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2023 12:43:52 PM
// Design Name: 
// Module Name: pos_input_ring_node_ext
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

module pos_input_ring_node_ext
(
	input                                      clk, 
	input                                      rst, 
	input [NODE_ID_WIDTH-1:0]                  i_local_node_id,
	
	input [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_source_offset_pkt,
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_source_gcid, 				// from the previous node
	input [NODE_ID_WIDTH-1:0]                  i_source_node_id,   // Redundant, place holder in case there exists more ext nodes
	input [NB_CELL_COUNT_WIDTH-1:0]            i_source_lifetime, 	            // Used as valid
	input [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]  i_source_lifetime_split_remote,     // The number of lifetime to be consumed remotely
	
	input [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_remote_offset_pkt, 						// from remote
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_remote_gcid, 
	input                                      i_remote_valid, 
	input [NB_CELL_COUNT_WIDTH-1:0]            i_remote_lifetime,
	input                                      i_remote_buffer_back_pressure,
	
	output logic [OFFSET_PKT_STRUCT_WIDTH-1:0] o_offset_pkt_to_ring, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_gcid_to_ring, 		// to the next node
	output logic [NODE_ID_WIDTH-1:0]           o_node_id_to_ring,
	output logic [NB_CELL_COUNT_WIDTH-1:0]     o_lifetime_to_ring, 
	output logic [(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:0]   o_lifetime_split_remote_to_ring,
	
	output logic [OFFSET_PKT_STRUCT_WIDTH-1:0] o_offset_pkt_to_remote, 								// to remote
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_gcid_to_remote, 
	output logic                               o_offset_pkt_to_remote_valid, 
	output logic [NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0]   o_lifetime_to_remote,
	output logic                               o_remote_ack,                         // tell remote pos controller the remote data is received
	output logic                               o_node_empty
);

assign o_node_empty = (i_source_lifetime == 0);
assign o_remote_ack = o_node_empty & i_remote_valid;

logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  remote_gcid;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  gcid_to_remote;
logic [NODE_ID_WIDTH-1:0]           remote_node_id;

assign remote_node_id[2] = i_remote_gcid[GLOBAL_CELL_ID_WIDTH-1:0] < X_DIM ? 1'b0 : 1'b1;
assign remote_node_id[1] = i_remote_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] < Y_DIM ? 1'b0 : 1'b1;
assign remote_node_id[0] = i_remote_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] < Z_DIM ? 1'b0 : 1'b1;

// The conversion may subject to changes for a larger scale
logic [2:0][GLOBAL_CELL_ID_WIDTH-1:0] dim;
assign dim[0] = X_DIM;
assign dim[1] = Y_DIM;
assign dim[2] = Z_DIM;

genvar i;
generate
    for (i = 0; i < 3; i++) begin: remote_gcid_conversion                       // hard-coded to up to 8x nodes
        always@(*) begin
            if (i_local_node_id[2-i] == 1 && remote_node_id[2-i] == 1) begin       // norm 345 to 012
                remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] - dim[i];
            end
            else if (i_local_node_id[2-i] <= remote_node_id[2-i]) begin            // no need to norm
                remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH];
            end
            else begin                                 // If local ID > remote ID, norm 012 to 345
                remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] + dim[i];
            end
        end
    end
endgenerate


// GCID conversion based on the difference between node IDs
//assign remote_gcid[GLOBAL_CELL_ID_WIDTH-1:0] = 
//                                        (i_local_node_id[2] > remote_node_id[2]) ? 
//                                         i_remote_gcid[GLOBAL_CELL_ID_WIDTH-1:0] + X_DIM : 
//                                         i_remote_gcid[GLOBAL_CELL_ID_WIDTH-1:0];
//assign remote_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] = 
//                                        (i_local_node_id[1] > remote_node_id[1]) ? 
//                                         i_remote_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] + Y_DIM : 
//                                         i_remote_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH];
//assign remote_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] = 
//                                        (i_local_node_id[0] > remote_node_id[0]) ? 
//                                         i_remote_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] + Z_DIM : 
//                                         i_remote_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH];


assign gcid_to_remote[GLOBAL_CELL_ID_WIDTH-1:0] = 
                                        i_local_node_id[2] ? 
                                        i_source_gcid[GLOBAL_CELL_ID_WIDTH-1:0] + X_DIM :
                                        i_source_gcid[GLOBAL_CELL_ID_WIDTH-1:0];
assign gcid_to_remote[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] = 
                                        i_local_node_id[1] ? 
                                        i_source_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] + Y_DIM :
                                        i_source_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH];
assign gcid_to_remote[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] = 
                                        i_local_node_id[0] ? 
                                        i_source_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] + Z_DIM :
                                        i_source_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH];

always@(posedge clk)
	begin
	if (rst)
		begin
		o_offset_pkt_to_ring              <= 0;					// to ring
		o_gcid_to_ring                    <= 0;
		o_node_id_to_ring                 <= 0;
		o_lifetime_to_ring                <= 0;
//		o_lifetime_split_remote_to_ring_all   <= 0;                 // always 0 unless backpressure
		o_lifetime_split_remote_to_ring   <= 0;
		o_offset_pkt_to_remote            <= 0; 				// to remote
		o_gcid_to_remote                  <= 0;
		o_offset_pkt_to_remote_valid      <= 1'b0; 
		o_lifetime_to_remote              <= 0;
		end
	else
		begin
		if (i_source_lifetime > 0) begin	// Ring propagation 
			o_offset_pkt_to_ring         <= i_source_offset_pkt;
			o_gcid_to_ring               <= i_source_gcid;
			o_node_id_to_ring            <= i_source_node_id;
			if (i_source_lifetime_split_remote[(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:
			                                    NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH] > 0 && ~i_remote_buffer_back_pressure) begin
				o_lifetime_to_ring                  <= i_source_lifetime - i_source_lifetime_split_remote[(NUM_REMOTE_DEST_NODES+1)*NB_CELL_COUNT_WIDTH-1:
			                                                                                               NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH];
				o_lifetime_split_remote_to_ring     <= 0;
				o_offset_pkt_to_remote              <= i_source_offset_pkt;
				o_gcid_to_remote                    <= gcid_to_remote;
				o_offset_pkt_to_remote_valid        <= 1'b1;
				o_lifetime_to_remote                <= i_source_lifetime_split_remote[NUM_REMOTE_DEST_NODES*NB_CELL_COUNT_WIDTH-1:0];
				end
			else begin   // no remote output involved, or remote output buffer back pressure, keep spinning
				o_lifetime_to_ring                  <= i_source_lifetime;
				o_lifetime_split_remote_to_ring     <= i_source_lifetime_split_remote;
				o_offset_pkt_to_remote              <= 0;
				o_gcid_to_remote                    <= 0;
				o_offset_pkt_to_remote_valid        <= 1'b0;
				o_lifetime_to_remote                <= 0;
				end
			end
		else begin		// Add fresh data from remote input buffer to the ring 
			if (i_remote_valid) begin
				o_offset_pkt_to_ring            <= i_remote_offset_pkt;	// Send to both pe and the next node
				o_gcid_to_ring                  <= remote_gcid;
				o_node_id_to_ring               <= remote_node_id;
				o_lifetime_to_ring              <= i_remote_lifetime;
				o_lifetime_split_remote_to_ring <= 0;
				o_offset_pkt_to_remote          <= 0;
				o_gcid_to_remote                <= 0;
				o_offset_pkt_to_remote_valid    <= 1'b0;
				o_lifetime_to_remote            <= 0;
				end
			else begin   // No incoming data, all 0s
				o_offset_pkt_to_ring            <= 0;
				o_gcid_to_ring                  <= 0;
				o_node_id_to_ring               <= 0;
				o_lifetime_to_ring              <= 0;
				o_lifetime_split_remote_to_ring <= 0;
				o_offset_pkt_to_remote          <= 0;
				o_gcid_to_remote                <= 0;
				o_offset_pkt_to_remote_valid    <= 1'b0;
				o_lifetime_to_remote            <= 0;
				end
			end
		end
	end
	
endmodule