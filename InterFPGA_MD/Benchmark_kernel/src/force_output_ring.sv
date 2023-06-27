//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2022 03:59:59 AM
// Design Name: 
// Module Name: force_output_ring
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

module force_output_ring
(
	input                                                  clk, 
	input                                                  rst, 
	input [NUM_CELLS-1:0][FRC_PKT_STRUCT_WIDTH-1:0]        i_nb_force, 		// from PE
	input [NUM_CELLS-1:0][NODE_ID_WIDTH-1:0]               i_node_id,
	input [NUM_CELLS-1:0]                                  i_nb_force_valid, 
	input                [NODE_ID_WIDTH-1:0]               i_local_node_id,
	
	input [FLOAT_STRUCT_WIDTH-1:0]                         i_remote_force, // from remote
	input [3*GLOBAL_CELL_ID_WIDTH-1:0]                     i_remote_gcid,
	input [PARTICLE_ID_WIDTH-1:0]                          i_remote_parid,
	input                                                  i_remote_force_valid, 
	input                                                  i_remote_buffer_back_pressure,
	
	output [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]         o_nb_force_to_force_cache,      // to force caches
	output logic [NUM_CELLS-1:0]                           o_nb_force_to_force_cache_valid, 
	output logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    o_nb_parid_to_force_cache, 
	
	output [NUM_CELLS-1:0]                                 o_force_output_ring_buf_full,
	output [NUM_CELLS-1:0]                                 o_force_output_ring_buf_empty, // system signals
	output [NUM_CELLS-1:0]                                 o_nb_valid_ring,
	output                                                 o_nb_valid_ext,
	
	output [FLOAT_STRUCT_WIDTH-1:0]                        o_force_to_remote,          // to remote
	output                                                 o_force_to_remote_valid, 
	output [PARTICLE_ID_WIDTH-1:0]                         o_parid_to_remote, 
	output [3*GLOBAL_CELL_ID_WIDTH-1:0]                    o_gcid_to_remote,
	output [NUM_REMOTE_DEST_NODES-1:0]                     o_nb_ticket_onehot,
	output                                                 o_remote_ack
);

logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0] nb_force_ring; 					// from the prev node
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0] nb_parid_ring;
logic [NUM_CELLS-1:0][3*GLOBAL_CELL_ID_WIDTH-1:0] nb_gcid_ring;
logic [NUM_CELLS-1:0][NODE_ID_WIDTH-1:0] node_id_ring;
//logic [NUM_CELLS-1:0][CELL_FOLD_ID_WIDTH-1:0] nb_fold_id_ring;

logic [FLOAT_STRUCT_WIDTH-1:0] nb_force_ext;
logic [PARTICLE_ID_WIDTH-1:0] nb_parid_ext;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] nb_gcid_ext;
logic [NODE_ID_WIDTH-1:0] node_id_ext;

//always@(posedge clk) begin
//    if (rst) begin
//        o_debug_wrong_gcid <= 0;
//    end
//    else begin
//        if (o_nb_valid_ext) begin
//            o_debug_wrong_gcid <= nb_gcid_ext;
//        end
//    end
//end

genvar i;
generate
	for (i = 0; i < NUM_CELLS-1; i++) begin: force_output_ring_nodes
		force_output_ring_node #(
			.GCELL_X ( {i / (Y_DIM * Z_DIM)} ), 
			.GCELL_Y ( {i / Z_DIM % Y_DIM}   ), 
			.GCELL_Z ( {i % Z_DIM}           )
		)
		force_output_ring_node (
			.clk                             ( clk                                   ),
			.rst                             ( rst                                   ), 
			.i_nb_force                      ( i_nb_force[i]                         ), 
			.i_node_id                       ( i_node_id[i]                          ),
			.i_nb_force_valid                ( i_nb_force_valid[i]                   ), 
			.i_source_nb_force               ( nb_force_ring[i+1]                    ), 
			.i_source_nb_parid               ( nb_parid_ring[i+1]                    ), 
			.i_source_nb_gcid                ( nb_gcid_ring[i+1]                     ), 
			.i_source_node_id                ( node_id_ring[i+1]                     ),
			.i_source_nb_valid               ( o_nb_valid_ring[i+1]                  ), 
			
			.o_dest_nb_force                 ( nb_force_ring[i]                      ), 
			.o_dest_nb_parid                 ( nb_parid_ring[i]                      ), 
			.o_dest_nb_gcid                  ( nb_gcid_ring[i]                       ), 
			.o_dest_node_id                  ( node_id_ring[i]                       ),
			.o_dest_nb_valid                 ( o_nb_valid_ring[i]                    ), 
			.o_nb_force_to_force_cache       ( o_nb_force_to_force_cache[i]          ), 
			.o_nb_force_to_force_cache_valid ( o_nb_force_to_force_cache_valid[i]    ), 
			.o_nb_parid_to_force_cache       ( o_nb_parid_to_force_cache[i]          ), 
			
			.o_buffer_full                   ( o_force_output_ring_buf_full[i]    ),
			.o_buffer_empty                  ( o_force_output_ring_buf_empty[i]      )
		);
	end
