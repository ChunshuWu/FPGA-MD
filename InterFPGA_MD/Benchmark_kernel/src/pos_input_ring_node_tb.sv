//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 09:59:06 PM
// Design Name: 
// Module Name: pos_input_ring_node_tb
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

module pos_input_ring_node_tb;

logic clk;
logic rst;
offset_packet_t i_source_offset_pkt;
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] i_source_gcid; 				// from the previous node
logic [NB_CELL_COUNT_WIDTH-1:0] i_source_lifetime; 	            // Used as valid
offset_packet_t i_local_offset_pkt; 						// from pos cache
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] i_local_gcid; 
logic i_local_dirty; 
logic i_local_valid; 
logic i_dispatcher_back_pressure; 					            // from any PE, if one back pressure, block all data from pos caches to the ring

offset_packet_t o_offset_pkt_to_ring; 
logic [3*GLOBAL_CELL_ID_WIDTH-1:0] o_gcid_to_ring; 		// to the next node
logic [NB_CELL_COUNT_WIDTH-1:0] o_lifetime_to_ring; 
pos_packet_t o_pos_pkt_to_pe; 								// to PE
logic o_pos_pkt_to_pe_valid; 
logic o_dirty_feedback;                                           // Back to pos cache for dirty tagging

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_source_offset_pkt <= 0;
	i_source_gcid <= 0;
	i_source_lifetime <= 0;
	i_local_offset_pkt <= 0;
	i_local_gcid <= 0;
	i_local_dirty <= 0;
	i_local_valid <= 0;
	i_dispatcher_back_pressure <= 0;
	
	#20
	rst <= 1'b0;
	i_local_offset_pkt.offset.offset_x <= 23'h000001;
	i_local_offset_pkt.offset.offset_y <= 23'h000002;
	i_local_offset_pkt.offset.offset_z <= 23'h000003;
	i_local_offset_pkt.parid <= 1;
	i_local_offset_pkt.element <= 2'b01;
	i_local_valid <= 1;
	i_local_gcid <= 9'b000000000;
	
	#20
	i_local_dirty <= 1;
	i_local_offset_pkt.parid <= 2;
	i_local_offset_pkt.element <= 2'b10;
	i_local_gcid <= 9'b000000010;
	
	#20
	i_local_dirty <= 0;
	i_local_offset_pkt.parid <= 3;
	i_local_offset_pkt.element <= 2'b01;
	i_local_gcid <= 9'b000000100;
	
//	#20
//	i_rd_dirty <= 0;
//	i_preload <= 0;
//	i_rd_particle_info.parid <= 3;
//	i_rd_particle_info.element <= 2'b01;
//	i_rd_gcid <= 9'b000000110;
	
//	#20
//	i_preload <= 0;
//	i_rd_particle_info.offset.offset_x <= 23'h000004;
//	i_rd_particle_info.offset.offset_y <= 23'h000005;
//	i_rd_particle_info.offset.offset_z <= 23'h000006;
//	i_rd_particle_info.parid <= 4;
//	i_rd_particle_info.element <= 2'b10;
//	i_rd_gcid <= 9'b000000000;
//	i_source_particle_info.offset.offset_x <= 23'h000007;
//	i_source_particle_info.offset.offset_y <= 23'h000008;
//	i_source_particle_info.offset.offset_z <= 23'h000009;
//	i_source_particle_info.parid <= 5;
//	i_source_particle_info.element <= 2'b01;
//	i_source_gcid <= 9'b111111111;
//	i_source_lifetime <= 10;
	
//	#20
//	i_rd_dirty <= 0;
//	i_source_particle_info.offset.offset_x <= 23'h00000a;
//	i_source_particle_info.offset.offset_y <= 23'h00000b;
//	i_source_particle_info.offset.offset_z <= 23'h00000c;
//	i_source_particle_info.parid <= 6;
//	i_source_particle_info.element <= 2'b10;
//	i_source_gcid <= 9'b111111001;
//	i_source_lifetime <= 9;
	
//	#20
//	i_source_particle_info.offset.offset_x <= 23'h00000d;
//	i_source_particle_info.offset.offset_y <= 23'h00000e;
//	i_source_particle_info.offset.offset_z <= 23'h00000f;
//	i_source_particle_info.parid <= 7;
//	i_source_particle_info.element <= 2'b01;
//	i_source_gcid <= 9'b111111011;
//	i_source_lifetime <= 8;
	
	
	end

pos_input_ring_node
#(
    .GCELL_X({3'b000}),
    .GCELL_Y({3'b000}),
    .GCELL_Z({3'b000})
)
pos_input_ring_node (
    .clk                         ( clk                                           ),
    .rst                         ( rst                                           ), 
    .i_source_offset_pkt         ( i_source_offset_pkt    ), 
    .i_source_gcid               ( i_source_gcid          ), 
    .i_source_lifetime           ( i_source_lifetime      ),
    .i_local_offset_pkt          ( i_local_offset_pkt                           ), 
    .i_local_gcid                ( i_local_gcid                                 ), 
    .i_local_valid               ( i_local_valid                                ),
    .i_local_dirty               ( i_local_dirty                                ),
    .i_dispatcher_back_pressure  ( i_dispatcher_back_pressure                   ),
    
    .o_offset_pkt_to_ring        ( o_offset_pkt_to_ring                            ), 
    .o_gcid_to_ring              ( o_gcid_to_ring                                  ), 
    .o_lifetime_to_ring          ( o_lifetime_to_ring                              ), 
    .o_pos_pkt_to_pe             ( o_pos_pkt_to_pe                              ), 
    .o_pos_pkt_to_pe_valid       ( o_pos_pkt_to_pe_valid                        ),
    .o_dirty_feedback            ( o_dirty_feedback                             )
);

endmodule
