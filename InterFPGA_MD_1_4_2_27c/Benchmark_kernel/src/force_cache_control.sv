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

module force_cache_control (
    input                                  clk, 
    input                                  rst, 
	
	input [FLOAT_STRUCT_WIDTH-1:0]         i_home_frc, 		// to force cache
	input                                  i_home_frc_valid, 
	input [PARTICLE_ID_WIDTH-1:0]          i_home_frc_parid, 
	
	input [FLOAT_STRUCT_WIDTH-1:0]         i_nb_frc, 
	input                                  i_nb_frc_valid, 
	input [PARTICLE_ID_WIDTH-1:0]          i_nb_frc_parid, 
	
	input [PARTICLE_ID_WIDTH-1:0]          i_MU_rd_addr,
	input                                  i_MU_rd_en,
	
	output [FLOAT_STRUCT_WIDTH-1:0]        o_home_frc, 
//	output logic [PARTICLE_ID_WIDTH-1:0]   o_home_frc_parid,   // debug, tbc
//	output logic                           o_home_frc_valid,   // debug, tbc
	output logic                           o_home_buf_almost_full,
	output logic                           o_home_buf_empty,
	output [FLOAT_STRUCT_WIDTH-1:0]        o_nb_frc, 
//	output logic [PARTICLE_ID_WIDTH-1:0]   o_nb_frc_parid,     // debug, tbc
//	output logic                           o_nb_frc_valid,     // debug, tbc
	output logic                           o_nb_buf_almost_full,
	output logic                           o_nb_buf_empty,
	output logic                           o_frc_valid
);
   
// Frc buf signals
logic                           home_buf_rd_en;
logic                           d1_home_buf_rd_en;
logic                           d2_home_buf_rd_en;
logic                           d3_home_buf_rd_en;
logic                           d4_home_buf_rd_en;
logic                           d5_home_buf_rd_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  home_buf_rd_frc;
logic [FLOAT_STRUCT_WIDTH-1:0]  d1_home_buf_rd_frc;
logic [PARTICLE_ID_WIDTH-1:0]   home_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d1_home_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d2_home_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d3_home_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d4_home_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d5_home_buf_rd_parid;
logic                           home_buf_empty;

logic                           nb_buf_rd_en;
logic                           d1_nb_buf_rd_en;
logic                           d2_nb_buf_rd_en;
logic                           d3_nb_buf_rd_en;
logic                           d4_nb_buf_rd_en;
logic                           d5_nb_buf_rd_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  nb_buf_rd_frc;
logic [FLOAT_STRUCT_WIDTH-1:0]  d1_nb_buf_rd_frc;
logic [PARTICLE_ID_WIDTH-1:0]   nb_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d1_nb_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d2_nb_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d3_nb_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d4_nb_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d5_nb_buf_rd_parid;
logic                           nb_buf_empty;

// Frc cache signals
logic [FLOAT_STRUCT_WIDTH-1:0]  home_cache_rd_frc;
logic                           home_cache_rd_en;
logic                           home_cache_wr_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  home_frc_acc;

logic [FLOAT_STRUCT_WIDTH-1:0]  nb_cache_rd_frc;
logic                           nb_cache_rd_en;
logic                           nb_cache_wr_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  nb_frc_acc;

FRC_CACHE_INPUT_BUF inst_FRC_CACHE_INPUT_BUF (
    .clk                ( clk                                   ),
    .rst                ( rst                                   ),
    .home_wr_data       ( {i_home_frc, i_home_frc_parid}        ),
    .home_wr_en         ( i_home_frc_valid                      ),
    .home_rd_en         ( home_buf_rd_en                        ),
    .nb_wr_data         ( {i_nb_frc, i_nb_frc_parid}            ),
    .nb_wr_en           ( i_nb_frc_valid                        ),
    .nb_rd_en           ( nb_buf_rd_en                          ),
    
    .home_rd_data       ( {home_buf_rd_frc, home_buf_rd_parid}  ),
    .home_buf_empty     ( home_buf_empty                        ),
    .home_almost_full   ( o_home_buf_almost_full                ),
    .nb_rd_data         ( {nb_buf_rd_frc, nb_buf_rd_parid}      ),
    .nb_buf_empty       ( nb_buf_empty                          ),
    .nb_almost_full     ( o_nb_buf_almost_full                  )
);

