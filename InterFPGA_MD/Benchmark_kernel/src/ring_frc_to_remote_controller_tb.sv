`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2023 04:11:35 PM
// Design Name: 
// Module Name: ring_pos_to_remote_controller_chain_tb
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

module ring_frc_to_remote_controller_tb;
    
logic                                           clk;
logic                                           rst;
logic           [NODE_ID_WIDTH-1:0]             i_init_id;                                  // Assume 8 nodes, 3 bits
logic                                           i_remote_frc_eval_flag;
logic           [FLOAT_STRUCT_WIDTH-1:0]        i_frc_to_remote; 					// to remote
logic           [3*GLOBAL_CELL_ID_WIDTH-1:0]    i_frc_gcid_to_remote;
logic                                           i_frc_to_remote_valid;
logic           [PARTICLE_ID_WIDTH-1:0]         i_frc_parid_to_remote;
logic           [NUM_REMOTE_DEST_NODES-1:0]     i_frc_ticket;

logic           [AXIS_PKT_STRUCT_WIDTH-1:0]     o_axis_frc_pkt_to_remote;                  // to remote
logic                                           o_frc_burst_running;
logic                                           o_last_frc_sent;
always #1 clk <= ~clk;

always@(posedge clk) begin
    if (rst) begin
	   i_frc_parid_to_remote <= 0;
    end
    else begin
	   i_frc_parid_to_remote <= i_frc_parid_to_remote + 1'b1;
    end
end
initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	i_init_id <= 0;
	i_remote_frc_eval_flag <= 0;
	i_frc_to_remote <= 0;
	i_frc_gcid_to_remote <= 0;
	i_frc_to_remote_valid <= 0;
	i_frc_ticket <= 0;
	
	#20
	rst <= 1'b0;
	i_init_id <= 3'b000;
	i_frc_to_remote[FLOAT_WIDTH-1:0]                <= 32'h3f800000;
	i_frc_to_remote[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    <= 32'h3f800000;
	i_frc_to_remote[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  <= 32'h3f800000;
	i_frc_gcid_to_remote <= 9'b010010010;
	i_frc_to_remote_valid <= 1'b1;
	i_frc_ticket <= 3'b001;
	#20
	i_frc_ticket <= 3'b010;
	#20
	i_frc_ticket <= 3'b100;
	#2
	i_frc_ticket <= 3'b001;
	#2
	i_frc_ticket <= 3'b010;
	#2
	i_frc_ticket <= 3'b100;
	#2
	i_frc_ticket <= 3'b001;
	#2
	i_frc_ticket <= 3'b010;
	#2
	i_frc_ticket <= 3'b100;
	#2
	i_frc_ticket <= 3'b001;
	#2
	i_frc_ticket <= 3'b010;
	#2
	i_frc_ticket <= 3'b100;
	
	#20
	i_remote_frc_eval_flag <= 1'b1;
	i_frc_to_remote_valid <= 1'b0;
	
end

ring_frc_to_remote_controller ring_frc_to_remote_controller (
    .clk                            ( clk                           ), 
    .rst                            ( rst                           ),
    .i_init_id                      ( i_init_id                     ),      // tbc
    .i_remote_frc_eval_flag         ( i_remote_frc_eval_flag        ),
    .i_frc_to_remote                ( i_frc_to_remote               ),
    .i_frc_gcid_to_remote           ( i_frc_gcid_to_remote          ),
    .i_frc_to_remote_valid          ( i_frc_to_remote_valid         ),
    .i_frc_parid_to_remote          ( i_frc_parid_to_remote         ),
    .i_frc_ticket                   ( i_frc_ticket                  ),
    
    .o_axis_frc_pkt_to_remote       ( o_axis_frc_pkt_to_remote      ),
    .o_frc_burst_running            ( o_frc_burst_running           ),
    .o_last_frc_sent                ( o_last_frc_sent               )
);

endmodule
