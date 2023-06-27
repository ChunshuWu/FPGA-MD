//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2022 11:38:21 PM
// Design Name: 
// Module Name: filter_logic_FSM
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

module filter_logic_FSM (
    input clk, 
    input rst, 
    input [PARTICLE_ID_WIDTH-1:0] i_home_parid, 
	input [POS_PKT_STRUCT_WIDTH-1:0] i_nb_pos, 
	input [NODE_ID_WIDTH-1:0]i_nb_node_id,
	input i_nb_from_home_cell_flag, 
	input i_nb_valid, 
	input i_almost_full, 

    output logic [POS_PKT_STRUCT_WIDTH-1:0] o_nb_reg,
	output logic [NODE_ID_WIDTH-1:0]o_node_id_reg,
    output logic o_nb_from_home_cell,
    output logic o_filtering_flag,
    output logic o_back_pressure
);
    
logic [PARTICLE_ID_WIDTH-1:0] target_home_parid;
logic [PARTICLE_ID_WIDTH-1:0] ckpt_home_parid;		// Used for back_pressure handling

enum bit[1:0] {WAITING, FILTERING, SPINNING} state;

always@(posedge clk) 
	begin
	if (rst) 
		begin
		o_nb_reg <= 0;
		o_node_id_reg <= 0;
		o_nb_from_home_cell <= 0;
		o_filtering_flag <= 0;
		o_back_pressure <= 0;
		target_home_parid <= 0;
		ckpt_home_parid <= 0;
		state <= WAITING;
		end
	else 
		begin
		case (state)
		WAITING:												// Waiting for particle evaluation and the next nb particle
			begin
			if (i_nb_valid)									// Incoming nb particle, stays high for 1 cycle
				begin
				target_home_parid <= i_home_parid;
				o_nb_reg <= i_nb_pos;
				o_node_id_reg <= i_nb_node_id;
				o_nb_from_home_cell <= i_nb_from_home_cell_flag;
				o_filtering_flag <= 1;
				state <= FILTERING;
				end
			end
		FILTERING:
			begin
			if (target_home_parid == i_home_parid)	// They meet again, nb particle finishes filtering
				begin
				o_filtering_flag <= 0;
				state <= WAITING;
				end
			else
				begin
				if (i_almost_full)							// Backpressure handling
					begin
					ckpt_home_parid <= i_home_parid;
					o_filtering_flag <= 0;
					o_back_pressure <= 1;
					state <= SPINNING;
					end
				end
			end
		SPINNING:											// Under backpressure
			begin
			if (i_home_parid == ckpt_home_parid && ~i_almost_full)		// Restore when ckpt is met
				begin
				state <= FILTERING;
				o_filtering_flag <= 1;
				o_back_pressure <= 0;
				end
			end
		endcase
		end
	end
	
endmodule
