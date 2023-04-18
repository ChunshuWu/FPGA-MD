//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 05:04:35 AM
// Design Name: 
// Module Name: reg_select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Used to select both the acc register and the release register 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module reg_select
(
    input force_packet_t [NUM_FILTERS-1:0] i_nb_regs, 
    input [NUM_FILTERS-1:0] i_reg_select, 
    input [NUM_FILTERS-1:0] i_reg_release_select, 
    
    output force_packet_t o_nb_reg, 
    output force_packet_t o_nb_reg_release, 
    output logic o_nb_reg_release_valid
);

always_comb
    begin
    o_nb_reg = 0;
    for (int i = 0; i < NUM_FILTERS; i++)
        begin
        if (i_reg_select == (1 << i))
            begin
            o_nb_reg = i_nb_regs[i];
            end
        end
    end
   
always_comb
    begin
    o_nb_reg_release = 0;
    o_nb_reg_release_valid = 1'b0;
    for (int i = 0; i < NUM_FILTERS; i++)
        begin
        if (i_reg_release_select == (1 << i))
            begin
            o_nb_reg_release = i_nb_regs[i];
            o_nb_reg_release_valid = 1'b1;
            end
        end
    end
endmodule
