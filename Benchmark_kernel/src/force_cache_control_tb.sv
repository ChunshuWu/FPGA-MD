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

module force_cache_control_tb;

logic                           clk;
logic                           rst;

float_data_t                    i_home_frc;
logic                           i_home_frc_valid;
logic [PARTICLE_ID_WIDTH-1:0]   i_home_frc_parid;

float_data_t                    i_nb_frc;
logic                           i_nb_frc_valid;
logic [PARTICLE_ID_WIDTH-1:0]   i_nb_frc_parid;

logic [PARTICLE_ID_WIDTH-1:0]   i_MU_rd_addr;
logic                           i_MU_rd_en;

float_data_t                    o_home_frc;
logic                           o_home_buf_almost_full;
logic                           o_home_buf_empty;
float_data_t                    o_nb_frc;
logic                           o_nb_buf_almost_full;
logic                           o_nb_buf_empty;
logic                           o_frc_valid;

always #1 clk <= ~clk;

initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_home_frc <= 0;
	i_home_frc_valid <= 0;
	i_home_frc_parid <= 0;
	i_nb_frc <= 0;
	i_nb_frc_valid <= 0;
	i_nb_frc_parid <= 0;
	i_MU_rd_addr <= 0;
	i_MU_rd_en <= 0;
	
	#20
	rst <= 1'b0;
	
	#2
	i_home_frc.x <= 32'h3f800000;
	i_home_frc.y <= 32'h3f800000;
	i_home_frc.z <= 32'h3f800000;
	i_home_frc_valid <= 1'b1;
	i_home_frc_parid <= 1;
	
	i_nb_frc.x <= 32'h3f800000;
	i_nb_frc.y <= 32'h3f800000;
	i_nb_frc.z <= 32'h3f800000;
	i_nb_frc_valid <= 1'b1;
	i_nb_frc_parid <= 1;
	
	#10
	i_home_frc_parid <= 2;
	i_nb_frc_parid <= 2;
	
	#2
	i_home_frc_parid <= 3;
	i_nb_frc_parid <= 3;
	
	#2
	i_home_frc_parid <= 4;
	i_nb_frc_parid <= 4;
	
	#2
	i_home_frc_parid <= 5;
	i_nb_frc_parid <= 5;
	
	#2
	i_home_frc_parid <= 6;
	i_nb_frc_parid <= 6;
	
	#2
	i_home_frc_parid <= 7;
	i_nb_frc_parid <= 7;
	
	#2
	i_home_frc_parid <= 8;
	i_nb_frc_parid <= 8;
	
	#2
	i_home_frc_parid <= 9;
	i_nb_frc_parid <= 9;
	
	#2
	i_home_frc_parid <= 10;
	i_nb_frc_parid <= 10;
	
	#2
	i_home_frc_parid <= 11;
	i_nb_frc_parid <= 11;
	
	#2
	i_home_frc_parid <= 12;
	i_nb_frc_parid <= 12;
	
	#2
	i_home_frc_parid <= 13;
	i_nb_frc_parid <= 13;
	
	#2
	i_home_frc_parid <= 14;
	i_nb_frc_parid <= 14;
	
	#2
	i_home_frc_parid <= 15;
	i_nb_frc_parid <= 15;
	
	#2
	i_home_frc_valid <= 1'b0;
	i_nb_frc_valid <= 1'b0;
	
	#40
	i_MU_rd_addr <= 1;
	i_MU_rd_en <= 1;
	
	#2
	i_MU_rd_addr <= 2;
	
	#2
	i_MU_rd_addr <= 3;
	
	#2
	i_MU_rd_addr <= 4;
	
	#2
	i_MU_rd_addr <= 5;
	
	#16
	i_MU_rd_addr <= 1;
	
	#2
	i_MU_rd_addr <= 2;
	
	#2
	i_MU_rd_addr <= 3;
	
	#2
	i_MU_rd_addr <= 4;
	
	#2
	i_MU_rd_addr <= 5;
	
	#2
	i_MU_rd_en <= 0;
	
	
//	#20
//	i_home_frc_valid <= 1'b1;
//	i_nb_frc_valid <= 1'b1;
//	i_home_frc_parid <= 2;
//	i_nb_frc_parid <= 2;
	
//	#2
//	i_home_frc_valid <= 1'b0;
//	i_nb_frc_valid <= 1'b0;
	end

force_cache_control inst_force_cache_control
(
    .clk(clk),
    .rst(rst),
    .i_home_frc(i_home_frc),
    .i_home_frc_valid(i_home_frc_valid),
    .i_home_frc_parid(i_home_frc_parid),
    .i_nb_frc(i_nb_frc),
    .i_nb_frc_valid(i_nb_frc_valid),
    .i_nb_frc_parid(i_nb_frc_parid),
    .i_MU_rd_addr(i_MU_rd_addr),
    .i_MU_rd_en(i_MU_rd_en),
    
    .o_home_frc(o_home_frc),
    .o_nb_frc(o_nb_frc),
    .o_home_buf_almost_full ( o_home_buf_almost_full   ),
    .o_home_buf_empty       ( o_home_buf_empty         ),
    .o_nb_buf_almost_full   ( o_nb_buf_almost_full     ),
    .o_nb_buf_empty         ( o_nb_buf_empty           ),
    .o_frc_valid            ( o_frc_valid              )
);

endmodule