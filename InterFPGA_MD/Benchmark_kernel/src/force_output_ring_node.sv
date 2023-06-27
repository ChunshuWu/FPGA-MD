//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 02:39:53 AM
// Design Name: 
// Module Name: force_output_ring_node
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

module force_output_ring_node
#(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
	input clk, 
	input rst, 
	input [FRC_PKT_STRUCT_WIDTH-1:0] i_nb_force, // f, parid, cid, from PE
	input [NODE_ID_WIDTH-1:0] i_node_id,
	input i_nb_force_valid,  
	
	input [FLOAT_STRUCT_WIDTH-1:0] i_source_nb_force, 					// from the prev node
	input [PARTICLE_ID_WIDTH-1:0] i_source_nb_parid, 
	input [3*GLOBAL_CELL_ID_WIDTH-1:0] i_source_nb_gcid, 
	input [NODE_ID_WIDTH-1:0] i_source_node_id,
	input i_source_nb_valid, 
	
	output logic [FLOAT_STRUCT_WIDTH-1:0] o_dest_nb_force, 						// to the next node
	output logic [PARTICLE_ID_WIDTH-1:0] o_dest_nb_parid, 
	output logic [3*GLOBAL_CELL_ID_WIDTH-1:0] o_dest_nb_gcid, 
	output logic [NODE_ID_WIDTH-1:0] o_dest_node_id,
	output logic o_dest_nb_valid, 
	
	output logic [FLOAT_STRUCT_WIDTH-1:0] o_nb_force_to_force_cache, 
	output logic o_nb_force_to_force_cache_valid, 
	output logic [PARTICLE_ID_WIDTH-1:0] o_nb_parid_to_force_cache,
	
	output logic o_buffer_full,
	output o_buffer_empty 										// System control
);

// buffer signals
logic buffer_wr_en;
logic buffer_rdreq;
logic [NODE_ID_WIDTH-1:0] buffer_node_id;
force_packet_t buffer_nb_force;
logic tmp_buffer_nb_force_valid;
logic buffer_nb_force_valid;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] buffer_nb_force_gcid;
//logic [CELL_FOLD_ID_WIDTH-1:0] buffer_nb_fold_id;
logic buffer_data_expired;

assign buffer_wr_en = i_nb_force_valid & i_nb_force[30:23] > 0 & i_nb_force[62:55] > 0 & i_nb_force[94:87] > 0;

cid_to_gcid
#(
	.GCELL_X(GCELL_X), 
	.GCELL_Y(GCELL_Y), 
	.GCELL_Z(GCELL_Z)
)
cid_to_gcid
(
	.i_cid(buffer_nb_force[FLOAT_STRUCT_WIDTH+PARTICLE_ID_WIDTH +: 3*CELL_ID_WIDTH]),
//	.i_fold_id(buffer_nb_fold_id), 
	
	.o_gcid(buffer_nb_force_gcid)
);

FORCE_OUTPUT_RING_BUF inst_FRC_OUTPUT_RING_BUF (
    .clk(clk), 
    .rst(rst), 
    .wr_data({i_node_id, i_nb_force, i_nb_force_valid}), 
    .wr_en(buffer_wr_en), 
    .rd_en(buffer_rdreq), 
    
    .empty(o_buffer_empty), 
    .almost_full(o_buffer_full), 
    .data_out({buffer_node_id, buffer_nb_force, tmp_buffer_nb_force_valid})
);

logic [GLOBAL_CELL_ID_WIDTH-1:0] local_gcid_x;
logic [GLOBAL_CELL_ID_WIDTH-1:0] local_gcid_y;
logic [GLOBAL_CELL_ID_WIDTH-1:0] local_gcid_z;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] local_gcid;
assign local_gcid_z = GCELL_Z[0];
assign local_gcid_y = GCELL_Y[0];
assign local_gcid_x = GCELL_X[0];
assign local_gcid = {local_gcid_z, local_gcid_y, local_gcid_x};
assign buffer_nb_force_valid = tmp_buffer_nb_force_valid & (~o_buffer_empty);

always@(*)
	begin
	if (i_source_nb_valid)
		begin
		if(i_source_nb_gcid == local_gcid)
			begin
			if (buffer_nb_force_valid && ~buffer_data_expired)		// Data usable
				begin
				if (buffer_nb_force_gcid == local_gcid)		// Can't pass the buffer data to local because source data is being passed
					begin
					buffer_rdreq = 1'b0;
					end
				else						// Send to the next node, and read the next if not empty
					begin
					if (o_buffer_empty)
						begin
						buffer_rdreq = 1'b0;
						end
					else
						begin
						buffer_rdreq = 1'b1;
						end
					end
				end
			else						// Data not usable, read the next if not empty
				begin
				if (o_buffer_empty)
					begin
					buffer_rdreq = 1'b0;
					end
				else
					begin
					buffer_rdreq = 1'b1;
					end
				end
			end
		else				// Prev node data is to be sent to the next node
			begin
			if (buffer_nb_force_valid && ~buffer_data_expired)		// Data usable
				begin
				if (buffer_nb_force_gcid == local_gcid)		// Can pass the buffer data to local
					begin
					if (o_buffer_empty)
						begin
						buffer_rdreq = 1'b0;
						end
					else
						begin
						buffer_rdreq = 1'b1;
						end
					end
				else
					begin
					buffer_rdreq = 1'b0;
					end
				end
			else
				begin
				if (o_buffer_empty)
					begin
					buffer_rdreq = 1'b0;
					end
				else
					begin
					buffer_rdreq = 1'b1;
					end
				end
			end
		end
	else				// Read if not empty, no matter whether the current data is usable or not: Either discarded or used
		begin
		if (o_buffer_empty)
			begin
			buffer_rdreq = 1'b0;
			end
		else
			begin
			buffer_rdreq = 1'b1;				// Initiate the first read
			end
		end
	end

