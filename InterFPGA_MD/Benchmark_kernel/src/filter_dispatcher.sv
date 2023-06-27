//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 05:56:43 PM
// Design Name: 
// Module Name: filter_dispatcher
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Includes 6 filters
//     Incoming nb data are stored in a buffer with local cell id
//     Home positions are stored in a RAM block upon arrival (pos cache duplication)
//     A nb particle is sent to 1 filter at a time (round-robin), if the filter has an empty slot
//     Data from filter buffers are arbitrated
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module filter_dispatcher
(
	input                                  clk, 
	input                                  rst, 
//	input offset_packet_t                  home_offset,
//	input                                  home_offset_valid, 
//	input pos_packet_t                     nb_pos, // pos_x, y, z, parid, element
//	input                                  nb_pos_valid, 

//	output pos_data_t                      home_pos_data, 		// should be aligned with nb_pos_to_eval
//	output logic [PARTICLE_ID_WIDTH-1:0]   home_parid, 
//	output [ELEMENT_WIDTH-1:0]             home_element, 
//	output pos_packet_t                    nb_pos, 
//	output logic [NUM_FILTERS-1:0]         nb_reg_release_sel, // delayed 2 cycles from nb_reg_release to be aligned with data output
//	output logic [NUM_FILTERS-1:0]         nb_reg_sel, 
//	output logic                           pair_valid, 
//	output                                 dispatcher_back_pressure, 
//	output                                 dispatcher_buffer_empty
	
	input                                  i_pos_spinning,
	input [OFFSET_PKT_STRUCT_WIDTH-1:0]    i_home_data,
	input                                  i_home_data_valid, 
	input [POS_PKT_STRUCT_WIDTH-1:0]       i_nb_data, // pos_x, y, z, parid, element
	input [NODE_ID_WIDTH-1:0]              i_node_id,
	input                                  i_nb_data_valid, 

	output logic                           o_nb_release_flag, // delayed 2 cycles from nb_reg_release to be aligned with data output
	output [POS_STRUCT_WIDTH-1:0]          o_home_pos, 		// should be aligned with nb_pos_to_eval
	output [ELEMENT_WIDTH-1:0]             o_home_element, 
	output [POS_PKT_STRUCT_WIDTH-1:0]      o_nb_reg, 
	output [NODE_ID_WIDTH-1:0]             o_node_id_reg,
	output logic [PARTICLE_ID_WIDTH-1:0]   o_home_parid, 
	output logic                           o_pair_valid, 
	output logic [NUM_FILTERS-1:0]         o_acc_reg_select, 
	output                                 o_dispatcher_back_pressure, 
	output                                 o_dispatcher_buffer_empty,
	output logic                           o_filter_buffer_empty,
	output logic                           o_filter_back_pressure,
    output logic [NUM_FILTERS-1:0]         o_filtering_flag
);

// filter input signals
logic [NUM_FILTER_SOURCES-1:0][POS_PKT_STRUCT_WIDTH-1:0]    nb_data;
logic [NUM_FILTER_SOURCES-1:0][NODE_ID_WIDTH-1:0]           nb_node_id;
logic [NUM_FILTER_SOURCES-1:0]                              nb_from_home_cell_flag;
logic [NUM_FILTER_SOURCES-1:0][POS_STRUCT_WIDTH-1:0]        home_pos;
logic [NUM_FILTER_SOURCES-1:0][PARTICLE_ID_WIDTH-1:0]       home_parid;
logic [NUM_FILTER_SOURCES-1:0][ELEMENT_WIDTH-1:0]           home_element;

// filter output signals
logic                                               nb_reg_release_flag;
logic [NUM_FILTERS-1:0]                             nb_reg_release;
logic [NUM_FILTERS-1:0]                             nb_reg_request;
logic [NUM_FILTERS-1:0]                             filter_output_request;
logic [NUM_FILTERS-1:0]                             back_pressure;
logic [NUM_FILTERS-1:0][PARTICLE_ID_WIDTH-1:0]      filter_buffer_readout;
logic [NUM_FILTERS-1:0]                             filter_buffer_readout_valid;
logic [NUM_FILTERS-1:0][POS_PKT_STRUCT_WIDTH-1:0]   nb_reg;
logic [NUM_FILTERS-1:0][NODE_ID_WIDTH-1:0]          node_id_reg;
logic [NUM_FILTERS-1:0]                             filter_buffer_empty;

assign o_filter_back_pressure = | back_pressure;
assign o_filter_buffer_empty = & filter_buffer_empty;

// filter input arbiter signals
logic [NUM_FILTERS-1:0] filter_input_nb_request_flag;
logic [NUM_FILTERS-1:0] filter_input_arb_result;
logic [NUM_FILTERS-1:0] filter_input_arb_result_delay_1;
logic [NUM_FILTERS-1:0] filter_input_arb_result_delay_2;

