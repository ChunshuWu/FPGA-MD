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
	input [NUM_CELLS-1:0]                                  i_nb_force_valid, 
	
	output [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]         o_nb_force_to_force_cache, 
	output logic [NUM_CELLS-1:0]                           o_nb_force_to_force_cache_valid, 
	output logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]    o_nb_parid_to_force_cache, 
	
	output [NUM_CELLS-1:0]                                 o_force_output_ring_buf_empty, 
	output [NUM_CELLS-1:0]                                 o_nb_valid_ring
);

logic [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0] nb_force_ring; 					// from the prev node
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0] nb_parid_ring;
logic [NUM_CELLS-1:0][3*GLOBAL_CELL_ID_WIDTH-1:0] nb_gcid_ring;
//logic [NUM_CELLS-1:0][CELL_FOLD_ID_WIDTH-1:0] nb_fold_id_ring;

genvar i;
generate
	for (i = 0; i < NUM_CELLS; i++) begin: force_output_ring_nodes
		force_output_ring_node #(
			.GCELL_X ( {i / (Y_DIM * Z_DIM)} ), 
			.GCELL_Y ( {i / Z_DIM % Y_DIM}   ), 
			.GCELL_Z ( {i % Z_DIM}           )
		)
		force_output_ring_node (
			.clk                             ( clk                                       ),
			.rst                             ( rst                                       ), 
			.i_nb_force                      ( i_nb_force[i]                             ), 
			.i_nb_force_valid                ( i_nb_force_valid[i]                       ), 
			.i_source_nb_force               ( nb_force_ring[(i+NUM_CELLS-1)%NUM_CELLS]            ), 
			.i_source_nb_parid               ( nb_parid_ring[(i+NUM_CELLS-1)%NUM_CELLS]            ), 
			.i_source_nb_gcid                ( nb_gcid_ring[(i+NUM_CELLS-1)%NUM_CELLS]             ), 
			.i_source_nb_valid               ( o_nb_valid_ring[(i+NUM_CELLS-1)%NUM_CELLS]          ), 
			
			.o_dest_nb_force                 ( nb_force_ring[i]                          ), 
			.o_dest_nb_parid                 ( nb_parid_ring[i]                          ), 
			.o_dest_nb_gcid                  ( nb_gcid_ring[i]                           ), 
			.o_dest_nb_valid                 ( o_nb_valid_ring[i]                        ), 
			.o_nb_force_to_force_cache       ( o_nb_force_to_force_cache[i]              ), 
			.o_nb_force_to_force_cache_valid ( o_nb_force_to_force_cache_valid[i]        ), 
			.o_nb_parid_to_force_cache       ( o_nb_parid_to_force_cache[i]              ), 
			
			.o_buffer_empty                  ( o_force_output_ring_buf_empty[i]          )
		);
	end
endgenerate

endmodule