`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2022 09:12:31 PM
// Design Name: 
// Module Name: motion_update_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     Send read address and read request to caches
//     Data return
//     Process and figure out which cache to write back
//     Send data and valid signal to caches
//     Caches record data based on their own address counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

import MD_pkg::*;

module motion_update_control #(
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_X[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Y[NUM_CELL_FOLDS] = '{3'h0},
    parameter logic [GLOBAL_CELL_ID_WIDTH-1:0] GCELL_Z[NUM_CELL_FOLDS] = '{3'h0}
)
(
    input                                              clk,
	input                                              rst,
	input                                              MU_start,
	input [FLOAT_STRUCT_WIDTH*NUM_PES_PER_CELL-1:0]    i_home_frc,
	input [FLOAT_STRUCT_WIDTH-1:0]                     i_nb_frc,
	input [OFFSET_STRUCT_WIDTH-1:0]                    i_offset, 
	input [FLOAT_STRUCT_WIDTH-1:0]                     i_vel,
	input [ELEMENT_WIDTH-1:0]                          i_element,
	input                                              i_data_valid,
	
	input [MU_ID_WIDTH-1:0]                            i_MU_id,
	input [OFFSET_STRUCT_WIDTH-1:0]                    i_offset_fwd,
	input [FLOAT_STRUCT_WIDTH-1:0]                     i_vel_fwd,
	input [ELEMENT_WIDTH-1:0]                          i_element_fwd,
	input                                              i_fwd_valid,
	
	output logic [OFFSET_STRUCT_WIDTH-1:0]             o_offset, 
	output logic [FLOAT_STRUCT_WIDTH-1:0]              o_vel, 
	output logic [ELEMENT_WIDTH-1:0]                   o_element, 
	output logic                                       o_data_valid, 
	
	output logic [MU_ID_WIDTH-1:0]                     o_MU_id, 
	output logic [OFFSET_STRUCT_WIDTH-1:0]             o_offset_fwd, 
	output logic [FLOAT_STRUCT_WIDTH-1:0]              o_vel_fwd, 
	output logic [ELEMENT_WIDTH-1:0]                   o_element_fwd, 
	output logic                                       o_fwd_valid, 
	// Reading control
	output logic [PARTICLE_ID_WIDTH-1:0]               o_rd_addr, 
	output logic                                       o_rd_en,
	output                                             o_MU_buf_full,
	output                                             o_MU_buf_empty,
	output logic [FLOAT_STRUCT_WIDTH-1:0]              o_debug_vel,
	output logic                                       o_debug_vel_valid,
	output logic [PARTICLE_ID_WIDTH-1:0]               o_debug_particle_num, 
	output logic                                       o_debug_migration       // flag
);

logic [MU_ID_WIDTH-1:0]             local_MU_id;
logic [MU_ID_WIDTH-1:0]             delay_MU_id;
logic [MU_ID_WIDTH-1:0]             dst_MU_id;

logic [ELEMENT_WIDTH-1:0]           new_element;
logic [OFFSET_STRUCT_WIDTH-1:0]     new_offset;
logic [FLOAT_STRUCT_WIDTH-1:0]      new_vel;
logic                               new_data_valid;

localparam MU_ID = GCELL_X[0]*Y_DIM*Z_DIM+GCELL_Y[0]*Z_DIM+GCELL_Z[0];
assign local_MU_id = MU_ID;

assign o_debug_vel = new_vel;
assign o_debug_vel_valid = new_data_valid;
always@(posedge clk) begin
    if (rst) begin
        o_debug_migration <= 0;
    end
    else if (cell_x_offset != 2'b00 | cell_y_offset != 2'b00 | cell_z_offset != 2'b00) begin
        o_debug_migration <= 1'b1;
    end
end

logic [1:0]                         cell_x_offset;
logic [1:0]                         cell_y_offset;
logic [1:0]                         cell_z_offset;

dst_cell_id_calculator #(
    .GCELL_X    ( GCELL_X   ),
    .GCELL_Y    ( GCELL_Y   ),
    .GCELL_Z    ( GCELL_Z   )
) 
dst_cell_id_calculator (
	.clk           ( clk           ), 
	.rst           ( rst           ), 
	.src_cell_id   ( delay_MU_id   ),
	.cell_x_offset ( cell_x_offset ), 
	.cell_y_offset ( cell_y_offset ), 
	.cell_z_offset ( cell_z_offset ), 
	
	.dst_MU_id     ( dst_MU_id     )
);
	
logic                           buf_rden;
logic                           buf_wren;
logic [MU_PKT_STRUCT_WIDTH-1:0] MU_packet_buf;
logic [MU_PKT_STRUCT_WIDTH-1:0] MU_packet_buf_out;
logic                           buf_out_valid;
logic                           buf_out_invalid;

assign buf_out_valid = ~buf_out_invalid; 
assign o_MU_buf_empty = buf_out_invalid;
assign buf_rden = i_fwd_valid ? 1'b0 : buf_out_valid;		// Read acknowledgement, first word falls through

MU_OUT_BUF MU_out_buffer
(
	.clk           ( clk               ), 
	.rst           ( rst               ), 
	.rd_en         ( buf_rden          ), 
	.wr_en         ( buf_wren          ), 
	.data_in       ( MU_packet_buf     ), 
	
	.data_out      ( MU_packet_buf_out ), 
	.empty         ( buf_out_invalid   ), 
	.almost_full   ( o_MU_buf_full     )
);

// Data to migrate is stored in buffer first
always@(posedge clk) begin
	if (rst) begin
		MU_packet_buf                 <= 0;
		buf_wren                      <= 0;
	end
	else begin
		MU_packet_buf[OFFSET_STRUCT_WIDTH-1:0]                                            <= new_offset;
		MU_packet_buf[OFFSET_STRUCT_WIDTH +: FLOAT_STRUCT_WIDTH]                          <= new_vel;
		MU_packet_buf[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH +: ELEMENT_WIDTH]            <= new_element;
		MU_packet_buf[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH+ELEMENT_WIDTH +: MU_ID_WIDTH] <= dst_MU_id;
		buf_wren                                                                          <= new_data_valid;
	end
end

always@(posedge clk) begin
	if (rst) begin
		o_data_valid   <= 0;
		o_offset       <= 0;
		o_vel          <= 0;
		o_element      <= 0;
		o_fwd_valid    <= 0;
		o_offset_fwd   <= 0;
		o_vel_fwd      <= 0;
		o_element_fwd  <= 0;
		o_MU_id        <= 0;
	end
	else begin
		if (i_fwd_valid) begin	// Data from the ring valid, return or forward
			if (i_MU_id == MU_ID) begin	// Return if IDs match
				o_data_valid    <= 1'b1;
				o_offset        <= i_offset_fwd;
				o_vel           <= i_vel_fwd;
				o_element       <= i_element_fwd;
		        o_fwd_valid     <= 1'b0;
			end
			else begin					// Forward
				o_data_valid    <= 1'b0;
				o_offset_fwd    <= i_offset_fwd;
				o_vel_fwd       <= i_vel_fwd;
				o_element_fwd   <= i_element_fwd;
				o_MU_id         <= i_MU_id;
		        o_fwd_valid     <= 1'b1;
			end
		end
		else begin											// No valid incoming data, check the buffer
			if (buf_out_valid) begin // Data from the buffer valid, return or forward
				if (MU_packet_buf_out[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH+ELEMENT_WIDTH +: MU_ID_WIDTH] == MU_ID) begin	 		// Return if IDs match
					o_data_valid   <= 1'b1;
					o_offset       <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH-1:0];
					o_vel          <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH +: FLOAT_STRUCT_WIDTH];
					o_element      <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH +: ELEMENT_WIDTH];
					o_fwd_valid    <= 1'b0;
				end
				else begin				// Forward
					o_data_valid   <= 1'b0;
					o_offset_fwd   <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH-1:0];
					o_vel_fwd      <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH +: FLOAT_STRUCT_WIDTH];
					o_element_fwd  <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH +: ELEMENT_WIDTH];
					o_MU_id        <= MU_packet_buf_out[OFFSET_STRUCT_WIDTH+FLOAT_STRUCT_WIDTH+ELEMENT_WIDTH +: MU_ID_WIDTH];
					o_fwd_valid    <= 1'b1;
				end
			end
			else begin				// Do nothing
				o_data_valid    <= 0;
				o_fwd_valid     <= 0;
			end
		end
	end
end

logic [ELEMENT_WIDTH-1:0]       d1_element;
logic [ELEMENT_WIDTH-1:0]       d2_element;
logic [ELEMENT_WIDTH-1:0]       d3_element;
logic [ELEMENT_WIDTH-1:0]       d4_element;
logic [ELEMENT_WIDTH-1:0]       d5_element;
logic [ELEMENT_WIDTH-1:0]       d6_element;
logic [OFFSET_STRUCT_WIDTH-1:0] d1_offset;
logic [OFFSET_STRUCT_WIDTH-1:0] d2_offset;
logic [OFFSET_STRUCT_WIDTH-1:0] d3_offset;
logic [OFFSET_STRUCT_WIDTH-1:0] d4_offset;
logic [OFFSET_STRUCT_WIDTH-1:0] d5_offset;
logic [OFFSET_STRUCT_WIDTH-1:0] d6_offset;
logic [FLOAT_STRUCT_WIDTH-1:0]  d1_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  d2_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  d3_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  d4_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  d5_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  d6_vel;
logic [FLOAT_STRUCT_WIDTH-1:0]  sum_frc_0;
logic [FLOAT_STRUCT_WIDTH-1:0]  sum_frc_1;
logic [FLOAT_STRUCT_WIDTH-1:0]  sum_frc;
logic                           sum_frc_valid_0;
logic                           sum_frc_valid_1;
logic                           sum_frc_valid;

always@(posedge clk) begin
    d1_element  <= i_element;
    d2_element  <= d1_element;
    d3_element  <= d2_element;
    d4_element  <= d3_element;
    d5_element  <= d4_element;
    d6_element  <= d5_element;
    d1_vel      <= i_vel;
    d2_vel      <= d1_vel;
    d3_vel      <= d2_vel;
    d4_vel      <= d3_vel;
    d5_vel      <= d4_vel;
    d6_vel      <= d5_vel;
    d1_offset   <= i_offset;
    d2_offset   <= d1_offset;
    d3_offset   <= d2_offset;
    d4_offset   <= d3_offset;
    d5_offset   <= d4_offset;
    d6_offset   <= d5_offset;
end

FRC_ADD_XYZ frc_combine_lv0_0 (
    .clk            ( clk           ), 
    .frc_x1         ( i_home_frc[FLOAT_WIDTH-1:0]               ), 
    .frc_y1         ( i_home_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ), 
    .frc_z1         ( i_home_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH] ), 
    .frc_valid_1    ( i_data_valid  ),
    .frc_x2         ( i_nb_frc[FLOAT_WIDTH-1:0]                 ), 
    .frc_y2         ( i_nb_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]     ), 
    .frc_z2         ( i_nb_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .frc_valid_2    ( i_data_valid  ),
    
    .frc_acc_x      ( sum_frc_0[FLOAT_WIDTH-1:0]                  ),
    .frc_acc_y      ( sum_frc_0[2*FLOAT_WIDTH-1:FLOAT_WIDTH]      ),
    .frc_acc_z      ( sum_frc_0[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]    ),
    .frc_acc_valid  ( sum_frc_valid_0 )
);
    
FRC_ADD_XYZ frc_combine_lv0_1 (
    .clk            ( clk           ), 
    .frc_x1         ( i_home_frc[4*FLOAT_WIDTH-1:3*FLOAT_WIDTH]   ), 
    .frc_y1         ( i_home_frc[5*FLOAT_WIDTH-1:4*FLOAT_WIDTH]   ), 
    .frc_z1         ( i_home_frc[6*FLOAT_WIDTH-1:5*FLOAT_WIDTH]   ), 
    .frc_valid_1    ( i_data_valid  ),
    .frc_x2         ( i_home_frc[7*FLOAT_WIDTH-1:6*FLOAT_WIDTH]   ), 
    .frc_y2         ( i_home_frc[8*FLOAT_WIDTH-1:7*FLOAT_WIDTH]   ), 
    .frc_z2         ( i_home_frc[9*FLOAT_WIDTH-1:8*FLOAT_WIDTH]   ), 
    .frc_valid_2    ( i_data_valid  ),
    
    .frc_acc_x      ( sum_frc_1[FLOAT_WIDTH-1:0]                  ),
    .frc_acc_y      ( sum_frc_1[2*FLOAT_WIDTH-1:FLOAT_WIDTH]      ),
    .frc_acc_z      ( sum_frc_1[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]    ),
    .frc_acc_valid  ( sum_frc_valid_1 )
);
    
FRC_ADD_XYZ frc_combine_lv1 (
    .clk            ( clk           ), 
    .frc_x1         ( sum_frc_0[FLOAT_WIDTH-1:0]               ), 
    .frc_y1         ( sum_frc_0[2*FLOAT_WIDTH-1:FLOAT_WIDTH]   ), 
    .frc_z1         ( sum_frc_0[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH] ), 
    .frc_valid_1    ( sum_frc_valid_0  ),
    .frc_x2         ( sum_frc_1[FLOAT_WIDTH-1:0]                 ), 
    .frc_y2         ( sum_frc_1[2*FLOAT_WIDTH-1:FLOAT_WIDTH]     ), 
    .frc_z2         ( sum_frc_1[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]   ),
    .frc_valid_2    ( sum_frc_valid_1  ),
    
    .frc_acc_x      ( sum_frc[FLOAT_WIDTH-1:0]                  ),
    .frc_acc_y      ( sum_frc[2*FLOAT_WIDTH-1:FLOAT_WIDTH]      ),
    .frc_acc_z      ( sum_frc[3*FLOAT_WIDTH-1:2*FLOAT_WIDTH]    ),
    .frc_acc_valid  ( sum_frc_valid )
);

motion_update motion_update (
	.clk               ( clk               ),
	.rst               ( rst               ),
	.MU_start          ( MU_start          ),
	.i_frc             ( sum_frc           ),
	.i_offset          ( d6_offset         ),
	.i_vel             ( d6_vel            ),
	.i_element         ( d6_element        ), 
	.i_data_valid      ( sum_frc_valid     ),
	.i_MU_id           ( local_MU_id       ),
	
	.o_rd_en           ( o_rd_en           ),
	.o_rd_addr         ( o_rd_addr         ),
	.o_offset          ( new_offset        ),
	.o_vel             ( new_vel           ),
	.o_element         ( new_element       ),  
	.o_data_valid      ( new_data_valid    ), 
	.o_MU_id           ( delay_MU_id       ), 
	.debug_MU_particle_num         ( o_debug_particle_num         ),
	.cell_x_offset     ( cell_x_offset     ),
	.cell_y_offset     ( cell_y_offset     ),
	.cell_z_offset     ( cell_z_offset     )
);

endmodule