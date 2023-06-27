`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 06:23:48 PM
// Design Name: 
// Module Name: filter_dispatcher_tb
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

module filter_dispatcher_tb;

logic clk;
logic rst;
offset_packet_t i_home_data;
logic i_home_data_valid;
pos_packet_t i_nb_data; // pos_x, y, z, parid, element
logic i_nb_data_valid; 

logic [NUM_FILTERS-1:0] o_nb_discard_flag; 
pos_data_t o_home_pos; 		// should be aligned with nb_pos_to_eval
logic [ELEMENT_WIDTH-1:0] o_home_element; 
logic [PARTICLE_ID_WIDTH-1:0] o_home_parid;
logic o_pair_valid; 
pos_packet_t o_nb_reg;
logic [NUM_FILTERS-1:0] o_acc_reg_select;
logic o_dispatcher_back_pressure;
logic o_dispatcher_buffer_empty;


always #1 clk <= ~clk;
always #2 i_home_data.offset.offset_x <= i_home_data.offset.offset_x + 23'h010000;
always #2 i_home_data.offset.offset_y <= i_home_data.offset.offset_y + 23'h010000;
always #2 i_home_data.offset.offset_z <= i_home_data.offset.offset_z + 23'h010000;
always #2 i_home_data.parid <= i_home_data.parid + 4;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_home_data.offset.offset_x <= 23'h000000;
	i_home_data.offset.offset_y <= 23'h000000;
	i_home_data.offset.offset_z <= 23'h000000;
	i_home_data.parid <= 0;
	i_home_data.element <= 1;
	i_home_data_valid <= 0;
	i_nb_data.pos.pos_x <= 25'h1000000;
	i_nb_data.pos.pos_y <= 25'h1000000;
	i_nb_data.pos.pos_z <= 25'h1000000;
	i_nb_data.parid <= 9'h001;
	i_nb_data.element <= 2;
	i_nb_data_valid <= 0;
	
	#12
	rst <= 1'b0;
	i_home_data_valid <= 1;
	i_nb_data_valid <= 1;
	
	#2
	i_nb_data.parid <= 9'h002;
	
	#2
	i_nb_data.parid <= 9'h003;
	
	#2
	i_nb_data.parid <= 9'h004;
	
	#2
	i_nb_data.parid <= 9'h005;
	
	#2
	i_nb_data.parid <= 9'h006;
	
	#2
	i_nb_data.parid <= 9'h007;
	
	#2
	i_nb_data.parid <= 9'h008;
	
	#2
	i_nb_data.parid <= 9'h009;
	
	#2
	i_nb_data.parid <= 9'h010;
	
	#2
	i_nb_data_valid <= 0;
	
//	#1000
//	i_nb_data_valid <= 1;
//	i_nb_data.parid <= 9'h003;
	
//	#2
//	i_nb_data.parid <= 9'h004;
	
//	#2
//	i_nb_data_valid <= 0;
	
	
	end
	
filter_dispatcher filter_dispatcher
(
    .clk(clk), 
    .rst(rst), 
    .i_home_data(i_home_data),
    .i_home_data_valid(i_home_data_valid),
    .i_nb_data(i_nb_data),
    .i_nb_data_valid(i_nb_data_valid),
    
    .o_nb_discard_flag(o_nb_discard_flag),
    .o_home_pos(o_home_pos),
    .o_home_element(o_home_element), 
    .o_home_parid(o_home_parid),
    .o_pair_valid(o_pair_valid),
    .o_nb_reg(o_nb_reg),
    .o_acc_reg_select(o_acc_reg_select),
    .o_dispatcher_back_pressure(o_dispatcher_back_pressure),
    .o_dispatcher_buffer_empty(o_dispatcher_buffer_empty)
    
);

endmodule
