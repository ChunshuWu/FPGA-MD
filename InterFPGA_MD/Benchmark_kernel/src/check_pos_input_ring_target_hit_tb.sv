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

module check_pos_input_ring_target_hit_tb;

logic [3*GLOBAL_CELL_ID_WIDTH-1:0] i_gcid;
logic o_hit;

initial
	begin
	i_gcid = 9'b000000000;
	#2
	i_gcid = 9'b000000001;
	#2
	i_gcid = 9'b000001000;
	#2
	i_gcid = 9'b000001001;
	#2
	i_gcid = 9'b001000000;
	#2
	i_gcid = 9'b001000001;
	#2
	i_gcid = 9'b001001000;
	#2
	i_gcid = 9'b001001001;
	end


check_pos_input_ring_target_hit
#(
    .GCELL_X('{3'h1}), 
    .GCELL_Y('{3'h1}), 
    .GCELL_Z('{3'h1})
)
check_hit
(
    .i_gcid(i_gcid), 
    
    .o_hit(o_hit)
);

endmodule