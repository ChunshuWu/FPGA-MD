/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module: Velocity_Cache_x_y_z.sv
//
//	Function:
//				Velocity cache with double buffering for motion update
//				Holds the velocity value from previous motion update
//				Update the value after each motion update process
//
//	Purpose:
//				Providing particle velocity information for motion update
//				Have a secondary buffer to hold the new data after motion update process
//				During motion update process, the motion update module will broadcast the valid data and destination cell to all cells
//				Upon receiving valid particle data, first determine if this is the target destination cell
//
// Data Organization:
//				Address 0 for each cell module: # of particles in the cell
//				Velocity data: MSB-LSB: {vz, vy, vx}
//				Cell address: MSB-LSB: {cell_z, cell_y, cell_x}
//
// Used by:
//				RL_LJ_Top.v
//
// Dependency:
//				velocity_x_y_z.sv
//				cell_empty.v
//
// Testbench:
//				Refere to Pos_Cache_2_2_2_tb.v			(testing the swap function during motion update)
//				RL_LJ_Top_tb.v					(testing the correctness of read & write)
//
// Timing:
//				2 cycles reading delay from input address and output data.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module velocity_cache
(
	input                              clk,
	input                              rst,
	input                              i_MU_start,
	input                              i_MU_working,		// Keep this signal as high during the motion update process
	input [PARTICLE_ID_WIDTH-1:0]      i_MU_rd_addr,
	input                              i_MU_rd_en,
	input [FLOAT_STRUCT_WIDTH-1:0]     i_MU_wr_vel,
	input                              i_MU_wr_en,			// Signify if the new incoming data is valid
	//input in_wren,
	output [FLOAT_STRUCT_WIDTH-1:0]    o_MU_vel,
	output logic                       o_MU_vel_valid
);

	//////////////////////////////////////////////////////////////////////////////////////////////
	// Control FSM to switch between the 2 memory modules
	//////////////////////////////////////////////////////////////////////////////////////////////
	enum {WAIT_FOR_START, MOTION_UPDATE_PROCESS, MOTION_UPDATE_DONE} state;
	// Flag slecting which cell is the active one for processing
	logic                          cell_phase;
	// Counter for recording the # of new particles
	logic [PARTICLE_ID_WIDTH-1:0]  new_particle_counter;
	// Memory module control signal
	logic                          wr_en;
	logic [PARTICLE_ID_WIDTH-1:0]  wr_addr;
	logic [FLOAT_STRUCT_WIDTH-1:0] wr_vel;
	
	always@(posedge clk) begin
		if(rst) begin
			cell_phase           <= 1'b0;
			new_particle_counter <= 0;								// Counter starts from 1, to avoid write to Address 0
			wr_en                <= 1'b0;
			wr_addr              <= 0;
			wr_vel               <= 0;
			state <= WAIT_FOR_START;
			end
		else begin
			case(state)
				WAIT_FOR_START: begin
					if(i_MU_start) begin
						state <= MOTION_UPDATE_PROCESS;
						end
					else
						begin
						new_particle_counter <= 1;
						end
					end
				MOTION_UPDATE_PROCESS: begin
					if(i_MU_wr_en) begin
						new_particle_counter <= new_particle_counter + 1'b1;
					end
					if(~i_MU_working) begin
						state <= MOTION_UPDATE_DONE;
					end
				end
				MOTION_UPDATE_DONE: begin
					cell_phase <= ~cell_phase;
					new_particle_counter <= 1;
					state <= WAIT_FOR_START;
				end
			endcase
		end
	end

	//////////////////////////////////////////////////////////////////////////////////////////////
	// Signals connect to 2 cell memories
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	logic [FLOAT_STRUCT_WIDTH-1:0] vel_in_0, vel_in_1, vel_out_0, vel_out_1;
	logic [PARTICLE_ID_WIDTH-1:0] wr_addr_0, wr_addr_1, rd_addr_0, rd_addr_1;
	logic wr_en_0, wr_en_1;
	
	always@(*) begin
	   if (cell_phase == 0) begin
	       rd_addr_0   = i_MU_rd_addr;
	       rd_addr_1   = 0;
           wr_en_0     = 1'b0;
           wr_addr_0   = 0;
           vel_in_0    = 0;
	       if (i_MU_wr_en) begin
	           wr_en_1     = 1'b1;
	           wr_addr_1   = new_particle_counter;
	           vel_in_1    = i_MU_wr_vel;
	       end
	       else begin
	           wr_en_1     = 1'b0;
	           wr_addr_1   = 0;
	           vel_in_1    = 0;
	       end
	   end
	   else begin
	       rd_addr_0   = 0;
	       rd_addr_1   = i_MU_rd_addr;
           wr_en_1     = 1'b0;
           wr_addr_1   = 0;
           vel_in_1    = 0;
	       if (i_MU_wr_en) begin
	           wr_en_0     = 1'b1;
	           wr_addr_0   = new_particle_counter;
	           vel_in_0    = i_MU_wr_vel;
	       end
	       else begin
	           wr_en_0     = 1'b0;
	           wr_addr_0   = 0;
	           vel_in_0    = 0;
	       end
	   end
	end

	//////////////////////////////////////////////////////////////////////////////////////////////
	// Memory Modules
	//////////////////////////////////////////////////////////////////////////////////////////////
        // Original Cell with initial value
    VEL_CACHE vel_cell_0
    (
        .clk        ( clk       ), 
        .vel_in     ( vel_in_0  ), 
        .wr_addr    ( wr_addr_0 ), 
        .wr_en      ( wr_en_0   ), 
        .rd_addr    ( rd_addr_0 ), 
        
        .vel_out    ( vel_out_0 )
    );

	// Alternative cell
    VEL_CACHE vel_cell_1
    (
        .clk        ( clk       ), 
        .vel_in     ( vel_in_1  ), 
        .wr_addr    ( wr_addr_1 ), 
        .wr_en      ( wr_en_1   ), 
        .rd_addr    ( rd_addr_1 ), 
        
        .vel_out    ( vel_out_1 )
    );

    assign o_MU_vel = cell_phase ? vel_out_1 : vel_out_0;
    
    always@(posedge clk) begin
        if (rst) begin
            o_MU_vel_valid <= 1'b0;
        end
        else begin
            o_MU_vel_valid <= i_MU_rd_en;
        end
    end
    
endmodule	