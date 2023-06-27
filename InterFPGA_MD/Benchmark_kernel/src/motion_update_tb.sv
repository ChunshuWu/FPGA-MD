`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2022 05:56:42 PM
// Design Name: 
// Module Name: motion_update_control_tb
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

module motion_update_tb;

logic                            clk;
logic                            rst;
logic                            MU_start;
float_data_t                     i_frc;
offset_data_t                    i_offset;
float_data_t                     i_vel;
logic [ELEMENT_WIDTH-1:0]        i_element;
logic                            i_data_valid;
logic [MU_ID_WIDTH-1:0]          i_MU_id;

offset_data_t                    o_offset;
float_data_t                     o_vel;
logic [ELEMENT_WIDTH-1:0]        o_element;
logic                            o_data_valid;
logic [MU_ID_WIDTH-1:0]          o_MU_id;
// Reading control
logic [PARTICLE_ID_WIDTH-1:0]    o_rd_addr;
logic                            o_rd_en;
logic [1:0]                      cell_x_offset;
logic [1:0]                      cell_y_offset;
logic [1:0]                      cell_z_offset;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	MU_start <= 0;
	i_frc <= 0;
	i_offset <= 0;
	i_vel <= 0;
	i_element <= 0;
	i_data_valid <= 0;
	i_MU_id <= 3;
	
	#20
	rst <= 1'b0;
	
	#10
	MU_start <= 1'b1;
	#2
	MU_start <= 1'b0;
	
	#8
	i_frc.x <= 32'h3f800000;
	i_frc.y <= 32'h3f800000;
	i_frc.z <= 32'h3f800000;
	i_offset.offset_x <= 23'h400000;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_frc.x <= 32'h42c80000;
	i_frc.y <= 32'h42c80000;
	i_frc.z <= 32'h42c80000;
	i_offset.offset_x <= 23'h400000;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_frc.x <= 32'h4708b800;
	i_frc.y <= 32'h4708b800;
	i_frc.z <= 32'h4708b800;
	i_offset.offset_x <= 23'h400000;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_frc.x <= 32'h49742400;
	i_frc.y <= 32'h49742400;
	i_frc.z <= 32'h49742400;
	i_offset.offset_x <= 23'h7fffff;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_frc.x <= 32'h4cbebc20;
	i_frc.y <= 32'h4cbebc20;
	i_frc.z <= 32'h4cbebc20;
	i_offset.offset_x <= 23'h400000;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_data_valid <= 1'b0;
	end

	
motion_update motion_update (
    .clk            ( clk           ),
    .rst            ( rst           ), 
    .MU_start       ( MU_start      ), 
    .i_frc          ( i_frc         ), 
    .i_offset       ( i_offset      ), 
    .i_vel          ( i_vel         ), 
    .i_element      ( i_element     ), 
    .i_data_valid   ( i_data_valid  ), 
    .i_MU_id        ( i_MU_id       ), 
    
    .o_offset       ( o_offset      ),  
    .o_vel          ( o_vel         ),  
    .o_element      ( o_element     ),  
    .o_data_valid   ( o_data_valid  ),  
    .o_MU_id        ( o_MU_id       ),  
    .o_rd_addr      ( o_rd_addr     ), 
    .o_rd_en        ( o_rd_en       ), 
    .cell_x_offset  ( cell_x_offset ), 
    .cell_y_offset  ( cell_y_offset ), 
    .cell_z_offset  ( cell_z_offset )
);


endmodule
