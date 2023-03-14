`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 10:48:34 PM
// Design Name: 
// Module Name: RAW_handler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     2 Registers used to handle RAW. 
//     Reg behaviors are determined by the input instructions
//     Data from regs may only go to acc input
//     Data movements are scheduled
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module RAW_handler
#(
	parameter PARTICLE_ID_WIDTH = 9, 
	parameter COUNTDOWN_WIDTH = 1
)
(
	input clk, 
	input rst, 
	input [COUNTDOWN_WIDTH-1:0] i_countdown, 
	input float_data_t i_data, 
	input i_valid, 
	
	output float_data_t o_data_to_acc, 
	output logic o_data_to_acc_valid
);

float_data_t reg_a;
float_data_t reg_b;
logic [COUNTDOWN_WIDTH-1:0] reg_a_countdown;
logic [COUNTDOWN_WIDTH-1:0] reg_b_countdown;
logic reg_a_valid;
logic reg_b_valid;

// In theory, A and B won't release at the same time
always@(*)
	begin
	if (reg_a_valid && reg_a_countdown == 0)
		begin
		o_data_to_acc = reg_a;
		o_data_to_acc_valid = 1'b1;
		end
	else if (reg_b_valid && reg_b_countdown == 0)
		begin
		o_data_to_acc = reg_b;
		o_data_to_acc_valid = 1'b1;
		end
	else
		begin
		o_data_to_acc = 0;
		o_data_to_acc_valid = 1'b0;
		end
	end

always@(posedge clk)
	begin
	if (rst)
		begin
		reg_a <= 0;
		reg_b <= 0;
		reg_a_countdown <= 0;
		reg_b_countdown <= 0;
		reg_a_valid <= 1'b0;
		reg_b_valid <= 1'b0;
		end
	else
		begin
		if (i_valid)
			begin
			if (reg_a_countdown == 0)	// Data go to A
				begin
				if (reg_b_countdown == 0)	// The other reg countdown, if already zero, invalidate
					begin
					reg_b_valid <= 1'b0;
					end
				else
					begin
					reg_b_countdown <= reg_b_countdown - 1'b1;
					end
				reg_a <= i_data;
				reg_a_countdown <= i_countdown;
				reg_a_valid <= i_valid;
				end
			else if (reg_b_countdown == 0)	// Data go to B
				begin
				if (reg_a_countdown == 0)
					begin
					reg_a_valid <= 1'b0;
					end
				else
					begin
					reg_a_countdown <= reg_a_countdown - 1'b1;
					end
				reg_b <= i_data;
				reg_b_countdown <= i_countdown;
				reg_b_valid <= i_valid;
				end
			end
		else
			begin
			if (reg_a_countdown == 0)
				begin
				reg_a_valid <= 1'b0;
				end
			else
				begin
				reg_a_countdown = reg_a_countdown - 1'b1;
				end
			if (reg_b_countdown == 0)
				begin
				reg_b_valid <= 1'b0;
				end
			else
				begin
				reg_b_countdown = reg_b_countdown - 1'b1;
				end
			end
		end
	end

endmodule