// dispatcher buffer signals
logic                                           dispatcher_buffer_rden;
logic [POS_PKT_STRUCT_WIDTH+NODE_ID_WIDTH-1:0]  dispatcher_buffer_readout;
logic [POS_PKT_STRUCT_WIDTH-1:0]                dispatcher_buffer_data_readout;
logic [NODE_ID_WIDTH-1:0]                       dispatcher_buffer_node_id_readout;

assign dispatcher_buffer_data_readout       = dispatcher_buffer_readout[POS_PKT_STRUCT_WIDTH+NODE_ID_WIDTH-1:NODE_ID_WIDTH];
assign dispatcher_buffer_node_id_readout    = dispatcher_buffer_readout[NODE_ID_WIDTH-1:0];

// filter output arbiter signals
logic [NUM_FILTERS-1:0] filter_output_arb_result;
logic [NUM_FILTERS-1:0] filter_output_arb_result_delay_1;

// pair select signals
logic [POS_PKT_STRUCT_WIDTH-1:0]    nb_selected;
logic [NODE_ID_WIDTH-1:0]           node_id_selected;
logic [PARTICLE_ID_WIDTH-1:0]       home_selected_parid;
logic                               pair_selected_valid;


filter_dispatcher_delay_signals filter_dispatcher_delay_signals
(
    .clk(clk), 
    .rst(rst), 
    .i_nb_data(dispatcher_buffer_data_readout), 
    .i_node_id(dispatcher_buffer_node_id_readout), 
    .i_home_data(i_home_data), 
    .i_filter_input_arb_result(filter_input_arb_result),
    .i_filter_output_arb_result(filter_output_arb_result),  
    .i_pair_selected_valid(pair_selected_valid), 
    .i_nb_selected(nb_selected), 
    .i_node_id_selected(node_id_selected),
    .i_home_selected_parid(home_selected_parid), 
    .i_nb_reg_release_flag(nb_reg_release_flag), 
    
    .o_nb_data(nb_data), 
    .o_node_id(nb_node_id), 
    .o_nb_from_home_cell_flag(nb_from_home_cell_flag), 
    .o_home_pos(home_pos), 
    .o_home_parid(home_parid), 
    .o_home_element(home_element), 
    .o_filter_input_arb_result_delay_1(filter_input_arb_result_delay_1), 
    .o_filter_input_arb_result_delay_2(filter_input_arb_result_delay_2), 
    .o_filter_output_arb_result_delay_1(filter_output_arb_result_delay_1), 
    .o_filter_output_arb_result_delay_3(o_acc_reg_select), 
    .o_pair_selected_valid(o_pair_valid), 
    .o_nb_selected(o_nb_reg), 
    .o_node_id_selected(o_node_id_reg), 
    .o_home_selected_parid(o_home_parid), 
    .o_nb_reg_release_flag_delay_2(o_nb_release_flag)
);

// pack home pos for output
logic [OFFSET_STRUCT_WIDTH-1:0] dup_pos_cache_readout;
assign o_home_pos[DATA_WIDTH-1:0]               = {CELL_2, dup_pos_cache_readout[OFFSET_WIDTH-1:0]};
assign o_home_pos[2*DATA_WIDTH-1:DATA_WIDTH]    = {CELL_2, dup_pos_cache_readout[2*OFFSET_WIDTH-1:OFFSET_WIDTH]};
assign o_home_pos[3*DATA_WIDTH-1:2*DATA_WIDTH]  = {CELL_2, dup_pos_cache_readout[3*OFFSET_WIDTH-1:2*OFFSET_WIDTH]};

// 3 cycles cooldown
assign filter_input_nb_request_flag = nb_reg_request & 
                                      ~filter_input_arb_result_delay_1 &
                                      ~filter_input_arb_result_delay_2 &  
                                      ~back_pressure; 
	
FIFO_86W512D dispatcher_buffer
(
	 .clk(clk),
	 .srst(rst), 
	 .din({i_nb_data, i_node_id}),
	 .wr_en(i_nb_data_valid),
	 .rd_en(dispatcher_buffer_rden),      // Only starts when MD_state == 3, otherwise remote pos are lost
	 
	 .empty(o_dispatcher_buffer_empty),
	 .dout(dispatcher_buffer_readout),
	 .prog_full(o_dispatcher_back_pressure)
);
logic filter_input_arbiter_en;
assign filter_input_arbiter_en = ~o_dispatcher_buffer_empty & i_pos_spinning;      
assign dispatcher_buffer_rden = |filter_input_arb_result;
assign nb_reg_release_flag = |nb_reg_release;