endgenerate

    force_output_ring_node #(
        .GCELL_X                         ( {(NUM_CELLS-1) / (Y_DIM * Z_DIM)}     ), 
        .GCELL_Y                         ( {(NUM_CELLS-1) / Z_DIM % Y_DIM}       ), 
        .GCELL_Z                         ( {(NUM_CELLS-1) % Z_DIM}               )
    ) force_output_ring_node_n (
        .clk                             ( clk                                   ),
        .rst                             ( rst                                   ), 
        .i_nb_force                      ( i_nb_force[NUM_CELLS-1]               ), 
        .i_node_id                       ( i_node_id[NUM_CELLS-1]                ),
        .i_nb_force_valid                ( i_nb_force_valid[NUM_CELLS-1]         ), 
        .i_source_nb_force               ( nb_force_ext                          ), 
        .i_source_nb_parid               ( nb_parid_ext                          ), 
        .i_source_nb_gcid                ( nb_gcid_ext                           ), 
        .i_source_node_id                ( node_id_ext                           ),
        .i_source_nb_valid               ( o_nb_valid_ext                        ), 
        
        .o_dest_nb_force                 ( nb_force_ring[NUM_CELLS-1]                      ), 
        .o_dest_nb_parid                 ( nb_parid_ring[NUM_CELLS-1]                      ), 
        .o_dest_nb_gcid                  ( nb_gcid_ring[NUM_CELLS-1]                       ), 
        .o_dest_node_id                  ( node_id_ring[NUM_CELLS-1]                       ),
        .o_dest_nb_valid                 ( o_nb_valid_ring[NUM_CELLS-1]                    ), 
        .o_nb_force_to_force_cache       ( o_nb_force_to_force_cache[NUM_CELLS-1]          ), 
        .o_nb_force_to_force_cache_valid ( o_nb_force_to_force_cache_valid[NUM_CELLS-1]    ), 
        .o_nb_parid_to_force_cache       ( o_nb_parid_to_force_cache[NUM_CELLS-1]          ), 
        
		.o_buffer_full                   ( o_force_output_ring_buf_full[NUM_CELLS-1]    ),
        .o_buffer_empty                  ( o_force_output_ring_buf_empty[NUM_CELLS-1]      )
    );

    force_output_ring_node_ext force_output_ring_node_ext (
        .clk                             ( clk                           ),
        .rst                             ( rst                           ), 
        .i_remote_force                  ( i_remote_force                ), 
        .i_remote_gcid                   ( i_remote_gcid                 ), 
        .i_remote_parid                  ( i_remote_parid                ), 
        .i_remote_force_valid            ( i_remote_force_valid          ), 
        .i_remote_buffer_back_pressure   ( i_remote_buffer_back_pressure ), 
        .i_source_nb_force               ( nb_force_ring[0]    ), 
        .i_source_nb_parid               ( nb_parid_ring[0]    ), 
        .i_source_nb_gcid                ( nb_gcid_ring[0]     ), 
        .i_source_node_id                ( node_id_ring[0]     ),
        .i_source_nb_valid               ( o_nb_valid_ring[0]  ), 
        .i_local_node_id                 ( i_local_node_id               ),
        
        .o_dest_nb_force                 ( nb_force_ext                  ), 
        .o_dest_nb_parid                 ( nb_parid_ext                  ), 
        .o_dest_nb_gcid                  ( nb_gcid_ext                   ), 
        .o_dest_node_id                  ( node_id_ext                   ),
        .o_dest_nb_valid                 ( o_nb_valid_ext                ), 
        .o_nb_force_to_remote            ( o_force_to_remote             ), 
        .o_nb_force_to_remote_valid      ( o_force_to_remote_valid       ), 
        .o_nb_parid_to_remote            ( o_parid_to_remote             ),
        .o_nb_gcid_to_remote             ( o_gcid_to_remote              ),
        .o_nb_ticket_onehot              ( o_nb_ticket_onehot            ),
        .o_remote_ack                    ( o_remote_ack                  )
//        .o_debug_node_id_error           ( o_debug_node_id_error         )
    );

endmodule