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

module force_output_ring_tb;

logic                                                   clk; 
logic                                                   rst; 

force_packet_t [NUM_CELLS-1:0]                          i_nb_force;
logic [NUM_CELLS-1:0]                                   i_nb_force_valid;

float_data_t [NUM_CELLS-1:0]                            o_nb_force_to_force_cache;
logic [NUM_CELLS-1:0]                                   o_nb_force_to_force_cache_valid;
logic [NUM_CELLS-1:0][PARTICLE_ID_WIDTH-1:0]            o_nb_parid_to_force_cache;

logic [NUM_CELLS-1:0]                                   o_force_output_ring_buf_empty;
logic [NUM_CELLS-1:0]                                   o_nb_valid_ring;

always #1 clk <= ~clk;
initial
	begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_nb_force <= 0;
	i_nb_force_valid <= 0;
	
	#20
	rst <= 1'b0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000001;
	i_nb_force[0].f.y <= 32'h00000001;
	i_nb_force[0].f.z <= 32'h00000001;
    i_nb_force[0].cid <= 6'b111010;
    i_nb_force[0].parid <= 1;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000002;
	i_nb_force[0].f.y <= 32'h00000002;
	i_nb_force[0].f.z <= 32'h00000002;
    i_nb_force[0].cid <= 6'b011110;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000003;
	i_nb_force[0].f.y <= 32'h00000003;
	i_nb_force[0].f.z <= 32'h00000003;
    i_nb_force[0].cid <= 6'b101110;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000004;
	i_nb_force[0].f.y <= 32'h00000004;
	i_nb_force[0].f.z <= 32'h00000004;
    i_nb_force[0].cid <= 6'b111110;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000005;
	i_nb_force[0].f.y <= 32'h00000005;
	i_nb_force[0].f.z <= 32'h00000005;
    i_nb_force[0].cid <= 6'b010111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000006;
	i_nb_force[0].f.y <= 32'h00000006;
	i_nb_force[0].f.z <= 32'h00000006;
    i_nb_force[0].cid <= 6'b100111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000007;
	i_nb_force[0].f.y <= 32'h00000007;
	i_nb_force[0].f.z <= 32'h00000007;
    i_nb_force[0].cid <= 6'b110111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000008;
	i_nb_force[0].f.y <= 32'h00000008;
	i_nb_force[0].f.z <= 32'h00000008;
    i_nb_force[0].cid <= 6'b011011;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h00000009;
	i_nb_force[0].f.y <= 32'h00000009;
	i_nb_force[0].f.z <= 32'h00000009;
    i_nb_force[0].cid <= 6'b101011;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h0000000a;
	i_nb_force[0].f.y <= 32'h0000000a;
	i_nb_force[0].f.z <= 32'h0000000a;
    i_nb_force[0].cid <= 6'b111011;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h0000000b;
	i_nb_force[0].f.y <= 32'h0000000b;
	i_nb_force[0].f.z <= 32'h0000000b;
    i_nb_force[0].cid <= 6'b011111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h0000000c;
	i_nb_force[0].f.y <= 32'h0000000c;
	i_nb_force[0].f.z <= 32'h0000000c;
    i_nb_force[0].cid <= 6'b101111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
	
	#30
	i_nb_force[0].f.x <= 32'h0000000d;
	i_nb_force[0].f.y <= 32'h0000000d;
	i_nb_force[0].f.z <= 32'h0000000d;
    i_nb_force[0].cid <= 6'b111111;
    i_nb_force_valid[0] <= 1;
    
    #2
    i_nb_force_valid[0] <= 0;
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000001;
//        i_nb_force[i].f.y <= 32'h00000001;
//        i_nb_force[i].f.z <= 32'h00000001;
//        i_nb_force[i].cid <= 6'b101010;
//        i_nb_force[i].parid <= 1;
//        i_nb_force_valid[i] <= 1;
//    end
	
//	#2 
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000003;
//        i_nb_force[i].f.y <= 32'h00000003;
//        i_nb_force[i].f.z <= 32'h00000003;
//        i_nb_force[i].cid <= 6'b111111;
//        i_nb_force[i].parid <= 3;
//    end
	
//	#2 
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000004;
//        i_nb_force[i].f.y <= 32'h00000004;
//        i_nb_force[i].f.z <= 32'h00000004;
//        i_nb_force[i].cid <= 6'b010101;
//        i_nb_force[i].parid <= 4;
//    end
	
//	#2 
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000005;
//        i_nb_force[i].f.y <= 32'h00000005;
//        i_nb_force[i].f.z <= 32'h00000005;
//        i_nb_force[i].cid <= 6'b101010;
//        i_nb_force[i].parid <= 5;
//    end
	
//	#2 
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000006;
//        i_nb_force[i].f.y <= 32'h00000006;
//        i_nb_force[i].f.z <= 32'h00000006;
//        i_nb_force[i].parid <= 6;
//    end
	
//	#2 
//	for (int i = 0; i < NUM_CELLS; i++) begin
//        i_nb_force[i].f.x <= 32'h00000007;
//        i_nb_force[i].f.y <= 32'h00000007;
//        i_nb_force[i].f.z <= 32'h00000007;
//        i_nb_force[i].parid <= 7;
//    end
	
//	#2
//	i_nb_force_valid <= 0;
	end
	
force_output_ring inst_frc_output_ring (
    .clk                                ( clk                    ),
    .rst                                ( rst                 ),
    .i_nb_force                         ( i_nb_force            ),
    .i_nb_force_valid                   ( i_nb_force_valid      ),
    
    .o_nb_force_to_force_cache          ( o_nb_force_to_force_cache                    ),
    .o_nb_parid_to_force_cache          ( o_nb_parid_to_force_cache              ),
    .o_nb_force_to_force_cache_valid    ( o_nb_force_to_force_cache_valid              ),
    
    .o_force_output_ring_buf_empty      ( o_force_output_ring_buf_empty ),
    .o_nb_valid_ring                    ( o_nb_valid_ring   )
);

endmodule