// Ctrl signals
logic home_RAW;
logic nb_RAW;

assign home_RAW =   (home_buf_rd_parid == d1_home_buf_rd_parid & d1_home_buf_rd_en) |
                    (home_buf_rd_parid == d2_home_buf_rd_parid & d2_home_buf_rd_en) | 
                    (home_buf_rd_parid == d3_home_buf_rd_parid & d3_home_buf_rd_en) | 
                    (home_buf_rd_parid == d4_home_buf_rd_parid & d4_home_buf_rd_en) | 
                    (home_buf_rd_parid == d5_home_buf_rd_parid & d5_home_buf_rd_en);
assign nb_RAW =     (nb_buf_rd_parid == d1_nb_buf_rd_parid & d1_nb_buf_rd_en) |
                    (nb_buf_rd_parid == d2_nb_buf_rd_parid & d2_nb_buf_rd_en) | 
                    (nb_buf_rd_parid == d3_nb_buf_rd_parid & d3_nb_buf_rd_en) | 
                    (nb_buf_rd_parid == d4_nb_buf_rd_parid & d4_nb_buf_rd_en) | 
                    (nb_buf_rd_parid == d5_nb_buf_rd_parid & d5_nb_buf_rd_en);

assign home_cache_rd_en = ~home_buf_empty & ~home_RAW;
assign nb_cache_rd_en   = ~nb_buf_empty & ~nb_RAW;
assign home_buf_rd_en   = home_cache_rd_en;
assign nb_buf_rd_en     = nb_cache_rd_en;

FRC_ADD_XYZ FRC_ADD_XYZ_HOME (
    .clk            ( clk                   ), 
    .frc_x1         ( d1_home_buf_rd_frc[FLOAT_WIDTH-1:0]  ), 
    .frc_y1         ( d1_home_buf_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]  ), 
    .frc_z1         ( d1_home_buf_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  ), 
    .frc_valid_1    ( d1_home_buf_rd_en     ),
    .frc_x2         ( home_cache_rd_frc[FLOAT_WIDTH-1:0]   ), 
    .frc_y2         ( home_cache_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ), 
    .frc_z2         ( home_cache_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .frc_valid_2    ( 1'b1                  ),
    
    .frc_acc_x      ( home_frc_acc[FLOAT_WIDTH-1:0]        ),
    .frc_acc_y      ( home_frc_acc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]        ),
    .frc_acc_z      ( home_frc_acc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]        ),
    .frc_acc_valid  ( home_cache_wr_en      )
);

FRC_ADD_XYZ FRC_ADD_XYZ_NB (
    .clk            ( clk                   ), 
    .frc_x1         ( d1_nb_buf_rd_frc[FLOAT_WIDTH-1:0]    ), 
    .frc_y1         ( d1_nb_buf_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    ), 
    .frc_z1         ( d1_nb_buf_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]    ), 
    .frc_valid_1    ( d1_nb_buf_rd_en       ),
    .frc_x2         ( nb_cache_rd_frc[FLOAT_WIDTH-1:0]     ), 
    .frc_y2         ( nb_cache_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]     ), 
    .frc_z2         ( nb_cache_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]     ),
    .frc_valid_2    ( 1'b1                  ),
    
    .frc_acc_x      ( nb_frc_acc[FLOAT_WIDTH-1:0]          ),
    .frc_acc_y      ( nb_frc_acc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]          ),
    .frc_acc_z      ( nb_frc_acc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]          ),
    .frc_acc_valid  ( nb_cache_wr_en        )
);

logic [PARTICLE_ID_WIDTH-1:0]   home_cache_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   nb_cache_rd_parid;

