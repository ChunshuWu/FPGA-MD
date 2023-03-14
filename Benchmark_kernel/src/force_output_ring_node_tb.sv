`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 09:44:50 AM
// Design Name: 
// Module Name: force_output_ring_node_tb
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

module force_output_ring_node_tb;

logic clk; 
logic rst; 
force_packet_t i_nb_force; // f, parid, cid, from PE
logic i_nb_force_valid;  

float_data_t i_source_nb_force; 					// from the prev node
logic [PARTICLE_ID_WIDTH-1:0] i_source_nb_parid; 
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] i_source_nb_gcid; 
logic i_source_nb_valid; 

float_data_t o_dest_nb_force; 						// to the next node
logic [PARTICLE_ID_WIDTH-1:0] o_dest_nb_parid; 
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] o_dest_nb_gcid; 
logic o_dest_nb_valid; 

float_data_t o_nb_force_to_force_cache; 
logic o_nb_force_to_force_cache_valid; 
logic [PARTICLE_ID_WIDTH-1:0] o_nb_parid_to_force_cache;

logic o_buffer_empty; 										// System control

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_nb_force <= 0;
	i_nb_force_valid <= 0;
	i_source_nb_force <= 0;
	i_source_nb_parid <= 0;
	i_source_nb_gcid <= 0;
	i_source_nb_valid <= 0;
	
	#20
	rst <= 1'b0;
	i_nb_force.f.x <= 32'h00000001;
	i_nb_force.f.y <= 32'h00000001;
	i_nb_force.f.z <= 32'h00000001;
	i_nb_force.cid <= 6'b101010;
	i_nb_force.parid <= 1;
	i_nb_force_valid <= 1;
	
	#2 
	i_nb_force.f.x <= 32'h00000003;
	i_nb_force.f.y <= 32'h00000003;
	i_nb_force.f.z <= 32'h00000003;
	i_nb_force.parid <= 3;
	
	#2
	i_nb_force.f.x <= 32'h00000004;
	i_nb_force.f.y <= 32'h00000004;
	i_nb_force.f.z <= 32'h00000004;
	i_nb_force.parid <= 4;
	
	#2
	i_nb_force.f.x <= 32'h00000005;
	i_nb_force.f.y <= 32'h00000005;
	i_nb_force.f.z <= 32'h00000005;
	i_nb_force.parid <= 5;
	
	#2
	i_nb_force.f.x <= 32'h00000006;
	i_nb_force.f.y <= 32'h00000006;
	i_nb_force.f.z <= 32'h00000006;
	i_nb_force.parid <= 6;
	
	#2
	i_nb_force.f.x <= 32'h00000007;
	i_nb_force.f.y <= 32'h00000007;
	i_nb_force.f.z <= 32'h00000007;
	i_nb_force.parid <= 7;
	
	#2
	i_nb_force.f.x <= 32'h00000008;
	i_nb_force.f.y <= 32'h00000008;
	i_nb_force.f.z <= 32'h00000008;
	i_nb_force.parid <= 8;
	i_source_nb_force.x <= 32'h00000006;
	i_source_nb_force.y <= 32'h00000006;
	i_source_nb_force.z <= 32'h00000006;
	i_source_nb_parid <= 6;
	i_source_nb_gcid <= 9'b000000000;
	i_source_nb_valid <= 1;
	
	#2
	i_nb_force_valid <= 0;
	i_source_nb_valid <= 0;
	end

force_output_ring_node
#(
    .GCELL_X({3'b000}),
    .GCELL_Y({3'b000}),
    .GCELL_Z({3'b000})
)
force_output_ring_node
(
    .clk(clk), 
    .rst(rst), 
    .i_nb_force(i_nb_force), 
    .i_nb_force_valid(i_nb_force_valid), 
    .i_source_nb_force(i_source_nb_force), 
    .i_source_nb_parid(i_source_nb_parid), 
    .i_source_nb_gcid(i_source_nb_gcid), 
    .i_source_nb_valid(i_source_nb_valid), 
    
    .o_dest_nb_force(o_dest_nb_force), 
    .o_dest_nb_parid(o_dest_nb_parid), 
    .o_dest_nb_gcid(o_dest_nb_gcid), 
    .o_dest_nb_valid(o_dest_nb_valid), 
    .o_nb_force_to_force_cache(o_nb_force_to_force_cache), 
    .o_nb_force_to_force_cache_valid(o_nb_force_to_force_cache_valid), 
    .o_nb_parid_to_force_cache(o_nb_parid_to_force_cache), 
    .o_buffer_empty(o_buffer_empty)
);

endmodule
