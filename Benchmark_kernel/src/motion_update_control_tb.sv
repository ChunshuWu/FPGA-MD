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


module motion_update_control_tb;

logic                            clk;
logic                            rst;
logic                            MU_start;
float_data_t                     i_home_frc;
float_data_t                     i_nb_frc;
offset_data_t                    i_offset;
float_data_t                     i_vel;
logic [ELEMENT_WIDTH-1:0]        i_element;
logic                            i_data_valid;

logic [MU_ID_WIDTH-1:0]          i_MU_id;
offset_data_t                    i_offset_fwd;
float_data_t                     i_vel_fwd;
logic [ELEMENT_WIDTH-1:0]        i_element_fwd;
logic                            i_fwd_valid;

offset_data_t                    o_offset;
float_data_t                     o_vel;
logic [ELEMENT_WIDTH-1:0]        o_element;
logic                            o_data_valid;

logic [MU_ID_WIDTH-1:0]          o_MU_id;
offset_data_t                    o_offset_fwd;
float_data_t                     o_vel_fwd;
logic [ELEMENT_WIDTH-1:0]        o_element_fwd;
logic                            o_fwd_valid;
// Reading control
logic [PARTICLE_ID_WIDTH-1:0]    o_rd_addr;
logic                            o_rd_en;
logic                            o_MU_buf_full;
logic                            o_MU_buf_empty;
float_data_t                     o_debug_vel;
logic                            o_debug_vel_valid;
logic [PARTICLE_ID_WIDTH-1:0]    o_debug_particle_num;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	MU_start <= 0;
	i_home_frc <= 0;
	i_nb_frc <= 0;
	i_offset <= 0;
	i_vel <= 0;
	i_element <= 0;
	i_data_valid <= 0;
	i_MU_id <= 0;
	i_offset_fwd <= 0;
	i_vel_fwd <= 0;
	i_element_fwd <= 0;
	i_fwd_valid <= 0;
	
	#20
	rst <= 1'b0;
	
	#10
	MU_start <= 1'b1;
	
	#2
	MU_start <= 1'b0;
	
	#4
	i_home_frc.x <= 32'h3f800000;
	i_home_frc.y <= 32'h3f800000;
	i_home_frc.z <= 32'h3f800000;
	i_nb_frc.x <= 32'h40000000;
	i_nb_frc.y <= 32'h40000000;
	i_nb_frc.z <= 32'h40000000;
	i_offset.offset_x <= 23'h400000;
	i_offset.offset_y <= 23'h400000;
	i_offset.offset_z <= 23'h400000;
	i_element <= 2'b01;
	i_data_valid <= 1'b1;
	
	#2
	i_offset.offset_x <= 23'h410000;
	i_offset.offset_y <= 23'h410000;
	i_offset.offset_z <= 23'h410000;
	
	#2
	i_offset.offset_x <= 23'h420000;
	i_offset.offset_y <= 23'h420000;
	i_offset.offset_z <= 23'h420000;
	
	#2
	i_offset.offset_x <= 23'h430000;
	i_offset.offset_y <= 23'h430000;
	i_offset.offset_z <= 23'h430000;
	
//	#2
//	i_offset_fwd.offset_x <= 23'h400000;
//	i_offset_fwd.offset_y <= 23'h400000;
//	i_offset_fwd.offset_z <= 23'h400000;
//	i_vel_fwd.x <= 32'h3f800000;
//	i_vel_fwd.y <= 32'h3f800000;
//	i_vel_fwd.z <= 32'h3f800000;
//	i_element_fwd <= 2'b01;
//	i_fwd_valid <= 1'b1;
	
//	#2
//	i_offset_fwd.offset_x <= 23'h400000;
//	i_offset_fwd.offset_y <= 23'h400000;
//	i_offset_fwd.offset_z <= 23'h400000;
//	i_vel_fwd.x <= 32'h3f800000;
//	i_vel_fwd.y <= 32'h3f800000;
//	i_vel_fwd.z <= 32'h3f800000;
//	i_element_fwd <= 2'b01;
//	i_fwd_valid <= 1'b1;
//	i_MU_id <= 1;
	
	#2
	i_fwd_valid <= 1'b0;
	i_data_valid <= 1'b0;
	end

	
motion_update_control #(
    .GCELL_X({3'b000}),
    .GCELL_Y({3'b000}),
    .GCELL_Z({3'b000})
)
motion_update_control (
    .clk            ( clk           ),
    .rst            ( rst           ), 
    .MU_start       ( MU_start      ), 
    .i_home_frc     ( i_home_frc    ), 
    .i_nb_frc       ( i_nb_frc      ), 
    .i_offset       ( i_offset      ), 
    .i_vel          ( i_vel         ), 
    .i_element      ( i_element     ), 
    .i_data_valid   ( i_data_valid  ), 
    .i_MU_id        ( i_MU_id       ), 
    .i_offset_fwd   ( i_offset_fwd  ), 
    .i_vel_fwd      ( i_vel_fwd     ), 
    .i_element_fwd  ( i_element_fwd ), 
    .i_fwd_valid    ( i_fwd_valid   ), 
    
    .o_offset       ( o_offset      ),  
    .o_vel          ( o_vel         ),  
    .o_element      ( o_element     ),  
    .o_data_valid   ( o_data_valid  ),  
    .o_MU_id        ( o_MU_id       ),  
    .o_offset_fwd   ( o_offset_fwd  ),  
    .o_vel_fwd      ( o_vel_fwd     ), 
    .o_element_fwd  ( o_element_fwd ), 
    .o_fwd_valid    ( o_fwd_valid   ), 
    .o_rd_addr      ( o_rd_addr     ), 
    .o_rd_en        ( o_rd_en       ), 
    .o_MU_buf_full  ( o_MU_buf_full ), 
    .o_MU_buf_empty  ( o_MU_buf_empty ), 
    .o_debug_vel  ( o_debug_vel ), 
    .o_debug_vel_valid  ( o_debug_vel_valid ), 
    .o_debug_particle_num  ( o_debug_particle_num )
);


endmodule
