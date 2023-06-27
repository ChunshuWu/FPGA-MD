`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2022 02:54:29 PM
// Design Name: 
// Module Name: vcell_wrapper
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

module vcell_wrapper(
    input clk, 
    input [FLOAT_STRUCT_WIDTH-1:0] vel_in_0,
    input [PARTICLE_ID_WIDTH-1:0] wr_addr_0, 
    input wr_en_0, 
    input [PARTICLE_ID_WIDTH-1:0] rd_addr_0, 
    
    output [FLOAT_STRUCT_WIDTH-1:0] vel_out_0
);
    
VEL_CACHE vel_cell_0
(
    .clk        ( clk       ), 
    .vel_in     ( vel_in_0  ), 
    .wr_addr    ( wr_addr_0 ), 
    .wr_en      ( wr_en_0   ), 
    .rd_addr    ( rd_addr_0 ), 
    
    .vel_out    ( vel_out_0 )
);

endmodule
