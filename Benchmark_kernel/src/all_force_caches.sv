//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 11:59:47 PM
// Design Name: 
// Module Name: all_force_caches
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

module all_force_caches
(
	input clk, 
	input rst, 
	input [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]     i_home_frc, 		// to force cache
	input [NUM_CELLS-1:0][PARTICLE_ID_WIDTH*NUM_PES_PER_CELL-1:0]      i_home_frc_parid, 
	input [NUM_CELLS-1:0][NUM_PES_PER_CELL-1:0]                        i_home_frc_valid, 
	input [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]                      i_nb_frc, 
	input [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]                       i_nb_frc_parid, 
	input [NUM_CELLS-1:0]                                              i_nb_frc_valid, 
	input [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]                       i_MU_rd_addr,
	input [NUM_CELLS-1:0]                                              i_MU_rd_en,
	
	output [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]    o_home_frc, 		// to be added in MU
	output                                                             o_home_buf_almost_full,
	output                                                             o_home_buf_empty,
	output [NUM_CELLS-1:0][FLOAT_STRUCT_WIDTH-1:0]                     o_nb_frc,
	output                                                             o_nb_buf_almost_full,
	output                                                             o_nb_buf_empty,
	output [NUM_CELLS-1:0]                                             o_frc_valid
);

logic [NUM_CELLS-1:0] home_buf_almost_full;
logic [NUM_CELLS-1:0] home_buf_empty;
logic [NUM_CELLS-1:0] nb_buf_almost_full;
logic [NUM_CELLS-1:0] nb_buf_empty;

assign o_home_buf_almost_full = | home_buf_almost_full;
assign o_home_buf_empty       = & home_buf_empty;
assign o_nb_buf_almost_full   = | nb_buf_almost_full; 
assign o_nb_buf_empty         = & nb_buf_empty;

genvar i;
generate
for (i = 0; i < NUM_CELLS; i++) begin: force_cache_control_wrappers
    force_cache_control_wrapper inst_force_cache_control_wrapper (
        .clk                    ( clk                       ),
        .rst                    ( rst                       ),
        .i_home_frc             ( i_home_frc[i]             ),
        .i_home_frc_valid       ( i_home_frc_valid[i]       ),
        .i_home_frc_parid       ( i_home_frc_parid[i]       ),
        .i_nb_frc               ( i_nb_frc[i]               ),
        .i_nb_frc_valid         ( i_nb_frc_valid[i]         ),
        .i_nb_frc_parid         ( i_nb_frc_parid[i]         ),
        .i_MU_rd_addr           ( i_MU_rd_addr[i]           ),
        .i_MU_rd_en             ( i_MU_rd_en[i]             ),
        
        .o_home_frc             ( o_home_frc[i]             ),
        .o_home_buf_almost_full ( home_buf_almost_full[i]   ),
        .o_home_buf_empty       ( home_buf_empty[i]         ),
        .o_nb_frc               ( o_nb_frc[i]               ),
        .o_nb_buf_almost_full   ( nb_buf_almost_full[i]     ),
        .o_nb_buf_empty         ( nb_buf_empty[i]           ),
        .o_frc_valid            ( o_frc_valid[i]            )
    );
end
endgenerate


endmodule