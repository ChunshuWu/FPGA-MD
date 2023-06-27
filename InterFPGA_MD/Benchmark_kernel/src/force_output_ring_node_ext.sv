`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2023 01:55:45 PM
// Design Name: 
// Module Name: force_output_ring_node_ext
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

module force_output_ring_node_ext (
	input                                      clk, 
	input                                      rst, 
	input [FLOAT_STRUCT_WIDTH-1:0]             i_remote_force,
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_remote_gcid,
	input [PARTICLE_ID_WIDTH-1:0]              i_remote_parid,
	input                                      i_remote_force_valid, 
	input                                      i_remote_buffer_back_pressure,
	input [FLOAT_STRUCT_WIDTH-1:0]             i_source_nb_force, 					// from the prev node
	input [PARTICLE_ID_WIDTH-1:0]              i_source_nb_parid, 
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_source_nb_gcid, 
	input [NODE_ID_WIDTH-1:0]                  i_source_node_id, 
	input                                      i_source_nb_valid, 
	input [NODE_ID_WIDTH-1:0]                  i_local_node_id,
	
	output logic [FLOAT_STRUCT_WIDTH-1:0]      o_dest_nb_force, 						// to the next node
	output logic [PARTICLE_ID_WIDTH-1:0]       o_dest_nb_parid, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_dest_nb_gcid, 
	output logic [NODE_ID_WIDTH-1:0]           o_dest_node_id, 
	output logic                               o_dest_nb_valid, 
	
	output logic [FLOAT_STRUCT_WIDTH-1:0]      o_nb_force_to_remote, 
	output logic                               o_nb_force_to_remote_valid, 
	output logic [PARTICLE_ID_WIDTH-1:0]       o_nb_parid_to_remote, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0]  o_nb_gcid_to_remote,
	output logic [NUM_REMOTE_DEST_NODES-1:0]   o_nb_ticket_onehot,     // The ticket outta here, find the departure gate with the ticket
	output logic                               o_remote_ack
//	output logic                               o_debug_node_id_error
);

logic [2:0] node_id_diff;       // hard coded for x-z, 4 boards
assign node_id_diff = {i_source_node_id[2]-i_local_node_id[2],
                       i_source_node_id[1]-i_local_node_id[1],
                       i_source_node_id[0]-i_local_node_id[0]};
                       
logic [NUM_REMOTE_DEST_NODES:0] dest_onehot;
assign o_nb_ticket_onehot = dest_onehot[NUM_REMOTE_DEST_NODES:1];   // 0001 means local frc

assign o_remote_ack = (i_source_nb_valid & i_local_node_id != i_source_node_id & ~i_remote_buffer_back_pressure) | 
                      (~i_source_nb_valid) & i_remote_force_valid;

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

// Frc is not the same as Pos, for the returning node id is just the local node id, otherwise error. 
//assign o_debug_node_id_error = i_remote_force_valid & (remote_node_id != i_local_node_id);

genvar i;
generate
    for (i = 0; i < 3; i++) begin: remote_gcid_conversion                       // hard-coded to up to 8x nodes
        always@(*) begin
            if (i_local_node_id[2-i] == 1) begin                                     // norm 345 to 012
                remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] - dim[i];
            end
            else begin                                                          // no need to norm
                remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_remote_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH];
            end
        end
    end
endgenerate

// Reverse process with respect to pos remote gcid conversion
generate
    for (i = 0; i < 3; i++) begin: gcid_to_remote_conversion                       // hard-coded to up to 8x nodes
        always@(*) begin
            if (i_local_node_id[2-i] == 1 && i_source_node_id[2-i] == 1) begin     // norm 345 to 012
                gcid_to_remote[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_source_nb_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] + dim[i];
            end
            else if (i_local_node_id[2-i] <= i_source_node_id[2-i]) begin            // no need to norm
                gcid_to_remote[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_source_nb_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH];
            end
            else begin                                 // If local ID > remote ID, norm 012 to 345
                gcid_to_remote[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] 
                = i_source_nb_gcid[(i+1)*GLOBAL_CELL_ID_WIDTH-1:i*GLOBAL_CELL_ID_WIDTH] - dim[i];
            end
        end
    end
endgenerate

//assign gcid_to_remote[GLOBAL_CELL_ID_WIDTH-1:0] = 
//                                        i_source_node_id[2] ? 
//                                        i_source_nb_gcid[GLOBAL_CELL_ID_WIDTH-1:0] + X_DIM :
//                                        i_source_nb_gcid[GLOBAL_CELL_ID_WIDTH-1:0];
//assign gcid_to_remote[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] = 
//                                        i_source_node_id[1] ? 
//                                        i_source_nb_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH] + Y_DIM :
//                                        i_source_nb_gcid[2*GLOBAL_CELL_ID_WIDTH-1:GLOBAL_CELL_ID_WIDTH];
//assign gcid_to_remote[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] = 
//                                        i_source_node_id[0] ? 
//                                        i_source_nb_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH] + Z_DIM :
//                                        i_source_nb_gcid[3*GLOBAL_CELL_ID_WIDTH-1:2*GLOBAL_CELL_ID_WIDTH];

always@(posedge clk) begin
	if (rst) begin
		o_dest_nb_force                       <= 0;					// to ring
		o_dest_nb_parid                       <= 0;
		o_dest_nb_gcid                        <= 0;
		o_dest_node_id                        <= 0;
		o_dest_nb_valid                       <= 0;                 // always 0 unless backpressure
		o_nb_force_to_remote                  <= 0; 				// to remote
		o_nb_force_to_remote_valid            <= 1'b0; 
		o_nb_parid_to_remote                  <= 0;
		o_nb_gcid_to_remote                   <= 0;
		dest_onehot                           <= 0;
    end
	else begin
        dest_onehot                             <= 1 << node_id_diff;   // if 00000001, meaning local frc. 
		if (i_source_nb_valid) begin	// Ring propagation 
			if (i_local_node_id != i_source_node_id && ~i_remote_buffer_back_pressure) begin     // Send to remote
				o_nb_force_to_remote            <= i_source_nb_force;
				o_nb_force_to_remote_valid      <= 1'b1;
				o_nb_parid_to_remote            <= i_source_nb_parid;
				o_nb_gcid_to_remote             <= gcid_to_remote;
				if (i_remote_force_valid & i_remote_parid > 0) begin    // There may be dummy forces with parid == 0, exclude them.
                    o_dest_nb_force             <= i_remote_force;
                    o_dest_nb_parid             <= i_remote_parid;
                    o_dest_nb_gcid              <= remote_gcid;
                    o_dest_node_id              <= remote_node_id;
                    o_dest_nb_valid             <= i_remote_force_valid;
				end
				else begin
                    o_dest_nb_force             <= 0;
                    o_dest_nb_parid             <= 0;
                    o_dest_nb_gcid              <= 0;
                    o_dest_node_id              <= 0;
                    o_dest_nb_valid             <= 0;
				end
			end
			else begin   // no remote output involved, or remote output buffer back pressure, keep spinning
				o_nb_force_to_remote            <= 0;
				o_nb_force_to_remote_valid      <= 1'b0;
				o_nb_parid_to_remote            <= 0;
				o_nb_gcid_to_remote             <= 0;
				o_dest_nb_force                 <= i_source_nb_force;
				o_dest_nb_parid                 <= i_source_nb_parid;
				o_dest_nb_gcid                  <= i_source_nb_gcid;
				o_dest_node_id                  <= i_source_node_id;
				o_dest_nb_valid                 <= i_source_nb_valid;
			end
		end
		else begin		// Add fresh data from remote input buffer to the ring 
            o_nb_force_to_remote                <= 0;
            o_nb_force_to_remote_valid          <= 1'b0; 
            o_nb_parid_to_remote                <= 0;
            o_nb_gcid_to_remote                 <= 0;
			if (i_remote_force_valid & i_remote_parid > 0) begin    // There may be dummy forces with parid == 0, exclude them.
                o_dest_nb_force                 <= i_remote_force;
                o_dest_nb_parid                 <= i_remote_parid;
                o_dest_nb_gcid                  <= remote_gcid;
                o_dest_node_id                  <= remote_node_id;
                o_dest_nb_valid                 <= i_remote_force_valid;
			end
			else begin   // No incoming data, all 0s
                o_dest_nb_force                 <= 0;
                o_dest_nb_parid                 <= 0;
                o_dest_nb_gcid                  <= 0;
                o_dest_node_id                  <= 0;
                o_dest_nb_valid                 <= 0;
			end
		end
	end
end


endmodule