round_robin_arbiter filter_input_arbiter       // Select which filter should the nb paricle enter
(
	.clk(clk), 
	.rst(rst), 
	.i_request(filter_input_nb_request_flag), 
	.i_arbiter_en(filter_input_arbiter_en), 
	
	.o_grant(filter_input_arb_result) 
);

genvar i;	
generate
	for (i = 0; i < NUM_FILTERS; i++)
		begin: filters
		filter_logic filter_logic
		(
		    .clk(clk), 
		    .rst(rst), 
			.i_home_pos(home_pos[i/2]), 	// Shared
			.i_home_parid(home_parid[i/2]), 	// Shared
			.i_nb_pos(nb_data[i/2]), // Shared but requires valid
			.i_nb_node_id(nb_node_id[i/2]),
			.i_nb_from_home_cell_flag(nb_from_home_cell_flag[i/2]), // Shared but requires valid
			.i_nb_valid(filter_input_arb_result_delay_2[i]),     // Delay 2 cycles to wait for nb_data
			.i_buffer_rd_en(filter_output_arb_result[i]), 
			
			.o_nb_reg(nb_reg[i]), 
			.o_node_id_reg(node_id_reg[i]),
			.o_nb_reg_release(nb_reg_release[i]), 
			.o_nb_reg_request(nb_reg_request[i]), 
			.o_filter_output_request(filter_output_request[i]),  						// If empty, cannot be arbitrated
			.o_buffer_rd_data(filter_buffer_readout[i]), 	// Used to obtain home pos data
			.o_buffer_rd_data_valid(filter_buffer_readout_valid[i]),
			.o_back_pressure(back_pressure[i]), 		// Tell the dispatcher stop feeding nb data into this filter
			.o_filtering_flag(o_filtering_flag[i]),
			.o_buffer_empty(filter_buffer_empty[i])
		);
		end
endgenerate

logic [NUM_FILTERS-1:0]                     raw_filter_output_arb_result;
logic [NUM_FILTERS-1:0]                     cooldown_mask;
logic [NUM_FILTERS-1:0][COOLDOWN_WIDTH-1:0] cooldown_cnt;

round_robin_arbiter filter_output_arbiter
(
	.clk(clk), 
	.rst(rst), 
	.i_request(filter_output_request), 
	.i_arbiter_en(1'b1),   // Always enabled, arbitrate whenever a filter buffer is not empty 
	
	.o_grant(raw_filter_output_arb_result)
);

assign filter_output_arb_result = raw_filter_output_arb_result & cooldown_mask;

integer j;
always@(posedge clk) begin
    if (rst) begin
        cooldown_cnt <= 0;
    end
    else begin
        for (j = 0; j < NUM_FILTERS; j++) begin: cooldown_ctrl
            if (cooldown_cnt[j] == 0) begin
                if (raw_filter_output_arb_result[j]) begin
                    cooldown_cnt[j] <= cooldown_cnt[j] + 1'b1;
                end
            end
            else if (cooldown_cnt[j] == NUM_COOLDOWN_CYCLES) begin
                cooldown_cnt[j] <= 0;
            end
            else begin
                cooldown_cnt[j] <= cooldown_cnt[j] + 1'b1;
            end
        end
    end
end
always@(*) begin
    for (j = 0; j < NUM_FILTERS; j++) begin: cooldown_mask_ctrl
        cooldown_mask[j] = cooldown_cnt[j] == {(COOLDOWN_WIDTH){1'b0}};
    end
end

pair_select pair_select
(
    .clk(clk), 
    .rst(rst), 
    .i_filter_output_arb_result(filter_output_arb_result_delay_1), 
    .i_nb_reg(nb_reg), 
    .i_node_id_reg(node_id_reg),
    .i_filter_buffer_readout(filter_buffer_readout), 
    .i_filter_buffer_readout_valid(filter_buffer_readout_valid),
    
    .o_nb_selected(nb_selected), 
    .o_node_id_selected(node_id_selected),
    .o_home_selected_parid(home_selected_parid), 
    .o_pair_selected_valid(pair_selected_valid)
);


POS_CACHE dup_pos_cache		// Stores home offset
(
	.clk(clk), 
	.i_data({i_home_data[OFFSET_STRUCT_WIDTH-1:0], i_home_data[OFFSET_STRUCT_WIDTH +: ELEMENT_WIDTH]}), 
	.i_wr_addr(i_home_data[OFFSET_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH]), 
	.i_wr_en(i_home_data_valid), 
	.i_rd_addr(home_selected_parid), 
	.i_rd_en(pair_selected_valid), 
	
	.o_data({dup_pos_cache_readout, o_home_element})
);

endmodule
