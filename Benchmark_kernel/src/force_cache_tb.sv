`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2022 10:49:48 PM
// Design Name: 
// Module Name: check_pos_input_ring_target_hit_tb
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

import MD_pkg::*;   // Change OFFSET_WIDTH to 30 before simulating, or change the test cases below. 

module force_cache_tb;

logic                           clk;

float_data_t                    home_frc_acc;
logic                           home_cache_wr_en;
logic [PARTICLE_ID_WIDTH-1:0]   home_buf_wr_parid;
float_data_t                    home_cache_rd_frc;
logic [PARTICLE_ID_WIDTH-1:0]   home_buf_rd_parid;

float_data_t                    nb_frc_acc;
logic                           nb_cache_wr_en;
logic [PARTICLE_ID_WIDTH-1:0]   nb_buf_wr_parid;
float_data_t                    nb_cache_rd_frc;
logic [PARTICLE_ID_WIDTH-1:0]   nb_buf_rd_parid;

always #1 clk <= ~clk;

initial
	begin
	clk <= 1'b0;
	home_frc_acc <= 0;
	home_cache_wr_en <= 0;
	home_buf_wr_parid <= 0;
	home_buf_rd_parid <= 0;
	
	nb_frc_acc <= 0;
	nb_cache_wr_en <= 0;
	nb_buf_wr_parid <= 0;
	nb_buf_rd_parid <= 0;
	
	#10
	home_buf_rd_parid <= 1;
	nb_buf_rd_parid <= 1;
	
	#2
	home_frc_acc.x <= 32'h3f800000;
	home_frc_acc.y <= 32'h3f800000;
	home_frc_acc.z <= 32'h3f800000;
	home_cache_wr_en <= 1'b1;
	home_buf_wr_parid <= 1;
	
	nb_frc_acc.x <= 32'h3f800000;
	nb_frc_acc.y <= 32'h3f800000;
	nb_frc_acc.z <= 32'h3f800000;
	nb_cache_wr_en <= 1'b1;
	nb_buf_wr_parid <= 1;
	
	#2
	home_cache_wr_en <= 1'b0;
	home_buf_rd_parid <= 1;
	nb_cache_wr_en <= 1'b0;
	nb_buf_rd_parid <= 1;
	
	#6
	home_buf_rd_parid <= 0;
	nb_buf_rd_parid <= 0;
	
	#2
	home_buf_rd_parid <= 1;
	nb_buf_rd_parid <= 1;
	
	end

FRC_CACHES inst_FRC_CACHES (
    .clk                ( clk                   ),
    .home_frc_wr_addr   ( home_buf_wr_parid     ),
    .home_frc_wr_data   ( home_frc_acc          ),
    .home_frc_wr_en     ( home_cache_wr_en      ),
    .home_frc_rd_addr   ( home_buf_rd_parid     ),
    .nb_frc_wr_addr     ( nb_buf_wr_parid       ),
    .nb_frc_wr_data     ( nb_frc_acc            ),
    .nb_frc_wr_en       ( nb_cache_wr_en        ),
    .nb_frc_rd_addr     ( nb_buf_rd_parid       ),
    
    .home_frc_rd_data   ( home_cache_rd_frc     ),
    .nb_frc_rd_data     ( nb_cache_rd_frc       )
);

endmodule