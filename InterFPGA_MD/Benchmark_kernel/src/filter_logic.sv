//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 05:12:41 PM
// Design Name: 
// Module Name: filter_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Includes a filter and a filter buffer
//     Filter: 8-bit Planar method, fixed point
//     Filter buffer: Contains home particle ID and nb change flag
//     Buffer rden: Controlled by the filter arbiter
//     Buffer data read out after 1 cycle delay
//     Input valid: Nb particle valid
//     If the particle has not done evaluating, the filter is NOT accepting another neighbor particle
//     rst state: nb discard flag high, requesting next nb, 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module filter_logic (
	input                              clk, 
	input                              rst, 
	input [POS_STRUCT_WIDTH-1:0]       i_home_pos, 
	input [POS_PKT_STRUCT_WIDTH-1:0]   i_nb_pos, 
	input [NODE_ID_WIDTH-1:0]          i_nb_node_id,
	input                              i_nb_from_home_cell_flag, 
	input [PARTICLE_ID_WIDTH-1:0]      i_home_parid, 
	input i_buffer_rd_en, 
	input i_nb_valid, 
	
	output [PARTICLE_ID_WIDTH-1:0]     o_buffer_rd_data,
	output [POS_PKT_STRUCT_WIDTH-1:0]  o_nb_reg, 
	output [NODE_ID_WIDTH-1:0]         o_node_id_reg,
	output o_nb_reg_release, 									// Used to release the current nb and request another nb
	output o_nb_reg_request,       // Request nb from dispatcher
	output o_filter_output_request,   // Request frc arbitration & release from filter_output_arbiter 
	output logic o_buffer_rd_data_valid, // If reads from the buffer when the buffer is empty, meaning release, and the output invalidated
	output logic o_back_pressure,
	output logic o_filtering_flag,
	output logic o_buffer_empty
);


logic pass;
logic almost_full;
logic buffer_empty;
logic nb_from_home_cell;
logic transaction_ready;
//logic filtering_flag;
logic filtering_flag_delay_1;
logic filtering_flag_delay_2;       // Delay 2 cycles to handle: the buffer may be empty when filtering is done, but the last data still can be written to it
logic release_trigger;
logic filter_input_valid;
logic d1_buffer_rd_en;

assign o_buffer_empty = buffer_empty;

always@(posedge clk)
    begin
    if (rst)
        begin
        release_trigger <= 1'b0;
        end
    else
        begin
        if (~transaction_ready)   // Make sure release trigger is down at least 1 cycle after transaction_ready
            begin
            release_trigger <= 1'b1;
            end 
        else if (d1_buffer_rd_en)    // 2 cases, empty after read or reading empty. Either way, should release.
            begin
            release_trigger <= 1'b0;
            end
        end
    end

assign transaction_ready = ~o_filtering_flag & ~filtering_flag_delay_1 & ~filtering_flag_delay_2 & buffer_empty;
assign o_nb_reg_request = transaction_ready & ~nb_reg_release;
assign nb_reg_release = transaction_ready & release_trigger & ~d1_buffer_rd_en;
assign o_filter_output_request = ~buffer_empty | nb_reg_release;// & ~d1_buffer_rd_en);
assign o_nb_reg_release = transaction_ready & d1_buffer_rd_en;
//assign o_nb_reg_release = buffer_empty & d1_buffer_rd_en & nb_reg_release;

always@(*)		// Special controls for nb from home cell
	begin
	if (nb_from_home_cell && o_nb_reg[POS_STRUCT_WIDTH+ELEMENT_WIDTH +: PARTICLE_ID_WIDTH] >= i_home_parid)
		begin
		filter_input_valid = 0;
		end
	else
		begin
		filter_input_valid = o_filtering_flag;
		end
	end
	
filter_logic_FSM filter_logic_FSM(   // nb position is registered inside
    .clk(clk), 
    .rst(rst), 
    .i_home_parid(i_home_parid), 
    .i_nb_pos(i_nb_pos), 
    .i_nb_node_id(i_nb_node_id),
    .i_nb_from_home_cell_flag(i_nb_from_home_cell_flag), 
    .i_nb_valid(i_nb_valid), 
    .i_almost_full(almost_full), 
    
    .o_nb_reg(o_nb_reg), 
    .o_node_id_reg(o_node_id_reg),
    .o_nb_from_home_cell(nb_from_home_cell), 
    .o_filtering_flag(o_filtering_flag),
    .o_back_pressure(o_back_pressure)
);

// Filter
planar_filter planar_filter
(
	.clk(clk), 
	.rst(rst),
	.i_input_valid(filter_input_valid), 									// If at filtering state, valid
	.i_home_x(i_home_pos[DATA_WIDTH-1:OFFSET_WIDTH-BODY_BITS]),		// Only need the leading bits
	.i_home_y(i_home_pos[2*DATA_WIDTH-1:DATA_WIDTH+OFFSET_WIDTH-BODY_BITS]),
	.i_home_z(i_home_pos[3*DATA_WIDTH-1:2*DATA_WIDTH+OFFSET_WIDTH-BODY_BITS]),
	.i_nb_x(o_nb_reg[DATA_WIDTH-1:OFFSET_WIDTH-BODY_BITS]),
	.i_nb_y(o_nb_reg[2*DATA_WIDTH-1:DATA_WIDTH+OFFSET_WIDTH-BODY_BITS]),
	.i_nb_z(o_nb_reg[3*DATA_WIDTH-1:2*DATA_WIDTH+OFFSET_WIDTH-BODY_BITS]),

	.o_pass(pass)
);

// Buffer writing control (data & enable)
logic [PARTICLE_ID_WIDTH-1:0] buffer_wr_data;
always@(posedge clk)
    begin
    if (rst)
        begin
        buffer_wr_data <= 0;
        d1_buffer_rd_en <= 0;
        filtering_flag_delay_1 <= 0;
        filtering_flag_delay_2 <= 0;
        o_buffer_rd_data_valid <= 0;
        end
    else
        begin
        buffer_wr_data <= i_home_parid;
        d1_buffer_rd_en <= i_buffer_rd_en;
        filtering_flag_delay_1 <= o_filtering_flag;
        filtering_flag_delay_2 <= filtering_flag_delay_1;
        o_buffer_rd_data_valid <= i_buffer_rd_en & (~buffer_empty);
        end
    end
logic buffer_wr_en;
assign buffer_wr_en = pass;


FIFO_9W512D filter_buffer	// If buffer just becomes empty, buffer_rd_en is 0 immediately no need to stop reading before empty
(
    .clk(clk), 
    .srst(rst), 
    .din(buffer_wr_data), 
    .wr_en(buffer_wr_en), 
    .rd_en(i_buffer_rd_en), 
    
    .empty(buffer_empty), 
    .dout(o_buffer_rd_data), 
    .prog_full(almost_full)
);


endmodule