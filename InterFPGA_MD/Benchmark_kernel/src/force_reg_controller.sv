//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 05:11:45 AM
// Design Name: 
// Module Name: force_reg_controller
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

module force_reg_controller
(
    input clk, 
    input rst, 
    input i_release_select,    // i_select is guaranteed 0 when i_release is 1
    input i_select, 
    input float_data_t i_force, 
    input [3*CELL_ID_WIDTH-1:0] i_nb_cid, 
    input [PARTICLE_ID_WIDTH-1:0] i_nb_parid, 
    
    output force_packet_t o_reg
);

always@(posedge clk)
    begin
    if (rst)
        begin
        o_reg <= 0;
        end
    else
        begin
        if (i_release_select)
            begin
            o_reg <= 0;
            end
        else if (i_select)
            begin
            o_reg.f <= i_force;
            o_reg.cid <= i_nb_cid;
            o_reg.parid <= i_nb_parid;
            end
        end
    end

endmodule
