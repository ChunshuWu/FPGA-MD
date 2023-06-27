`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 05:14:23 PM
// Design Name: 
// Module Name: pos_input_ring_node_ext_tb
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

module pos_input_ring_node_ext_tb;

logic                                      clk; 
logic                                      rst; 
logic [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_source_offset_pkt;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_source_gcid; 				// from the previous node
logic [NB_CELL_COUNT_WIDTH-1:0]            i_source_lifetime; 	            // Used as valid
logic [NB_CELL_COUNT_WIDTH-1:0]            i_source_lifetime_split_remote;     // The number of lifetime to be consumed remotely

logic [OFFSET_PKT_STRUCT_WIDTH-1:0]        i_remote_offset_pkt; 						// from remote
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]         i_remote_gcid; 
logic                                      i_remote_valid; 
logic [NB_CELL_COUNT_WIDTH-1:0]            i_remote_lifetime;
logic                                      i_remote_buffer_back_pressure;

logic [OFFSET_PKT_STRUCT_WIDTH-1:0]     o_offset_pkt_to_ring; 
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]      o_gcid_to_ring; 		// to the next node
logic [NB_CELL_COUNT_WIDTH-1:0]         o_lifetime_to_ring; 
logic [NB_CELL_COUNT_WIDTH-1:0]         o_lifetime_split_remote_to_ring;

logic [OFFSET_PKT_STRUCT_WIDTH-1:0]     o_offset_pkt_to_remote; 								// to remote
logic [3*GLOBAL_CELL_ID_WIDTH-1:0]      o_gcid_to_remote; 
logic                                   o_offset_pkt_to_remote_valid; 
logic [NB_CELL_COUNT_WIDTH-1:0]         o_lifetime_to_remote;
logic                                   o_remote_ack;                         // tell remote pos controller the remote data is received
logic                                   o_node_empty;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	i_remote_offset_pkt <= 0;
	i_remote_gcid <= 0;
	i_remote_valid <= 0;
	i_remote_lifetime <= 0;
	i_remote_buffer_back_pressure <= 0;
	
	#20
	rst <= 1'b0;
	i_remote_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000001;
	i_remote_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000002;
	i_remote_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000003;
	i_remote_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 1;
	i_remote_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_remote_valid <= 1;
	i_remote_gcid <= 9'b000000000;
	i_remote_lifetime <= 4;
	
	#2
	i_remote_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000004;
	i_remote_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000005;
	i_remote_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000006;
	i_remote_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 2;
	i_remote_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b10;
	i_remote_gcid <= 9'b010010010;
	i_remote_lifetime <= 0;
	
	#2
	i_remote_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000007;
	i_remote_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000008;
	i_remote_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000009;
	i_remote_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 3;
	i_remote_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_remote_gcid <= 9'b001001001;
	i_remote_lifetime <= 3;
	
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h00000a;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h00000b;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h00000c;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 4;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b10;
	i_source_gcid <= 9'b111111111;
	i_source_lifetime <= 8;
	i_source_lifetime_split_remote <= 3;
	
	#2
	i_remote_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h00000d;
	i_remote_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h00000e;
	i_remote_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h00000f;
	i_remote_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 5;
	i_remote_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b01;
	i_remote_gcid <= 9'b010010010;
	i_remote_lifetime <= 3;
	
	i_source_offset_pkt[OFFSET_WIDTH-1:0] <= 23'h000010;
	i_source_offset_pkt[2*OFFSET_WIDTH-1:OFFSET_WIDTH] <= 23'h000011;
	i_source_offset_pkt[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH] <= 23'h000012;
	i_source_offset_pkt[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] <= 6;
	i_source_offset_pkt[POS_STRUCT_WIDTH +: ELEMENT_WIDTH] <= 2'b10;
	i_source_gcid <= 9'b100100100;
	i_source_lifetime <= 0;
	i_source_lifetime_split_remote <= 0;
	
	end

pos_input_ring_node_ext pos_input_ring_node_ext (
    .clk                                ( clk                                       ),
    .rst                                ( rst                                       ), 
    .i_source_offset_pkt                ( i_source_offset_pkt                        ), 
    .i_source_gcid                      ( i_source_gcid                              ), 
    .i_source_lifetime                  ( i_source_lifetime                          ),
    .i_source_lifetime_split_remote     ( i_source_lifetime_split_remote             ),
    .i_remote_offset_pkt                ( i_remote_offset_pkt                         ), 
    .i_remote_gcid                      ( i_remote_gcid                               ), 
    .i_remote_valid                     ( i_remote_valid                              ),
    .i_remote_lifetime                  ( i_remote_lifetime                           ),
    .i_remote_buffer_back_pressure      ( i_remote_buffer_back_pressure               ),
    
    .o_offset_pkt_to_ring               ( o_offset_pkt_to_ring                            ), 
    .o_gcid_to_ring                     ( o_gcid_to_ring                                  ), 
    .o_lifetime_to_ring                 ( o_lifetime_to_ring                              ), 
    .o_lifetime_split_remote_to_ring    ( o_lifetime_split_remote_to_ring                 ), 
    .o_offset_pkt_to_remote             ( o_offset_pkt_to_remote                      ),
    .o_gcid_to_remote                   ( o_gcid_to_remote                            ), 
    .o_offset_pkt_to_remote_valid       ( o_offset_pkt_to_remote_valid                ),
    .o_lifetime_to_remote               ( o_lifetime_to_remote                        ),
    .o_node_empty                       ( o_node_empty                     ),
    .o_remote_ack                       ( o_remote_ack                                )
);

endmodule
