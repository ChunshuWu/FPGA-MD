//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2022 04:45:57 PM
// Design Name: 
// Module Name: filter_dispatcher_delay_signals
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

module filter_dispatcher_delay_signals(
    input clk, 
    input rst, 
    input [POS_PKT_STRUCT_WIDTH-1:0]                                i_nb_data, 
    input [NODE_ID_WIDTH-1:0]                                       i_node_id, 
    input [OFFSET_PKT_STRUCT_WIDTH-1:0]                             i_home_data, 
    input [NUM_FILTERS-1:0]                                         i_filter_input_arb_result, 
    input [NUM_FILTERS-1:0]                                         i_filter_output_arb_result, 
    input                                                           i_pair_selected_valid, 
    input [POS_PKT_STRUCT_WIDTH-1:0]                                i_nb_selected, 
    input [NODE_ID_WIDTH-1:0]                                       i_node_id_selected, 
    input [PARTICLE_ID_WIDTH-1:0]                                   i_home_selected_parid, 
    input                                                           i_nb_reg_release_flag, 
    
    output logic [NUM_FILTER_SOURCES-1:0][POS_PKT_STRUCT_WIDTH-1:0] o_nb_data, 
    output logic [NUM_FILTER_SOURCES-1:0][NODE_ID_WIDTH-1:0]        o_node_id, 
    output logic [NUM_FILTER_SOURCES-1:0]                           o_nb_from_home_cell_flag, 
    output logic [NUM_FILTER_SOURCES-1:0][POS_STRUCT_WIDTH-1:0]     o_home_pos, 
    output logic [NUM_FILTER_SOURCES-1:0][PARTICLE_ID_WIDTH-1:0]    o_home_parid, 
    output logic [NUM_FILTER_SOURCES-1:0][ELEMENT_WIDTH-1:0]        o_home_element,
    output logic [NUM_FILTERS-1:0]                                  o_filter_input_arb_result_delay_1, 
    output logic [NUM_FILTERS-1:0]                                  o_filter_input_arb_result_delay_2, 
    output logic [NUM_FILTERS-1:0]                                  o_filter_output_arb_result_delay_1, 
    output logic [NUM_FILTERS-1:0]                                  o_filter_output_arb_result_delay_3, 
    output logic                                                    o_pair_selected_valid, 
    output logic [POS_PKT_STRUCT_WIDTH-1:0]                         o_nb_selected, 
    output logic [NODE_ID_WIDTH-1:0]                                o_node_id_selected,
    output logic [PARTICLE_ID_WIDTH-1:0]                            o_home_selected_parid, 
    output logic                                                    o_nb_reg_release_flag_delay_2
);

localparam CELL_2 = 2'b10;

logic                   nb_reg_release_flag_delay_1;  // no need to output
logic [NUM_FILTERS-1:0] filter_output_arb_result_delay_2;

always_ff @(posedge clk)    // Simply delay
    begin
    if (rst)
        begin
        o_filter_input_arb_result_delay_1 <= 0;
        o_filter_input_arb_result_delay_2 <= 0;
        o_filter_output_arb_result_delay_1 <= 0;
        filter_output_arb_result_delay_2 <= 0;
        o_filter_output_arb_result_delay_3 <= 0;
        o_pair_selected_valid <= 0;
        o_nb_selected <= 0;
        o_node_id_selected <= 0;
        o_home_selected_parid <= 0;
        nb_reg_release_flag_delay_1 <= 0;
        o_nb_reg_release_flag_delay_2 <= 0;
        end
    else
        begin
        o_filter_input_arb_result_delay_1 <= i_filter_input_arb_result;
        o_filter_input_arb_result_delay_2 <= o_filter_input_arb_result_delay_1;
        o_filter_output_arb_result_delay_1 <= i_filter_output_arb_result;
        filter_output_arb_result_delay_2 <= o_filter_output_arb_result_delay_1;
        o_filter_output_arb_result_delay_3 <= filter_output_arb_result_delay_2;
        o_pair_selected_valid <= i_pair_selected_valid;
        o_nb_selected <= i_nb_selected;
        o_node_id_selected <= i_node_id_selected;
        o_home_selected_parid <= i_home_selected_parid;
        nb_reg_release_flag_delay_1 <= i_nb_reg_release_flag;
        o_nb_reg_release_flag_delay_2 <= nb_reg_release_flag_delay_1; 
        end
    end

logic nb_from_home_cell_flag;
assign nb_from_home_cell_flag = ~(i_nb_data[DATA_WIDTH-2] |    // home CID: 10. nb: 11 or 01
                                i_nb_data[2*DATA_WIDTH-2] |
                                i_nb_data[3*DATA_WIDTH-2]);

always_ff @(posedge clk)    // Reg duplication to reduce fanout, if too many filters, need to add more layers!!!
	begin
	for (int i = 0; i < NUM_FILTER_SOURCES; i++)
	   begin
        if (rst)
            begin
    		o_home_pos[i] <= 0;
    		o_home_parid[i] <= 0;
    		o_home_element[i] <= 0;
            o_nb_data[i] <= 0;
            o_node_id[i] <= 0;
            o_nb_from_home_cell_flag[i] <= 0;
            end
        else
            begin
            o_home_pos[i][DATA_WIDTH-1:0]               <= {CELL_2, i_home_data[OFFSET_WIDTH-1:0]};
            o_home_pos[i][2*DATA_WIDTH-1:DATA_WIDTH]    <= {CELL_2, i_home_data[2*OFFSET_WIDTH-1:OFFSET_WIDTH]};
            o_home_pos[i][3*DATA_WIDTH-1:2*DATA_WIDTH]  <= {CELL_2, i_home_data[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]};
            o_home_parid[i]                             <= i_home_data[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]; 
            o_home_element[i]                           <= i_home_data[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH];
            o_nb_data[i]                                <= i_nb_data;
            o_node_id[i]                                <= i_node_id;
            o_nb_from_home_cell_flag[i]                 <= nb_from_home_cell_flag;
            end
        end
	end


endmodule
