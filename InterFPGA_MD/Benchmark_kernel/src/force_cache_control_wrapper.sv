//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2022 05:06:58 AM
// Design Name: 
// Module Name: force_cache_control
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

module force_cache_control_wrapper (
    input                                  clk, 
    input                                  rst, 
	
	input [FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]    i_home_frc, 		// to force cache
	input [NUM_PES_PER_CELL-1:0]                       i_home_frc_valid, 
	input [PARTICLE_ID_WIDTH*NUM_PES_PER_CELL-1:0]     i_home_frc_parid, 
	
	input [FLOAT_STRUCT_WIDTH-1:0]                     i_nb_frc, 
	input                                              i_nb_frc_valid, 
	input [PARTICLE_ID_WIDTH-1:0]                      i_nb_frc_parid, 
	
	input [PARTICLE_ID_WIDTH-1:0]                      i_MU_rd_addr,
	input                                              i_MU_rd_en,
	
	output [FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]   o_home_frc, 
	output logic                                       o_home_buf_almost_full,
	output logic                                       o_home_buf_empty,
	output [FLOAT_STRUCT_WIDTH-1:0]                    o_nb_frc, 
	output logic                                       o_nb_buf_almost_full,
	output logic                                       o_nb_buf_empty,
	output logic                                       o_frc_valid
);

logic [NUM_PES_PER_CELL-1:0] home_buf_almost_full_bus;
logic [NUM_PES_PER_CELL-1:0] home_buf_empty_bus;
assign o_home_buf_almost_full   = | home_buf_almost_full_bus;
assign o_home_buf_empty         = & home_buf_empty_bus;

genvar i;
generate
    for (i = 0; i < NUM_PES_PER_CELL; i++) begin: home_frc_caches
        force_cache_control inst_home_frc_caches (
            .clk                ( clk                                                               ),
            .rst                ( rst                                                               ),
            .i_frc              ( i_home_frc[(i+1)*FLOAT_STRUCT_WIDTH-1:i*FLOAT_STRUCT_WIDTH]       ),
            .i_frc_valid        ( i_home_frc_valid[i]                                               ),
            .i_frc_parid        ( i_home_frc_parid[(i+1)*PARTICLE_ID_WIDTH-1:i*PARTICLE_ID_WIDTH]   ),
            .i_MU_rd_addr       ( i_MU_rd_addr                                                      ),
            .i_MU_rd_en         ( i_MU_rd_en                                                        ),
            
            .o_frc              ( o_home_frc[(i+1)*FLOAT_STRUCT_WIDTH-1:i*FLOAT_STRUCT_WIDTH]       ),
            .o_buf_almost_full  ( home_buf_almost_full_bus[i]                                       ),
            .o_buf_empty        ( home_buf_empty_bus[i]                                             ),
            .o_frc_valid        ( )
        );
    end
endgenerate

force_cache_control inst_nb_frc_cache (
    .clk                ( clk                   ),
    .rst                ( rst                   ),
    .i_frc              ( i_nb_frc              ),
    .i_frc_valid        ( i_nb_frc_valid        ),
    .i_frc_parid        ( i_nb_frc_parid        ),
    .i_MU_rd_addr       ( i_MU_rd_addr          ),
    .i_MU_rd_en         ( i_MU_rd_en            ),
    
    .o_frc              ( o_nb_frc              ),
    .o_buf_almost_full  ( o_nb_buf_almost_full  ),
    .o_buf_empty        ( o_nb_buf_empty        ),
    .o_frc_valid        ( o_frc_valid           )
);


endmodule