always@(posedge clk)
	begin
	if (rst)
		begin
		o_dest_nb_force <= 0;
		o_dest_nb_parid <= 0;
		o_dest_nb_gcid <= 0;
		o_dest_node_id <= 0;
		o_dest_nb_valid <= 0;
		
		o_nb_force_to_force_cache <= 0;
		o_nb_force_to_force_cache_valid <= 0;
		o_nb_parid_to_force_cache <= 0;
		
		buffer_data_expired <= 1'b0;
		end
	else
		begin
		if (i_source_nb_valid)
			begin
			if (i_source_nb_gcid == local_gcid)			// data from prev node to local force cache
				begin
				o_nb_force_to_force_cache <= i_source_nb_force;
				o_nb_force_to_force_cache_valid <= 1'b1;
				o_nb_parid_to_force_cache <= i_source_nb_parid;
				if (buffer_nb_force_valid && ~buffer_data_expired)	// The data persists after being used, so use expired flag to label
					begin
					if (buffer_nb_force_gcid == local_gcid)		// Buffer data on hold, no new data reading from the buffer
						begin
						buffer_data_expired <= 1'b0;
						o_dest_nb_valid <= 1'b0;
						end
					else											// send the data from buffer to the next node
						begin
						o_dest_nb_force <= buffer_nb_force[FLOAT_STRUCT_WIDTH-1:0];
						o_dest_nb_parid <= buffer_nb_force[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH];
						o_dest_nb_gcid <= buffer_nb_force_gcid;
						o_dest_node_id <= buffer_node_id;
						o_dest_nb_valid <= 1'b1;
						if (o_buffer_empty)
							begin
							buffer_data_expired <= 1'b1;				// buffer_data_expired is set only when the buffer is empty
							end
						else
							begin
							buffer_data_expired <= 1'b0;
							end
						end
					end
				else				// The buffer data is not usable
					begin
					if (~o_buffer_empty)		// If not empty, the new data will come out at the next cycle
						begin
						buffer_data_expired <= 1'b0;
						end
					o_dest_nb_valid <= 1'b0;
					end
				end
			else													// data from prev node to the next node
				begin
				o_dest_nb_force <= i_source_nb_force;
				o_dest_nb_parid <= i_source_nb_parid;
				o_dest_nb_gcid <= i_source_nb_gcid;
				o_dest_node_id <= i_source_node_id;
				o_dest_nb_valid <= 1'b1;
				if (buffer_nb_force_valid && ~buffer_data_expired)		// Buffer data usable
					begin
					if (buffer_nb_force_gcid == local_gcid)		// send the data from buffer to the local force cache
						begin
						o_nb_force_to_force_cache <= buffer_nb_force[FLOAT_STRUCT_WIDTH-1:0];
						o_nb_parid_to_force_cache <= buffer_nb_force[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH];
						o_nb_force_to_force_cache_valid <= 1'b1;
						if (o_buffer_empty)
							begin
							buffer_data_expired <= 1'b1;
							end
						else
							begin
							buffer_data_expired <= 1'b0;
							end
						end
					else											// put the filter pipeline in the PE on hold
						begin
						buffer_data_expired <= 1'b0;
						o_nb_force_to_force_cache_valid <= 1'b0;
						end
					end
				else			// Buffer data not usable
					begin
					if (~o_buffer_empty)
						begin
						buffer_data_expired <= 1'b0;
						end
					o_nb_force_to_force_cache_valid <= 1'b0;
					end
				end
			end
		else
			begin
			if (buffer_nb_force_valid && ~buffer_data_expired)
				begin
				if (o_buffer_empty)
					begin
					buffer_data_expired <= 1'b1;
					end
				else
					begin
					buffer_data_expired <= 1'b0;
					end
				if (buffer_nb_force_gcid == local_gcid)
					begin
					o_nb_force_to_force_cache <= buffer_nb_force[FLOAT_STRUCT_WIDTH-1:0];
					o_nb_parid_to_force_cache <= buffer_nb_force[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH];
					o_nb_force_to_force_cache_valid <= 1'b1;
					o_dest_nb_valid <= 1'b0;
					end
				else
					begin
					o_dest_nb_force <= buffer_nb_force[FLOAT_STRUCT_WIDTH-1:0];
					o_dest_nb_parid <= buffer_nb_force[FLOAT_STRUCT_WIDTH +: PARTICLE_ID_WIDTH];
					o_dest_nb_gcid <= buffer_nb_force_gcid;
					o_dest_node_id <= buffer_node_id;
					o_dest_nb_valid <= 1'b1;
					o_nb_force_to_force_cache_valid <= 1'b0;
					end
				end
			else
				begin
				if (~o_buffer_empty)
					begin
					buffer_data_expired <= 1'b0;
					end
				o_dest_nb_valid <= 1'b0;
				o_nb_force_to_force_cache_valid <= 1'b0;
				end
			end
		end
	end


endmodule
