`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 09:29:29 PM
// Design Name: 
// Module Name: motion_update
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Read from force caches, pos caches, and velocity caches
//     Write to pos caches and velocity caches
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module motion_update
(
	input                                      clk,
	input                                      rst,
	input                                      MU_start,			// Only need to keep high for 1 cycle
	input [ELEMENT_WIDTH-1:0]                  i_element, 
	input [OFFSET_STRUCT_WIDTH-1:0]            i_offset,
	input [FLOAT_STRUCT_WIDTH-1:0]             i_frc,
	input [FLOAT_STRUCT_WIDTH-1:0]             i_vel,
	input                                      i_data_valid,
	input [MU_ID_WIDTH-1:0]                    i_MU_id, 
	
	output logic                               o_rd_en, 
	output logic [PARTICLE_ID_WIDTH-1:0]       o_rd_addr, 
	output [OFFSET_STRUCT_WIDTH-1:0]           o_offset,
	output logic [FLOAT_STRUCT_WIDTH-1:0]      o_vel,
	output logic [ELEMENT_WIDTH-1:0]           o_element, 
	output logic                               o_data_valid, 
	output logic [MU_ID_WIDTH-1:0]             o_MU_id, 
	output logic [PARTICLE_ID_WIDTH-1:0]       debug_MU_particle_num, 
	// Particle migration
	output [1:0]                               cell_x_offset,
	output [1:0]                               cell_y_offset,
	output [1:0]                               cell_z_offset
);
	
	logic [FLOAT_STRUCT_WIDTH-1:0]     evaluated_vel;		  // {vz, vy, vx}
	logic [FLOAT_STRUCT_WIDTH-1:0]     evaluated_disp;		  // {dz, dy, dx}
	logic                              evaluated_data_valid;
	logic [ELEMENT_WIDTH-1:0]          delay_element;
	logic [OFFSET_STRUCT_WIDTH-1:0]    delay_offset;
	logic [MU_ID_WIDTH-1:0]            delay_MU_id;
	
	always@(posedge clk) begin
	   if (rst) begin
           o_vel        <= 0;
           o_element    <= 0;
           o_data_valid <= 0;
           o_MU_id      <= 0;
	   end
	   else begin
           o_vel        <= evaluated_vel;
           o_element    <= delay_element;
           o_data_valid <= evaluated_data_valid;
           o_MU_id      <= delay_MU_id;
	   end
	end
	
	/////////////////////////////////////////////////////////////////////////////////////////////////
	// Postion and velocity information read FSM
	// After the read address is assigned, there are 2 cycles delay when the value is read out
	// Plus, there's one cycle delay when assign the read address
	/////////////////////////////////////////////////////////////////////////////////////////////////
	enum {WAIT_FOR_START, READ_PARTICLE_NUM, READ_PARTICLE_INFO, MOTION_UPDATE_DONE} state;
	logic [PARTICLE_ID_WIDTH-1:0] particle_num;
											// Assign the valid signal after 2 cycles when a valid address is assigned
	always@(posedge clk) begin
		if(rst) begin
			particle_num <= 0;
			debug_MU_particle_num <= 0;
			o_rd_addr <= 0;
			o_rd_en <= 1'b0;
			state <= WAIT_FOR_START;
		end
		else begin
			case(state)
				// While wait for the start signal, read in the particle num first
				WAIT_FOR_START: begin
					particle_num <= 0;
					o_rd_addr <= 0;
					if(MU_start) begin
						state <= READ_PARTICLE_NUM;
						o_rd_en <= 1'b1;
					end
					else begin
						state <= WAIT_FOR_START;
						o_rd_en <= 1'b0;
					end
				end
				
				// There are a total of 3 cycles delay to read from the data in the particle cache
				// 2 cycles from the memory module
				// 1 cycle to assign the address value
				READ_PARTICLE_NUM: begin
					particle_num <= i_offset[PARTICLE_ID_WIDTH-1:0];
					o_rd_addr <= o_rd_addr + 1'b1;									// Start to increment the read address
					o_rd_en <= 1'b1;
					if(i_data_valid) begin
						state <= READ_PARTICLE_INFO;
						debug_MU_particle_num <= i_offset[PARTICLE_ID_WIDTH-1:0];
					end
					else begin
						state <= READ_PARTICLE_NUM;
					end
				end
				
				// Consecutively read out particle data one by one
				READ_PARTICLE_INFO: begin
					// Wait for one more cycle here to let the particle num read out
					if(o_rd_addr < particle_num) begin	// Not including the offset bits
						o_rd_addr <= o_rd_addr + 1'b1;								// Keep incrementing the read address
					    o_rd_en   <= 1'b1;
						state <= READ_PARTICLE_INFO;
					end
					else begin
						o_rd_addr <= 0;												// After read is done, reset the read address
					    o_rd_en   <= 1'b0;
						state <= MOTION_UPDATE_DONE;
					end
				end
				
				// Set the done signal, initialize the control signals
				MOTION_UPDATE_DONE: begin
					particle_num <= 0;										// Reset delay counter
					o_rd_addr <= 0;													// Reset the read address
					o_rd_en <= 1'b0;						// Clear motion update enable signal
					state <= WAIT_FOR_START;
				end
			endcase
		end
	end
	
	float2fixed_3x inst_float_fixed_converter (
		.clk              ( clk                       ), 
		.rst              ( rst                       ), 
		.disp             ( evaluated_disp            ),
		.offset_in        ( delay_offset              ), 
		
		.cell_x_offset    ( cell_x_offset             ), 
		.cell_y_offset    ( cell_y_offset             ), 
		.cell_z_offset    ( cell_z_offset             ), 
		.offset_out       ( o_offset                  )
	);
	
	logic [FLOAT_WIDTH-1:0] coeff;
	always@(*) begin
		case(i_element)
			2'b01: begin
				coeff = NA_COEFF;
			end
			2'b10: begin
				coeff = CL_COEFF;
			end
			default: begin
				coeff = 0;
			end
		endcase
	end
		
	MU_PIPELINE inst_MU_PPL (
	   .clk                ( clk                                   ),
	   .i_fx               ( i_frc[FLOAT_WIDTH-1:0]                ),
	   .i_fy               ( i_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    ),
	   .i_fz               ( i_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  ),
	   .i_coeff            ( coeff                 ),
	   .i_vx               ( i_vel[FLOAT_WIDTH-1:0]                ),
	   .i_vy               ( i_vel[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    ),
	   .i_vz               ( i_vel[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  ),
	   .i_valid            ( i_data_valid & state != READ_PARTICLE_NUM     ),  // Invalidate the first data (num_particles)
	   .i_time_step        ( REDUCED_TIME_STEP                             ),
	   .i_delay_signals    ( {i_offset, i_MU_id, i_element}                ),
	   
	   .o_dx               ( evaluated_disp[FLOAT_WIDTH-1:0]               ),
	   .o_dy               ( evaluated_disp[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ),
	   .o_dz               ( evaluated_disp[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH] ),
	   .o_vx               ( evaluated_vel[FLOAT_WIDTH-1:0]                ),
	   .o_vy               ( evaluated_vel[2*FLOAT_WIDTH-1:FLOAT_WIDTH]    ),
	   .o_vz               ( evaluated_vel[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]  ),
	   .o_data_valid       ( evaluated_data_valid  ),
	   .o_delay_signals    ( {delay_offset, delay_MU_id, delay_element})
	);
	
endmodule
