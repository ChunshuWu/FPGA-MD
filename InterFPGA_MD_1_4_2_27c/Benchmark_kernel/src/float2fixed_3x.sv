`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2022 03:59:02 AM
// Design Name: 
// Module Name: float2fixed_3x
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

module float2fixed_3x(
    input clk,
    input rst,
	input [FLOAT_STRUCT_WIDTH-1:0] disp,
	input offset_data_t offset_in,
	
	output logic [1:0] cell_x_offset,
	output logic [1:0] cell_y_offset,
	output logic [1:0] cell_z_offset,
	output [OFFSET_STRUCT_WIDTH-1:0] offset_out
);

float2fixed float2fixed_x
	(
		.clk(clk), 
		.rst(rst), 
		
		.a(disp[FLOAT_WIDTH-1:0]),
		.b(offset_in[OFFSET_WIDTH-1:0]), 
		
		.cell_offset(cell_x_offset), 
		.q(offset_out[OFFSET_WIDTH-1:0])
	);	
	
	float2fixed float2fixed_y
	(
		.clk(clk), 
		.rst(rst), 
		
		.a(disp[2*FLOAT_WIDTH-1:FLOAT_WIDTH]),
		.b(offset_in[2*OFFSET_WIDTH-1:OFFSET_WIDTH]), 
		
		.cell_offset(cell_y_offset), 
		.q(offset_out[2*OFFSET_WIDTH-1:OFFSET_WIDTH])
	);
	
	float2fixed float2fixed_z
	(
		.clk(clk), 
		.rst(rst), 
		
		.a(disp[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]),
		.b(offset_in[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]), 
		
		.cell_offset(cell_z_offset), 
		.q(offset_out[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH])
	);
endmodule
