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
	
	input [FLOAT_STRUCT_WIDTH-1:0]         i_frc, 		// to force cache
	input                                  i_frc_valid, 
	input [PARTICLE_ID_WIDTH-1:0]          i_frc_parid, 
	
	input [PARTICLE_ID_WIDTH-1:0]          i_MU_rd_addr,
	input                                  i_MU_rd_en,
	
	output [FLOAT_STRUCT_WIDTH-1:0]        o_frc, 
	output logic                           o_buf_almost_full,
	output logic                           o_buf_empty,
	output logic                           o_frc_valid
);
   
// Frc buf signals
logic                           buf_rd_en;
logic                           d1_buf_rd_en;
logic                           d2_buf_rd_en;
logic                           d3_buf_rd_en;
logic                           d4_buf_rd_en;
logic                           d5_buf_rd_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  buf_rd_frc;
logic [FLOAT_STRUCT_WIDTH-1:0]  d1_buf_rd_frc;
logic [PARTICLE_ID_WIDTH-1:0]   buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d1_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d2_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d3_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d4_buf_rd_parid;
logic [PARTICLE_ID_WIDTH-1:0]   d5_buf_rd_parid;
logic                           buf_empty;

// Frc cache signals
logic [FLOAT_STRUCT_WIDTH-1:0]  cache_rd_frc;
logic                           cache_rd_en;
logic                           cache_wr_en;
logic [FLOAT_STRUCT_WIDTH-1:0]  frc_acc;

FRC_CACHE_INPUT_BUF inst_FRC_CACHE_INPUT_BUF (
    .clk           ( clk                         ),
    .rst           ( rst                         ),
    .wr_data       ( {i_frc, i_frc_parid}        ),
    .wr_en         ( i_frc_valid                 ),
    .rd_en         ( buf_rd_en                   ),
    
    .rd_data       ( {buf_rd_frc, buf_rd_parid}  ),
    .buf_empty     ( buf_empty                   ),
    .almost_full   ( o_buf_almost_full           )
);

// Ctrl signals
logic RAW;

assign RAW =    (buf_rd_parid == d1_buf_rd_parid & d1_buf_rd_en) |
                (buf_rd_parid == d2_buf_rd_parid & d2_buf_rd_en) | 
                (buf_rd_parid == d3_buf_rd_parid & d3_buf_rd_en) | 
                (buf_rd_parid == d4_buf_rd_parid & d4_buf_rd_en) | 
                (buf_rd_parid == d5_buf_rd_parid & d5_buf_rd_en);

assign cache_rd_en = ~buf_empty & ~RAW;
assign buf_rd_en   = cache_rd_en;

FRC_ADD_XYZ FRC_ADD_XYZ (
    .clk            ( clk                   ), 
    .frc_x1         ( d1_buf_rd_frc[FLOAT_WIDTH-1:0]  ), 
    .frc_y1         ( d1_buf_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]  ), 
    .frc_z1         ( d1_buf_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  ), 
    .frc_valid_1    ( d1_buf_rd_en     ),
    .frc_x2         ( cache_rd_frc[FLOAT_WIDTH-1:0]   ), 
    .frc_y2         ( cache_rd_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ), 
    .frc_z2         ( cache_rd_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .frc_valid_2    ( 1'b1                  ),
    
    .frc_acc_x      ( frc_acc[FLOAT_WIDTH-1:0]        ),
    .frc_acc_y      ( frc_acc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]        ),
    .frc_acc_z      ( frc_acc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]        ),
    .frc_acc_valid  ( cache_wr_en      )
);

logic [PARTICLE_ID_WIDTH-1:0]   cache_rd_parid;

logic [PARTICLE_ID_WIDTH-1:0]   MU_wr_addr;
logic [FLOAT_STRUCT_WIDTH-1:0]  frc_wr_data;
logic [PARTICLE_ID_WIDTH-1:0]   frc_wr_addr;

assign cache_rd_parid  = i_MU_rd_en ? i_MU_rd_addr : buf_rd_parid;
assign o_frc           = cache_rd_frc;
assign o_buf_empty     = buf_empty;

assign frc_wr_data     = o_frc_valid ? 0 : frc_acc;
assign frc_wr_addr     = o_frc_valid ? MU_wr_addr : d4_buf_rd_parid;

FRC_CACHES inst_FRC_CACHE (
    .clk           ( clk                          ),
    .frc_wr_addr   ( frc_wr_addr                  ),
    .frc_wr_data   ( frc_wr_data                  ),
    .frc_wr_en     ( cache_wr_en | o_frc_valid    ),
    .frc_rd_addr   ( cache_rd_parid               ),
    
    .frc_rd_data   ( cache_rd_frc                 )
);

always@(posedge clk) begin
    o_frc_valid             <= i_MU_rd_en;
    MU_wr_addr              <= i_MU_rd_addr;

    d1_buf_rd_frc      <= buf_rd_frc;
    
    d1_buf_rd_parid    <= buf_rd_parid;
    d2_buf_rd_parid    <= d1_buf_rd_parid;
    d3_buf_rd_parid    <= d2_buf_rd_parid;
    d4_buf_rd_parid    <= d3_buf_rd_parid;
    d5_buf_rd_parid    <= d4_buf_rd_parid;
    
    d1_buf_rd_en       <= buf_rd_en;
    d2_buf_rd_en       <= d1_buf_rd_en;
    d3_buf_rd_en       <= d2_buf_rd_en;
    d4_buf_rd_en       <= d3_buf_rd_en;
    d5_buf_rd_en       <= d4_buf_rd_en;
end

endmodule