logic [PARTICLE_ID_WIDTH-1:0]   MU_wr_addr;
logic [FLOAT_STRUCT_WIDTH-1:0]  home_frc_wr_data;
logic [PARTICLE_ID_WIDTH-1:0]   home_frc_wr_addr;
logic [FLOAT_STRUCT_WIDTH-1:0]  nb_frc_wr_data;
logic [PARTICLE_ID_WIDTH-1:0]   nb_frc_wr_addr;

assign home_cache_rd_parid  = i_MU_rd_en ? i_MU_rd_addr : home_buf_rd_parid;
assign o_home_frc           = home_cache_rd_frc;
assign o_home_buf_empty     = home_buf_empty;

assign nb_cache_rd_parid    = i_MU_rd_en ? i_MU_rd_addr : nb_buf_rd_parid;
assign o_nb_frc             = nb_cache_rd_frc;
assign o_nb_buf_empty       = nb_buf_empty;

assign home_frc_wr_data     = o_frc_valid ? 0 : home_frc_acc;
assign home_frc_wr_addr     = o_frc_valid ? MU_wr_addr : d4_home_buf_rd_parid;
assign nb_frc_wr_data       = o_frc_valid ? 0 : nb_frc_acc;
assign nb_frc_wr_addr       = o_frc_valid ? MU_wr_addr : d4_nb_buf_rd_parid;

FRC_CACHES inst_FRC_CACHES (
    .clk                ( clk                               ),
    .home_frc_wr_addr   ( home_frc_wr_addr                  ),
    .home_frc_wr_data   ( home_frc_wr_data                  ),
    .home_frc_wr_en     ( home_cache_wr_en | o_frc_valid    ),
    .home_frc_rd_addr   ( home_cache_rd_parid               ),
    .nb_frc_wr_addr     ( nb_frc_wr_addr                    ),
    .nb_frc_wr_data     ( nb_frc_wr_data                    ),
    .nb_frc_wr_en       ( nb_cache_wr_en | o_frc_valid      ),
    .nb_frc_rd_addr     ( nb_cache_rd_parid                 ),
    
    .home_frc_rd_data   ( home_cache_rd_frc                 ),
    .nb_frc_rd_data     ( nb_cache_rd_frc                   )
);

always@(posedge clk) begin
    o_frc_valid             <= i_MU_rd_en;
    MU_wr_addr              <= i_MU_rd_addr;

    d1_home_buf_rd_frc      <= home_buf_rd_frc;
    d1_nb_buf_rd_frc        <= nb_buf_rd_frc;
    
    d1_home_buf_rd_parid    <= home_buf_rd_parid;
    d2_home_buf_rd_parid    <= d1_home_buf_rd_parid;
    d3_home_buf_rd_parid    <= d2_home_buf_rd_parid;
    d4_home_buf_rd_parid    <= d3_home_buf_rd_parid;
    d5_home_buf_rd_parid    <= d4_home_buf_rd_parid;
    
    d1_home_buf_rd_en       <= home_buf_rd_en;
    d2_home_buf_rd_en       <= d1_home_buf_rd_en;
    d3_home_buf_rd_en       <= d2_home_buf_rd_en;
    d4_home_buf_rd_en       <= d3_home_buf_rd_en;
    d5_home_buf_rd_en       <= d4_home_buf_rd_en;
    
    d1_nb_buf_rd_parid      <= nb_buf_rd_parid;
    d2_nb_buf_rd_parid      <= d1_nb_buf_rd_parid;
    d3_nb_buf_rd_parid      <= d2_nb_buf_rd_parid;
    d4_nb_buf_rd_parid      <= d3_nb_buf_rd_parid;
    d5_nb_buf_rd_parid      <= d4_nb_buf_rd_parid;
    
    d1_nb_buf_rd_en         <= nb_buf_rd_en;
    d2_nb_buf_rd_en         <= d1_nb_buf_rd_en;
    d3_nb_buf_rd_en         <= d2_nb_buf_rd_en;
    d4_nb_buf_rd_en         <= d3_nb_buf_rd_en;
    d5_nb_buf_rd_en         <= d4_nb_buf_rd_en;
end

endmodule
