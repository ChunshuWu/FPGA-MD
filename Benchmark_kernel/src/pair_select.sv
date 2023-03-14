//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 03:27:08 PM
// Design Name: 
// Module Name: pair_select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 1 cycle delay
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module pair_select(
    input clk, 
    input rst, 
    input [NUM_FILTERS-1:0]                             i_filter_output_arb_result, 
    input [NUM_FILTERS-1:0]                             i_filter_buffer_readout_valid, 
    input [NUM_FILTERS-1:0][POS_PKT_STRUCT_WIDTH-1:0]   i_nb_reg, 
    input [NUM_FILTERS-1:0][PARTICLE_ID_WIDTH-1:0]      i_filter_buffer_readout, 
    
    output logic [POS_PKT_STRUCT_WIDTH-1:0]             o_nb_selected, 
    output logic [PARTICLE_ID_WIDTH-1:0]                o_home_selected_parid, 
    output logic                                        o_pair_selected_valid
);

logic [POS_PKT_STRUCT_WIDTH-1:0] nb_selected;
logic [PARTICLE_ID_WIDTH-1:0] home_selected_parid; 
logic pair_selected_valid;
assign pair_selected_valid =  |i_filter_buffer_readout_valid;

always_comb
    begin
    nb_selected = 0;
    home_selected_parid = 0;
    for (int i = 0; i < NUM_FILTERS; i++)
        begin
        if (i_filter_output_arb_result == (1 << i))
            begin
            nb_selected = i_nb_reg[i];
            home_selected_parid = i_filter_buffer_readout[i];
            end
        end
    end
//for (genvar i = 0; i < NUM_FILTERS; i++)
//    begin
//    assign nb_selected = i_filter_output_arb_result[i] ? i_nb_reg[i] : 0;
//    assign home_selected_parid = i_filter_output_arb_result[i] ? i_filter_buffer_readout[i] : 0;
//    end

always@(posedge clk)
    begin
    if (rst)
        begin
        o_nb_selected <= 0;
        o_home_selected_parid <= 0;
        o_pair_selected_valid <= 0;
        end
    else
        begin
        o_nb_selected <= nb_selected;
        o_home_selected_parid <= home_selected_parid;
        o_pair_selected_valid <= pair_selected_valid;
        end
    end

endmodule
